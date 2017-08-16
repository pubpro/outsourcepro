DROP PROCEDURE GetOperationAvg;

DELIMITER //
CREATE PROCEDURE GetOperationAvg()
BEGIN
DROP TABLE IF EXISTS RESULT_OPERATION_AVG;
CREATE TABLE RESULT_OPERATION_AVG AS
select a.industry, avg(b.arturnover) as arturnover,avg(b.inventory_turnover) as inventory_turnover,avg(b.currentasset_turnover) as currentasset_turnover from basic_info as a
inner join (
select code,arturnover,inventory_turnover,currentasset_turnover from operation_data 
	where quater = 20172 
	and arturnover is not null
	and inventory_turnover is not null
	and currentasset_turnover is not null
UNION ALL 
select code,arturnover,inventory_turnover,currentasset_turnover from operation_data 
	where code not in (select code from operation_data where quater = 20172)
	and arturnover is not null
	and inventory_turnover is not null
	and currentasset_turnover is not null
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetOperationAvg();
