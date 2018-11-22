#coding:utf-8
from sqlalchemy import create_engine
import tushare as ts


# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')

# =================================================industry data=================================================
# import industry data
#code：股票代码
#name：股票名称
#c_name：行业名称
#df = ts.get_industry_classified()
#df.to_sql('industry_data',engine, if_exists='replace')


# =================================================bonus data=================================================
# import bonus data
#code:股票代码
#name:股票名称
#year:分配年份
#report_date:公布日期
#divi:分红金额（每10股）
#shares:转增和送股数（每10股）
df = ts.get_hist_data('sh','M')
print df
#df.to_sql('hist_data',engine, if_exists='replace')

