#coding:utf-8
import MySQLdb
import urllib2
from bs4 import BeautifulSoup
# open url
def getHtml(url):
	
	headers = {'Accept': 'text/html', 'Accept-Language':'en-US,zh-CN',
	'Cache-Control': 'no-cache', 'Connection': 'keep-alive', 'Host': 'data.10jqka.com.cn',
	'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0'}
	data = None
	req = urllib2.Request(url, data, headers)
	resp = urllib2.urlopen(req)
	html = resp.read()	
	resp.close()
	return html


def generateUpdateStatement(html):
	soup = BeautifulSoup(html,'lxml')
	all_td = soup.find_all('td', attrs={'class': 'tc cur'})
	inst_stmt = "insert ignore into new_lowprice values "
	for tag in all_td:
		code = tag.contents[0].string		
		inst_stmt = inst_stmt + "('" + code + "'),"
	inst_stmt = inst_stmt + "('000000')"
	return inst_stmt

fihtml = getHtml("http://data.10jqka.com.cn/rank/cxd/")

db = MySQLdb.connect("localhost", "tushare", "Abcd1234", "tushare", charset='utf8' )
cursor = db.cursor()

sql = "delete from new_lowprice"
cursor.execute(sql)

sql = generateUpdateStatement(fihtml)
cursor.execute(sql)

db.commit()

db.close()



