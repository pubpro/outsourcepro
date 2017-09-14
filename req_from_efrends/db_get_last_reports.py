#coding:utf-8
from sqlalchemy import create_engine
import tushare as ts
# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')

df = ts.get_report_data(2014,4)
df = df.assign(quater=20144)
df.to_sql('report_data',engine, if_exists='append')
df = ts.get_report_data(2015,4)
df = df.assign(quater=20154)
df.to_sql('report_data',engine, if_exists='append')
df = ts.get_report_data(2016,4)
df = df.assign(quater=20164)
df.to_sql('report_data',engine, if_exists='append')

