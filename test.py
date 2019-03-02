# import sqlite3
# import csv
# import time
#
# print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))
# star_time = time.time()
#
# sql_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_db\1.sql"
# save_path = r"D:\python_object\Nokia_AutoMonitor\Nokia_AutoMonitor_hour\_db" \
#             r"\11.csv"
#
# conn = sqlite3.connect(r"D:\python_object\Nokia_AutoMonitor"
#                        r"\Nokia_AutoMonitor_hour\_db\db.db", check_same_thread=False)
# cu = conn.cursor()
# f_sql = open(sql_path, encoding='utf-8-sig')
# sql_scr = f_sql.read()
# cu.execute(sql_scr)
# with open(save_path, 'w', newline='') as f_w:
#     writer = csv.writer(f_w)
#     writer.writerow([i[0] for i in cu.description])
#     writer.writerows(list(cu.fetchall()))
#
#
# print(time.strftime('%Y/%m/%d %H:%M:%S', time.localtime()))

# import pandas as pd
# import numpy as np
# from pandas import DataFrame,Series
# from matplotlib import pyplot as plt
# from lxml import etree
#
# from io import BytesIO
# import base64
# import urllib
# df = pd.DataFrame(np.random.randn(4,4),index = list('ABCD'),columns=list('OPKL'))
# df.plot()
# # plt.show()
#
# buffer = BytesIO()
# plt.savefig(buffer)
# plot_data = buffer.getvalue()
# imb = base64.b64encode(plot_data)
# ims = imb.decode()
# print(ims)
# imd = "data:image/png;base64,"+ims
# iris_im = """<h1>Iris Figure</h1>  """ + """<img src="%s">""" % imd
# root = "<title>Iris Dataset</title>"
# root = root + iris_im
# html = etree.HTML(root)
# tree = etree.ElementTree(html)
# tree.write('iris.html')

# df=pd.DataFrame(data=np.random.randn(10,4).cumsum(0),
#                 columns=['A','B','C','D'],
# #                 index=np.arange(0,100,10))
# #
# # print(df)
# import csv
# f = open('','r')
# f_csv = csv.reader(f)
#
# f_writer = csv.writer(open('','w'))
# for i in f_csv:
#
# a= '{1}12345{0}'.format(99,1)
# print(a)
#
# import datetime
# import time
#
# print(datetime.datetime.now().strftime('%Y_%m_%d_%H_%M_%S'))
# print(datetime.datetime.now().strftime('%H'))
#
# temp_time_now = time.localtime()
# temp_time = time.strftime('%Y_%m_%d_%H_%M_%S', temp_time_now)
# print(temp_time)


# import pandas
#
# f_csv = pandas.read_csv(r"D:\Temp\all_day_20190207_LTECP8.csv")
# print(111111)
# # f_csv.to_excel(r"D:\Temp\all_day_20190207_LTECP8.xlsx",sheet_name='aaa')
# f_csv.to_csv(r"D:\Temp\all_day_20190207_LTECP811.csv")

import csv
import xlwt
f = open(r"D:\Temp\all_day_20190207_LTECP8.csv",encoding='utf-8-sig')
f_csv = csv.reader(f)
f_wb = xlwt.Workbook()
sheet1 = f_wb.add_sheet('aaaa')
for i in f_csv:
    sheet1.write(i)
f_wb.save(r"D:\Temp\all_day_20190207_LTECP8.xlsx")