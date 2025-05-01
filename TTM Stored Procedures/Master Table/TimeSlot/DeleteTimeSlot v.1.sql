CREATE OR ALTER PROCEDURE DeleteTimeSlot
    @TimeSlotId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if TimeSlot exists
        IF NOT EXISTS (SELECT 1 FROM TimeSlot WHERE TimeSlotId = @TimeSlotId AND IsDeleted = 0)
            THROW 50050, 'Error: Timeslot not found or is deleted.', 1;

        -- Soft delete Timetable entries related to this TimeSlot
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE TimeSlotId = @TimeSlotId AND IsDeleted = 0;

        -- Soft delete TimeSlot
        UPDATE TimeSlot
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE TimeSlotId = @TimeSlotId;

        COMMIT TRANSACTION;
        PRINT 'Success: Timeslot deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

