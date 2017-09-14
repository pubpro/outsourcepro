DROP PROCEDURE GetFinalResult;

DELIMITER //
CREATE PROCEDURE GetFinalResult(IN currentQuater INT)
BEGIN

CALL GetBasicAvg();
CALL GetReportAvg(currentQuater);
CALL GetProfitAvg(currentQuater);
CALL GetOperationAvg(currentQuater);
CALL GetGrowthAvg(currentQuater);
CALL GetDebtpayAvg(currentQuater);
CALL GetCashflowAvg(currentQuater);
CALL GetAllIndexAvg();
CALL GetAllStockIndex(currentQuater);

END;


CALL GetFinalResult();
