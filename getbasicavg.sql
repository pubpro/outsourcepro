DROP PROCEDURE IF EXISTS GetBasicAvg;

DELIMITER //
CREATE PROCEDURE GetBasicAvg()
BEGIN
DROP TABLE IF EXISTS RESULT_BASIC_AVG;
CREATE TABLE RESULT_BASIC_AVG AS
SELECT industry, AVG(pe) as pe, AVG(pb) as pb, AVG(bvps) as bvps FROM basic_info where pe is not null and pb is not null and bvps is not null group by industry;
END;


--CALL GetBasicAvg();




