-- Get Batches by DivisionId
CREATE PROCEDURE GetBatches
    @DivisionId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        BatchId,
        BatchName
    FROM Batch 
    WHERE DivisionId = @DivisionId 
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO
