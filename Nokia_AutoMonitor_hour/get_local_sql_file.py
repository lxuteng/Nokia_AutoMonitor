# -*- coding: gbk -*-
import pandas
import sqlite3
import csv
import time

print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))
star_time = time.time()

path_base_data = r"D:\Test\overload\mre_ecid_20190117_sum.csv"
sql_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_temp\1.sql"
save_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_temp" \
            r"\abc.csv"

conn = sqlite3.connect(r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_db\db.db", check_same_thread=False)
# df = pandas.read_csv(path_base_data, encoding='gbk')
# df.to_sql('sheet', conn, if_exists='append', index=False)
cu = conn.cursor()
f_sql = open(sql_path, encoding='utf-8-sig')
sql_scr = f_sql.read()
cu.execute(sql_scr)
with open(save_path, 'w', newline='') as f_w:
    writer = csv.writer(f_w)
    writer.writerow([i[0] for i in cu.description])
    writer.writerows(list(cu.fetchall()))


print('>>> 历时：', time.strftime('%Y/%m/%d %H:%M:%S', time.gmtime(time.time() - star_time)))
print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))