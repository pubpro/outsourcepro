import pdb
import tushare as ts
from sqlalchemy import create_engine



engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')
pdb.set_trace()
df = ts.get_industry_classified()
df.to_sql('industry_data',engine, if_exists='replace')
