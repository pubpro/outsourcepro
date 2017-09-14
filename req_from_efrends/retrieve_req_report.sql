




# 连续三年净利润增长大于25%
# 营业收入同比增长率超过10%
# 资产负债率小于50%
select t1.code
from
(
select b.* from ( SELECT code, ((totalAssets - bvps * totals * 10000) / totalAssets) as debt_ratio, rev FROM basic_info ) as b where debt_ratio < 0.5 and rev > 10 
) as t1

inner join 
(
select a.code from (
SELECT CODE, COUNT(*) AS rcd from 
(
SELECT code, profits_yoy FROM `report_data` WHERE quater = 20144 AND profits_yoy > 25
UNION ALL
SELECT code, profits_yoy FROM `report_data` WHERE quater = 20154 and profits_yoy > 25
UNION ALL
SELECT code, profits_yoy FROM `report_data` WHERE quater = 20164 and profits_yoy > 25
) as t group by code
) as a where a.rcd = 3
) as t2

on t1.code = t2.code
