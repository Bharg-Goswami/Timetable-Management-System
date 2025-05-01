CREATE OR ALTER PROCEDURE UpdateBatch
    @BatchId INT,
    @BatchName VARCHAR(50) = NULL,
    @DivisionId INT = NULL,
    @MinHoursDailyLimit INT = NULL,
    @MaxHoursDailyLimit INT = NULL,
    @MinHoursWeeklyLimit INT = NULL,
    @MaxHoursWeeklyLimit INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Batch exists
        IF NOT EXISTS (SELECT 1 FROM Batch WHERE BatchId = @BatchId AND IsDeleted = 0)
        BEGIN
            ;THROW 50041, 'Error: Batch not found or is deleted.', 1;
            RETURN;
        END

        -- Optional: Check for Division existence if DivisionId is provided
        IF @DivisionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Division WHERE DivisionId = @DivisionId AND IsDeleted = 0)
        BEGIN
            ;THROW 50042, 'Error: Division not found or is deleted.', 1;
            RETURN;
        END

        -- Optional: Check for duplicate BatchName if both BatchName and DivisionId are provided
        IF @BatchName IS NOT NULL AND @DivisionId IS NOT NULL AND 
           EXISTS (
                SELECT 1 FROM Batch 
                WHERE BatchName = @BatchName 
                    AND DivisionId = @DivisionId 
                    AND BatchId <> @BatchId 
                    AND IsDeleted = 0
           )
        BEGIN
            ;THROW 50043, 'Error: Batch name already exists in this division.', 1;
            RETURN;
        END

        -- Update only provided (non-null) fields
        UPDATE Batch
        SET 
            BatchName = COALESCE(@BatchName, BatchName),
            DivisionId = COALESCE(@DivisionId, DivisionId),
            MinHoursDailyLimit = COALESCE(@MinHoursDailyLimit, MinHoursDailyLimit),
            MaxHoursDailyLimit = COALESCE(@MaxHoursDailyLimit, MaxHoursDailyLimit),
            MinHoursWeeklyLimit = COALESCE(@MinHoursWeeklyLimit, MinHoursWeeklyLimit),
            MaxHoursWeeklyLimit = COALESCE(@MaxHoursWeeklyLimit, MaxHoursWeeklyLimit),
            UpdationTimeStamp = GETDATE()
        WHERE BatchId = @BatchId;

        COMMIT TRANSACTION;
        PRINT 'Success: Batch updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

