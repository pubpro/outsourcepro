#!/usr/bin/python
import tushare as ts
import pandas as pd
import datetime
import time
import math

stocks = ["000926","002244","601899","000838","000977","601668"]

saling_stocks = []


def detect_saling_stocks():
	global saling_stocks
	# get request date
	tm_wday = time.localtime(time.time()).tm_wday
	tm_hour = time.localtime(time.time()).tm_hour
	if tm_hour < 15:
		today = datetime.date.today()
		oneday = datetime.timedelta(days=1)
		now = today - oneday
	else:
		now = datetime.date.today()
	if tm_wday == 5:
		delta = datetime.timedelta(days=-1)
		last_date = now + delta
		request_date = last_date.strftime("%Y-%m-%d")
	elif tm_wday == 6:
		delta = datetime.timedelta(days=-2)
		last_date = now + delta
		request_date = last_date.strftime("%Y-%m-%d")		
	else:
		request_date = now.strftime("%Y-%m-%d")

	for stock_code in stocks:
		stock = ts.get_hist_data(stock_code, start=request_date,end=request_date)
		# if stock ma5 < ma10, sale it
		if stock["ma5"][0] < stock["ma10"][0]:
			saling_stocks.append(stock_code)



detect_saling_stocks()

print saling_stocks




