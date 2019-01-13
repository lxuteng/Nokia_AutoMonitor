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
import random
import csv
import time
from io import BytesIO
import base64
from matplotlib import pyplot as plt

font = {'family': 'SimHei',
        'weight': 'bold',
        # 'size': '16'
        }
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False)


class Main:

    def __init__(self):
        """初始化"""
        self.main_path = os.path.split(os.path.abspath(sys.argv[0]))[0]
        # 获取配置文件
        self.config_list = {}
        self.get_config()
        self.temp_time_now = datetime.datetime.now()
        self.temp_time = self.temp_time_now.strftime('%Y_%m_%d_%H_%M_%S')

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
                        if temp_value[4] == '启用':
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

                elif temp_sheet_name == 'sql_script_map_local':
                    temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                    next(temp_iter_rows)
                    for temp_row in temp_iter_rows:
                        temp_value = [j.value for j in temp_row]
                        if temp_value[2] == '启用':
                            self.config_list[temp_sheet_name][temp_value[
                                1]] = temp_value[0]

                elif temp_sheet_name == 'report_table_range':
                    temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                    next(temp_iter_rows)
                    for temp_row in temp_iter_rows:
                        temp_value = [j.value for j in temp_row]
                        self.config_list[temp_sheet_name][temp_value[
                            0]] = temp_value[1:]

                elif temp_sheet_name == '生成图表kpi':
                    self.config_list[temp_sheet_name] = []
                    temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                    next(temp_iter_rows)
                    for temp_row in temp_iter_rows:
                        temp_value = [j.value for j in temp_row]
                        if temp_value[1] == '启用':
                            self.config_list[temp_sheet_name].append(
                                temp_value[0])

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
                self.online_get_data(
                    self.get_sql_text(
                        temp_sql,
                        'online',
                        self.config_list['sql_script_map'][temp_sql],
                        db_name
                    ), cc)

                try:
                    temp_data = DataFrame(cc.fetchall())
                    if temp_data is not None:
                        temp_head = [i[0] for i in cc.description]
                        temp_data.rename(
                            columns={
                                temp_head.index(i): i for i in temp_head
                            },
                            inplace=True
                        )
                        if len(temp_data) != 0:
                            data_list[temp_sql] = temp_data
                            f_base_data_wb = openpyxl.load_workbook(
                                            path_base_data_log, read_only=False)

                            temp_f_base_data_wb_sheet = f_base_data_wb[
                                '数据采集记录表']
                            for temp_sdate in sorted(list(set(
                                    temp_data.SDATE))):
                                temp_low = [
                                    db_name,
                                    temp_sql,
                                    temp_sdate,
                                ]
                                temp_f_base_data_wb_sheet.append(temp_low)

                            a = 1
                            b = 1
                            while a == 1:
                                if b < 5:
                                    try:
                                        f_base_data_wb.save(
                                            path_base_data_log)
                                        a = 0
                                    except:
                                        print(
                                            '>>> {0}等待数据写入,'
                                            '重试次数{1}....'.format(db_name, b)
                                        )
                                        time.sleep(random.randint(1, 5))
                                        b += 1
                                else:
                                    print(
                                        '>>> 数据采集记录表.xlsx写入异常，请检查!')
                                    a = 0

                except:
                    traceback.print_exc()
        return data_list

    def get_sql_text(self, sql_name, online_type, time_type, temp_cp):
        sql_text = ''
        temp_sql_full_name = os.path.join(
            self.main_path,
            '_sql',
            online_type,
            ''.join((sql_name, '.sql'))
        )
        try:
            f = open(temp_sql_full_name)
            temp_time_list = self.get_sql_between_time(time_type, temp_cp,
                                                       sql_name)
            temp_start_time = temp_time_list[0]
            temp_end_time = temp_time_list[1]
            temp_time_item = temp_time_list[2]
            temp_time_item_format = ''
            for temp_item in temp_time_item:
                temp_time_item_format += r"to_date({0}, 'yyyymmddhh24')," \
                                         r"".format(temp_item)

            sql_text = f.read().replace('&1', temp_start_time).replace(
                '&2', temp_end_time).replace('&3', temp_time_item_format[:-1])
        except:
            traceback.print_exc()
        return sql_text

    @staticmethod
    def online_get_data(sql_text, cc):
        try:
            return cc.execute(sql_text)
        except:
            traceback.print_exc()

    def get_sql_between_time_simp(self, time_type, int_num):
        start_time = 0
        end_time = 0
        if time_type == 'hour':
            start_time = (self.temp_time_now - datetime.timedelta(
                hours=int_num)).strftime('%Y%m%d%H')
            end_time = self.temp_time_now.strftime('%Y%m%d%H')

        return str(start_time), str(end_time)

    def get_sql_between_time(self, time_type, temp_cp, temp_sql_name):
        start_time = 0
        end_time = 0
        time_item = []
        exit_time_list = {}
        global path_base_data_log
        path_base_data_log = os.path.join(
            self.main_path,
            '_db',
            '数据采集记录表.xlsx')
        f_base_data_wb = openpyxl.load_workbook(
            path_base_data_log, read_only=True)
        for temp_sheet_name in f_base_data_wb.sheetnames:
            if temp_sheet_name not in exit_time_list:
                exit_time_list[temp_sheet_name] = {}
            temp_f_base_data_wb_sheet = f_base_data_wb[temp_sheet_name]
            if temp_sheet_name == '数据采集记录表':
                temp_iter_rows = temp_f_base_data_wb_sheet.iter_rows()
                next(temp_iter_rows)
                for temp_row in temp_iter_rows:
                    temp_value = [j.value for j in temp_row]
                    if temp_value[0] not in exit_time_list[temp_sheet_name]:
                        exit_time_list[temp_sheet_name][temp_value[0]] = {}
                    if temp_value[1] not in exit_time_list[temp_sheet_name][
                            temp_value[0]]:
                        exit_time_list[temp_sheet_name][temp_value[
                            0]][temp_value[1]] = {}
                    exit_time_list[temp_sheet_name][temp_value[
                        0]][temp_value[1]][temp_value[2]] = temp_value[3]

        if time_type == 'hour':
            start_time = (self.temp_time_now - datetime.timedelta(
                hours=self.config_list['main']['获取最近连续时段数']
            )).strftime('%Y%m%d%H')
            end_time = self.temp_time_now.strftime('%Y%m%d%H')

            for temp_i in range(self.config_list['main']['获取最近连续时段数']+1):
                temp_time_item = (self.temp_time_now - datetime.timedelta(
                    hours=temp_i)).strftime('%Y%m%d%H')
                try:
                    if temp_time_item not in exit_time_list['数据采集记录表'][
                            temp_cp][temp_sql_name]:
                        time_item.append(temp_time_item)
                except:
                    time_item.append(temp_time_item)

        return str(start_time), str(end_time), set(time_item)

    def online_db_input_warehousing(self, temp_data_list):
        try:
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
        except:
            traceback.print_exc()

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
        for temp_local_sql in self.config_list['sql_script_map_local']:
            f_sql = open(
                os.path.join(
                    self.main_path,
                    '_sql/local',
                    ''.join((temp_local_sql, '.sql'))
                ), encoding='utf-8-sig'
            )
            sql_scr = f_sql.read()
            if temp_local_sql == 'city_hour-日常监控':
                temp_time_list = self.get_sql_between_time_simp(
                    'hour', self.config_list['main']['获取最近连续时段数'])
                temp_start_time = temp_time_list[0]
                temp_end_time = temp_time_list[1]
                sql_scr = sql_scr.replace(
                    '&1', temp_start_time).replace('&2', temp_end_time)
            try:
                cu.execute(sql_scr)
                self.write_kpi_detail(temp_local_sql, cu)
            except:
                traceback.print_exc()

    def report_table_class(self, kpi_name, kpi_value):
        temp_table_str = """      <td>"""
        temp_table_str += str(kpi_value)
        temp_table_str += """</td>\n"""

        if kpi_name in self.config_list['report_table_range']:

            if self.config_list['report_table_range'][kpi_name][0] == '表头':
                temp_table_str = """      <th>"""
                temp_table_str += str(kpi_value)
                temp_table_str += """</th>\n"""

            elif self.config_list['report_table_range'][kpi_name][0] == '<':
                if self.config_list['report_table_range'][kpi_name][2] is None:
                    if kpi_value <= self.config_list[
                            'report_table_range'][kpi_name][1]:
                        temp_table_str = """      <td><b><font 
                        color="#B8860B">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""
                else:
                    if kpi_value <= self.config_list['report_table_range'][
                            kpi_name][2]:
                        temp_table_str = """      <td><b>"""
                        temp_table_str += """<font color="#FF0000">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""
                    elif kpi_value <= self.config_list['report_table_range'][
                            kpi_name][1]:
                        temp_table_str = """      <td><b>"""
                        temp_table_str += """<font color="#B8860B">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""

            elif self.config_list['report_table_range'][kpi_name][0] == '>':
                if self.config_list['report_table_range'][kpi_name][2] is None:
                    if kpi_value >= self.config_list[
                            'report_table_range'][kpi_name][1]:
                        temp_table_str = """      <td><b>"""
                        temp_table_str += """<font color="#B8860B">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""
                else:
                    if kpi_value >= self.config_list['report_table_range'][
                            kpi_name][2]:
                        temp_table_str = """      <td><b>"""
                        temp_table_str += """<font color="#FF0000">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""
                    elif kpi_value >= self.config_list['report_table_range'][
                            kpi_name][1]:
                        temp_table_str = """      <td><b>"""
                        temp_table_str += """<font color="#B8860B">"""
                        temp_table_str += str(kpi_value)
                        temp_table_str += """</font></b></td>\n"""
        return temp_table_str

    def to_html(self, df):

        table_str = """<table border="1" bordercolor="#B0C4DE" """
        table_str += """class="dataframe" cellspacing="0" """
        table_str += """style="text-align: "center">\n"""
        table_str += """  <thead>\n"""

        temp_columns_name_list = df.columns.values.tolist()

        table_str += """    <tr style="background-color:#EEF0F4"">\n"""

        for temp_head_row in temp_columns_name_list:
            table_str += """      <th>"""
            table_str += str(temp_head_row)
            table_str += """</th>\n"""

        table_str += """    </tr>\n"""
        table_str += """  </thead>\n"""
        table_str += """  <tbody style="background-color:#F6F8FA">\n"""

        for temp_index, temp_row in df.iterrows():
            table_str += """    <tr>\n"""
            temp_value_dict = dict(temp_row)
            for temp_columns_name in temp_columns_name_list:
                table_str += self.report_table_class(
                    temp_columns_name,
                    temp_value_dict[temp_columns_name]
                )
            table_str += """    </tr>\n"""

        table_str += """  </tbody>\n"""
        table_str += """</table>\n"""

        return table_str

    def to_image(self, df, kpi_name):
        # 清除前面图表
        plt.figure()
        temp_x, temp_data_list = self.to_image_df(df, kpi_name)
        for temp_data in temp_data_list:
            plt.plot(temp_x, temp_data[0], label=temp_data[1])
        # plt.ylim(98,100)
        plt.legend()
        # plt.legend(loc='upper left')
        plt.title(kpi_name)
        # plt.show()
        # plt.grid(True)
        buffer = BytesIO()
        plt.savefig(buffer)
        plot_data = buffer.getvalue()
        imb = base64.b64encode(plot_data)
        ims = imb.decode()
        imd = "data:image/png;base64," + ims
        iris_im = """<img src="%s">""" % imd
        return iris_im

    @staticmethod
    def to_image_df(df, kpi_name):

        temp_v = [str(i)[-2:] for i in list(df[df['CITY'] == '潮州']['SDATE'])]
        temp_city_list = sorted(list(set(df['CITY'])))

        temp_data_list = [
            [df[df[u'CITY'] == temp_city][
                 [kpi_name]], temp_city] for temp_city in temp_city_list
        ]

        return temp_v, temp_data_list

    def report(self):
        df = pandas.read_excel(
            kpi_list_temp,
            sheet_name='city_hour-日常监控',
            index_col=False
        )
        temp_html = ''
        temp_time_list = self.get_sql_between_time_simp(
            'hour', self.config_list['main']['报告报表呈现时段数'])
        # temp_html += self.to_html(df)
        temp_html += self.to_html(
            df[df.SDATE >= int(temp_time_list[0])]
        )
        for temp_kpi in self.config_list['生成图表kpi']:
            temp_html += self.to_image(df, temp_kpi)

        with open('123.html', 'w') as f_html:
            f_html.write(temp_html)


if __name__ == '__main__':
    multiprocessing.freeze_support()
    print(''.join((time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))))
    star_time = time.time()
    main = Main()
    main.online_db_process()
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
