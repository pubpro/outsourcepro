DROP PROCEDURE GetGrowthAvg;

DELIMITER //
CREATE PROCEDURE GetGrowthAvg(IN currentQuater INT)
BEGIN
DROP TABLE IF EXISTS RESULT_GROWTH_AVG;
CREATE TABLE RESULT_GROWTH_AVG AS
select a.industry, avg(b.mbrg) as mbrg,avg(b.nprg) as nprg,avg(b.nav) as nav,avg(b.targ) as targ,avg(b.epsg) as epsg,avg(b.seg) as seg
from basic_info as a
inner join (
select distinct code,mbrg,nprg,nav,targ,epsg,seg from growth_data 
	where quater = currentQuater
	and mbrg is not null
	and nprg is not null
	and nav is not null
	and targ is not null
	and epsg is not null
	and seg is not null
UNION ALL 
select distinct code,mbrg,nprg,nav,targ,epsg,seg from growth_data 
	where code not in (select distinct code from growth_data where quater = currentQuater)
	and mbrg is not null
	and nprg is not null
	and nav is not null
	and targ is not null
	and epsg is not null
	and seg is not null
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetGrowthAvg();

