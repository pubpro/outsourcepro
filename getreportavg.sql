# get average eps,bvps,roe,epcf
DROP PROCEDURE GetReportAvg;

DELIMITER //
CREATE PROCEDURE GetReportAvg(IN currentQuater INT)
BEGIN
DROP TABLE IF EXISTS RESULT_REPORT_AVG;
CREATE TABLE RESULT_REPORT_AVG AS
select a.industry, avg(b.eps) as eps, avg(b.roe) as roe from basic_info as a
inner join (
select distinct code,eps * 2 as eps,roe from report_data 
	where quater = currentQuater
	and eps is not null
	and roe is not null 
UNION ALL 
select distinct code,eps * 4 as eps,roe from report_data 
	where code not in (select distinct code from report_data where quater = currentQuater)
	and eps is not null
	and roe is not null
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetReportAvg();
