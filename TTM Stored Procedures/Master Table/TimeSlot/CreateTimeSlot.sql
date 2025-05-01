CREATE OR ALTER PROCEDURE CreateTimeSlot
    @Timeslot VARCHAR(50),
    @FromTime TIME,
    @ToTime TIME,
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Program exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramId = @ProgramId AND IsDeleted = 0)
        BEGIN
            THROW 50045, 'Error: Program not found or is deleted.', 1;
            RETURN;
        END

        -- Check for overlapping timeslots
        IF EXISTS (
            SELECT 1 FROM TimeSlot 
            WHERE ProgramId = @ProgramId 
              AND IsDeleted = 0
              AND (
                  (@FromTime BETWEEN FromTime AND ToTime)
                  OR (@ToTime BETWEEN FromTime AND ToTime)
                  OR (FromTime BETWEEN @FromTime AND @ToTime)
              )
        )
        BEGIN
            THROW 50046, 'Error: Timeslot overlaps with an existing timeslot.', 1;
            RETURN;
        END

        -- Insert new TimeSlot
        INSERT INTO TimeSlot (Timeslot, FromTime, ToTime, ProgramId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@Timeslot, @FromTime, @ToTime, @ProgramId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Timeslot created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

