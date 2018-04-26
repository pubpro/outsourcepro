#coding:utf-8
import tushare as ts
from sqlalchemy import Column, String, Float, create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base();
warnFlag = 0;

class TargetPrice(Base):
	__tablename__ = 'TARGET_PRICE';
	code = Column(String(6),primary_key=True);
	name = Column(String(24));
	target_price = Column(Float);

# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8');
DBSession = sessionmaker(bind=engine);
session = DBSession();

targets = session.query(TargetPrice).all();

for target in targets:
	df = ts.get_realtime_quotes(target.code);
	currentPrice = float(df.ix[0,['price']].tolist()[0]);
	if target.target_price > currentPrice:
		print(target.code);
		warnFlag = 1;

if warnFlag != 0:
	exit(1);
		

	

