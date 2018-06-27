#coding:utf-8
from sqlalchemy import create_engine
import tushare as ts

# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')

df = ts.get_today_all()
df.to_sql('realtime_price',engine, if_exists='replace')

