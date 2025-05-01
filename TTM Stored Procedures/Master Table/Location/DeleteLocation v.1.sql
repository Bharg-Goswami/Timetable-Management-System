CREATE OR ALTER PROCEDURE DeleteLocation
    @LocationId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Location exists
        IF NOT EXISTS (SELECT 1 FROM Location WHERE LocationId = @LocationId AND IsDeleted = 0)
            THROW 50018, 'Error: Location not found or is deleted.', 1;

        -- Soft delete Timetable entries related to this Location
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE LocationId = @LocationId AND IsDeleted = 0;

        -- Soft delete Location
        UPDATE Location
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE LocationId = @LocationId;

        COMMIT TRANSACTION;
        PRINT 'Success: Location deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

