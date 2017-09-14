DROP PROCEDURE GetOperationAvg;

DELIMITER //
CREATE PROCEDURE GetOperationAvg(IN currentQuater INT)
BEGIN
DROP TABLE IF EXISTS RESULT_OPERATION_AVG;
CREATE TABLE RESULT_OPERATION_AVG AS
select a.industry, avg(b.arturnover) as arturnover,avg(b.inventory_turnover) as inventory_turnover,avg(b.currentasset_turnover) as currentasset_turnover from basic_info as a
inner join (
select distinct code,arturnover,inventory_turnover,currentasset_turnover from operation_data 
	where quater = currentQuater
	and arturnover is not null
	and inventory_turnover is not null
	and currentasset_turnover is not null
UNION ALL 
select distinct code,arturnover,inventory_turnover,currentasset_turnover from operation_data 
	where code not in (select distinct code from operation_data where quater = currentQuater)
	and arturnover is not null
	and inventory_turnover is not null
	and currentasset_turnover is not null
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetOperationAvg();

