#coding:utf-8

import MySQLdb
from sqlalchemy import create_engine

today = "2017-09-18"

import tushare as ts
# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')


# retrieve base stocks

conn = MySQLdb.connect(
	host='localhost',
	port = 3306,
	user='tushare',
	passwd='Abcd1234',
	db ='tushare',
	)

cur = conn.cursor()

# Drop tick data table
cur.execute("DROP TABLE IF EXISTS tick_data")

# get base stock
cur.execute("SELECT DISTINCT T1.CODE FROM RESULT_ALLSTOCKINDEX AS T1 INNER JOIN RESULT_ALLINDEX_AVG AS T2 ON T1.INDUSTRY = T2.INDUSTRY WHERE 1 = 1 AND T1.GPR >= T2.GPR AND T1.MBRG >= T2.MBRG AND T1.EPSG >= T2.EPSG AND T1.SEG >= T2.SEG AND T1.CASHFLOWRATIO >= T2.CASHFLOWRATIO AND T1.EPS >= T2.EPS")

result = cur.fetchall()

# store data into local database
for row in result:
	code = row[0]
	# store todays trades into local db
	print code, today
	df = ts.get_tick_data(code,date=today)
	df.to_sql('tick_data',engine, if_exists='append')

conn.close()


