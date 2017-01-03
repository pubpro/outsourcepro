#!/usr/bin/python
import tushare as ts
import pandas as pd
import datetime
import time

stocks = ["000926","601899","000977","000413"]

saling_stocks = []
fixed_down_rate = -0.2
request_date = None
last_request_date = None


def detect_saling_stocks():
	global saling_stocks, request_date, last_request_date
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

	yesterday = datetime.timedelta(days=2)
	yesterday_date = now - yesterday
	weekday = yesterday_date.weekday()
	if weekday == 5:
		delta = datetime.timedelta(days=-1)
		last_date = yesterday_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")
	elif weekday == 6:
		delta = datetime.timedelta(days=-2)
		last_date = yesterday_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")		
	else:
		last_request_date = yesterday_date.strftime("%Y-%m-%d")
	for stock_code in stocks:
		curr_stock = ts.get_hist_data(stock_code, start=request_date,end=request_date)
		last_stock = ts.get_hist_data(stock_code, start=last_request_date,end=last_request_date)
		# if stock ma5 < ma10, sale it
		if curr_stock["ma5"][0] < curr_stock["ma10"][0]:
			saling_stocks.append(stock_code)
			continue
		if (curr_stock["ma5"][0] - last_stock["ma5"][0]) / last_stock["ma5"][0] * 100 < fixed_down_rate:
			saling_stocks.append(stock_code)
			continue



		# if slope of current ma5 and last ma5 greater than fixed down rate, sale it




detect_saling_stocks()
print request_date, last_request_date

print saling_stocks




