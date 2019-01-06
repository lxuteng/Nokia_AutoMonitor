import sqlite3
import csv
import time

print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))
star_time = time.time()

sql_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_db\1.sql"
save_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_db" \
            r"\11.csv"

conn = sqlite3.connect(r"D:\python_object\Nokia_AutoMonitor"
                       r"\Nokia_AutoMonitor_hour\_db\db.db", check_same_thread=False)
cu = conn.cursor()
f_sql = open(sql_path, encoding='utf-8-sig')
sql_scr = f_sql.read()
cu.execute(sql_scr)
with open(save_path, 'w', newline='') as f_w:
    writer = csv.writer(f_w)
    writer.writerow([i[0] for i in cu.description])
    writer.writerows(list(cu.fetchall()))


print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))

