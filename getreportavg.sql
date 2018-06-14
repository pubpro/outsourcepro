# get average eps,bvps,roe,epcf
DROP PROCEDURE IF EXISTS GetReportAvg;

DELIMITER //
CREATE PROCEDURE GetReportAvg(IN currentQuater INT)
BEGIN
DECLARE lastEPSTimes FLOAT;
DECLARE currentEPSTimes FLOAT;
DECLARE season INT;
select mod(currentQuater,10) into season;
IF season = 1 THEN SET currentEPSTimes = 4; SET lastEPSTimes = 1;
ELSEIF season = 2 THEN SET currentEPSTimes = 2; SET lastEPSTimes = 4;
ELSEIF season = 3 THEN SET currentEPSTimes = 1.333334; SET lastEPSTimes = 2;
ELSEIF season = 4  THEN SET currentEPSTimes = 1; SET lastEPSTimes = 1.333334;
END IF;
DROP TABLE IF EXISTS RESULT_REPORT_AVG;
CREATE TABLE RESULT_REPORT_AVG AS
select a.industry, avg(b.eps) as eps, avg(b.roe) as roe from basic_info as a
inner join (
select distinct code,eps * currentEPSTimes as eps,roe from report_data 
	where quater = currentQuater
	and eps is not null
	and roe is not null 
UNION ALL 
select distinct code,eps * lastEPSTimes as eps,roe from report_data 
	where code not in (select distinct code from report_data where quater = currentQuater)
	and eps is not null
	and roe is not null
) as b
on a.code = b.code
group by a.industry;

END;


-- CALL GetReportAvg();
