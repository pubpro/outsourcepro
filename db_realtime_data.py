#coding:utf-8
from sqlalchemy import create_engine
import tushare as ts

# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')


df = ts.get_today_all()
df.to_sql('realtime_price',engine, if_exists='replace')


df = ts.cap_tops(60)
df.to_sql('cap_tops',engine, if_exists='replace')

#df=ts.inst_tops(10)
#df.to_sql('inst_tops',engine, if_exists='replace')


#df=ts.inst_detail(10)
#df.to_sql('inst_detail',engine, if_exists='replace')
