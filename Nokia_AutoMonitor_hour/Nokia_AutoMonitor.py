import pandas
from pandas.core.frame import DataFrame
import openpyxl
import os
import sys
import multiprocessing
import cx_Oracle
import traceback
import datetime
import sqlite3
import csv
import time


class Main:

    def __init__(self):
        """初始化"""
        self.main_path = os.path.split(os.path.abspath(sys.argv[0]))[0]
        # 获取配置文件
        self.config_list = {}
        self.get_config()
        self.temp_time = time.strftime('%Y_%m_%d_%H_%M_%S', time.localtime())

    def get_config(self):
        # 初始化配置列表

        path_base_data = os.path.join(
            self.main_path,
            '_config',
            'config.xlsx')
        f_base_data_wb = openpyxl.load_workbook(path_base_data, read_only=True)
        for temp_sheet_name in f_base_data_wb.sheetnames:
            if temp_sheet_name not in self.config_list:
                self.config_list[temp_sheet_name] = {}
                temp_f_base_data_wb_sheet = f_base_data_wb[temp_sheet_name]
                if temp_sheet_name == 'sql_db':
                    temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                    next(temp_iter_rows)
                    for temp_row in temp_iter_rows:
                        temp_value = [j.value for j in temp_row]
                        self.config_list[temp_sheet_name][temp_value[0]] = [
                            temp_value[1],
                            temp_value[2],
                            temp_value[3]
                        ]
                elif temp_sheet_name == 'sql_script_map':
                    temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                    next(temp_iter_rows)
                    for temp_row in temp_iter_rows:
                        temp_value = [j.value for j in temp_row]
                        if temp_value[2] == '启用':
                            self.config_list[temp_sheet_name][temp_value[
                                1]] = temp_value[0]
                else:
                    for temp_row in temp_f_base_data_wb_sheet.iter_rows():
                        temp_value = [j.value for j in temp_row]
                        self.config_list[
                            temp_sheet_name
                        ][temp_value[0]] = temp_value[1]
        print(self.config_list)

    def online_db_process(self):
        # 多进程到不同的数据库上获取数据
        try:
            if self.config_list['config']['多进程'] == 'max':
                processes_num = len(self.config_list['sql_db'])
            else:
                processes_num = self.config_list['config']['多进程']
            process_pool = multiprocessing.Pool(processes=processes_num)
            for temp_db in self.config_list['sql_db']:
                process_pool.apply_async(
                    self.online_db_operator,
                    args=(temp_db,
                          self.config_list['sql_db'][temp_db]
                          ),
                    callback=self.online_db_input_warehousing
                )
            process_pool.close()
            process_pool.join()
        except:
            traceback.print_exc()

    def online_db_operator(self, db_name, db_information):
        data_list = {}
        connect_state = 0
        cc = ''
        try:
            ip = db_information[0]
            user = db_information[1]
            pwd = db_information[2]
            print('>>> 尝试连接数据库 {0}:{1} ...'.format(db_name, ip))
            try:
                conn = cx_Oracle.connect(user, pwd, ip)
                cc = conn.cursor()
                connect_state = 1
                print('>>>>>> {0}:{1} 连接成功!'.format(db_name, ip))
            except:
                print('||| 无法连接数据库 {0}:{1},请检查网络或数据库设置!'.format(
                    db_name,
                    ip
                ))
        except:
            traceback.print_exc()

        if connect_state == 1:
            for temp_sql in self.config_list['sql_script_map']:
                print(temp_sql)
                self.online_get_data(
                    self.get_sql_text(
                        temp_sql,
                        'online',
                        self.config_list['sql_script_map'][temp_sql]
                    ),
                    cc)

                try:
                    if cc.fetchall() is not None:
                        temp_data = DataFrame(cc.fetchall())
                        temp_head = [i[0] for i in cc.description]
                        temp_data.rename(
                            columns={
                                temp_head.index(i): i for i in temp_head
                            },
                            inplace=True
                        )

                        if len(temp_data) != 0:
                            data_list[temp_sql] = temp_data

                except:
                    traceback.print_exc()
        return data_list

    def get_sql_text(self, sql_name, online_type, time_type):
        sql_text = '__'
        temp_sql_full_name = os.path.join(
            self.main_path,
            '_sql',
            online_type,
            ''.join((sql_name, '.sql'))
        )
        try:
            f = open(temp_sql_full_name)
            temp_start_time, temp_end_time = self.get_sql_between_time(
                time_type
            )
            sql_text = f.read().replace('&1', temp_start_time).replace(
                '&2', temp_end_time)
        except:
            traceback.print_exc()
        return sql_text

    @staticmethod
    def online_get_data(sql_text, cc):
        try:
            return cc.execute(sql_text)
        except:
            traceback.print_exc()

    def get_sql_between_time(self, time_type):
        starttime = 0
        endtime = 0
        if time_type == 'hour':
            starttime = (datetime.datetime.now() - datetime.timedelta(
                hours=self.config_list['main']['获取最近连续时段数']
            )).strftime('%Y%m%d%H')
            endtime = datetime.datetime.now().strftime('%Y%m%d%H')
        return starttime, endtime

    def online_db_input_warehousing(self, temp_data_list):
        local_conn = sqlite3.connect(
            os.path.join(self.main_path, '_db', 'db.db'),
            check_same_thread=False
        )
        for temp_sql in temp_data_list:
            pandas.io.sql.to_sql(
                temp_data_list[temp_sql],
                temp_sql,
                con=local_conn,
                if_exists='append'
            )
        local_conn.close()

    def write_kpi_detail(self, report_name, temp_cu):
        try:
            kpi_list = os.path.join(
                self.main_path,
                '_report',
                'All_kpi_detail_list.xlsx'
            )

            global kpi_list_temp
            kpi_list_temp = os.path.join(
                self.main_path,
                '_report',
                ''.join((
                    'All_kpi_detail_list_',
                    self.temp_time,
                    '.xlsx'
                ))
            )
            if not os.path.exists(kpi_list):
                workbook_a = openpyxl.Workbook()
                workbook_a.save(kpi_list)
            workbook_a = openpyxl.load_workbook(kpi_list)

            if not os.path.exists(kpi_list_temp):
                workbook = openpyxl.Workbook()
                workbook.save(kpi_list_temp)
            workbook = openpyxl.load_workbook(kpi_list_temp)

            temp_head = [i[0] for i in temp_cu.description]
            if report_name not in workbook_a.sheetnames:
                worksheet_a = workbook_a.create_sheet(report_name)
                worksheet_a.append(temp_head)
            else:
                worksheet_a = workbook_a[report_name]
            worksheet = workbook.create_sheet(report_name)
            worksheet.append(temp_head)

            for temp_row in temp_cu.fetchall():
                worksheet_a.append(temp_row)
                worksheet.append(temp_row)
            workbook_a.save(kpi_list)
            workbook.save(kpi_list_temp)

        except:
            traceback.print_exc()

    def local_db_operator(self):
        local_conn = sqlite3.connect(
            os.path.join(self.main_path, '_db', 'db.db'),
            check_same_thread=False
        )

        cu = local_conn.cursor()
        for temp_local_sql in self.config_list['sql_script_map']:
            f_sql = open(
                os.path.join(
                    self.main_path,
                    '_sql/local',
                    ''.join((temp_local_sql, '.sql'))
                ),
                encoding='utf-8-sig'
            )
            sql_scr = f_sql.read()
            try:
                cu.execute(sql_scr)
                self.write_kpi_detail(temp_local_sql, cu)
            except:
                pass

    def report(self):
        df = pandas.read_excel(kpi_list_temp, sheet_name='city_hour-日常监控')
        print(df)
        df.to_html('11.html')


if __name__ == '__main__':
    multiprocessing.freeze_support()
    print(''.join((time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))))
    star_time = time.time()
    main = Main()
    # main.online_db_process()
    main.local_db_operator()
    main.report()
    print(''.join((time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))))
    print(''.join((
        '>>> 历时：',
        time.strftime(
            '%Y/%m/%d %H:%M:%S',
            time.gmtime(time.time() - star_time)
        )
    )))
