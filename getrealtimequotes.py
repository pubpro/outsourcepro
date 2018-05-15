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
	purchase_price = Column(Float);
	base_price = Column(Float);

# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8');
DBSession = sessionmaker(bind=engine);
session = DBSession();

targets = session.query(TargetPrice).all();

for target in targets:
	df = ts.get_realtime_quotes(target.code);
	currentPrice = float(df.ix[0,['price']].tolist()[0]);
	closePrice = float(df.ix[0,['pre_close']].tolist()[0]);
	if closePrice > target.base_price:
		# update base price
		basePrice = closePrice;
		session.query(TargetPrice).filter_by(code=target.code).update({"base_price": closePrice});
		session.commit()
	else:
		basePrice = target.base_price;
	increasePercents = (basePrice - target.purchase_price) / target.purchase_price * 100;
	if increasePercents > 20: 
		targetPrice = basePrice - (basePrice * 8 / 100);
	elif increasePercents > 10:
		targetPrice = basePrice - (basePrice * 5 / 100);
	else:
		targetPrice = target.purchase_price - (target.purchase_price * 3 / 100);
	if targetPrice > currentPrice:
		print(target.code);
		warnFlag = 1;

if warnFlag != 0:
	exit(1);
		

	

