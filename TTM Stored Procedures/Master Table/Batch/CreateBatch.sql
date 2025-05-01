CREATE OR ALTER PROCEDURE CreateBatch
    @BatchName VARCHAR(50),
    @DivisionId INT,
    @MinHoursDailyLimit INT,
    @MaxHoursDailyLimit INT,
    @MinHoursWeeklyLimit INT,
    @MaxHoursWeeklyLimit INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Division exists
        IF NOT EXISTS (SELECT 1 FROM Division WHERE DivisionId = @DivisionId AND IsDeleted = 0)
        BEGIN
            ;THROW 50039, 'Error: Division not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate BatchName
        IF EXISTS (SELECT 1 FROM Batch WHERE BatchName = @BatchName AND DivisionId = @DivisionId AND IsDeleted = 0)
        BEGIN
            ;THROW 50040, 'Error: Batch name already exists in this division.', 1;
            RETURN;
        END

        -- Insert new Batch
        INSERT INTO Batch (
            BatchName,
            DivisionId,
            MinHoursDailyLimit,
            MaxHoursDailyLimit,
            MinHoursWeeklyLimit,
            MaxHoursWeeklyLimit,
            CreationTimeStamp,
            IsDisabled,
            IsDeleted
        )
        VALUES (
            @BatchName,
            @DivisionId,
            @MinHoursDailyLimit,
            @MaxHoursDailyLimit,
            @MinHoursWeeklyLimit,
            @MaxHoursWeeklyLimit,
            GETDATE(),
            0,
            0
        );

        COMMIT TRANSACTION;
        PRINT 'Success: Batch created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

