CREATE OR ALTER PROCEDURE UpdateTimeSlot
    @TimeSlotId INT,
    @Timeslot VARCHAR(50),
    @FromTime TIME,
    @ToTime TIME,
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if TimeSlot exists
        IF NOT EXISTS (SELECT 1 FROM TimeSlot WHERE TimeSlotId = @TimeSlotId AND IsDeleted = 0)
        BEGIN
            THROW 50047, 'Error: Timeslot not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Program exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramId = @ProgramId AND IsDeleted = 0)
        BEGIN
            THROW 50048, 'Error: Program not found or is deleted.', 1;
            RETURN;
        END

        -- Check for overlapping timeslots
        IF EXISTS (
            SELECT 1 FROM TimeSlot 
            WHERE ProgramId = @ProgramId 
              AND TimeSlotId <> @TimeSlotId
              AND IsDeleted = 0
              AND (
                  (@FromTime BETWEEN FromTime AND ToTime)
                  OR (@ToTime BETWEEN FromTime AND ToTime)
                  OR (FromTime BETWEEN @FromTime AND @ToTime)
              )
        )
        BEGIN
            THROW 50049, 'Error: Timeslot overlaps with an existing timeslot.', 1;
            RETURN;
        END

        -- Update TimeSlot
        UPDATE TimeSlot
        SET Timeslot = @Timeslot,
            FromTime = @FromTime,
            ToTime = @ToTime,
            ProgramId = @ProgramId,
            UpdationTimeStamp = GETDATE()
        WHERE TimeSlotId = @TimeSlotId;

        COMMIT TRANSACTION;
        PRINT 'Success: Timeslot updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

