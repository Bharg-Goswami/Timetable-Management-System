-- SQL script for DeleteTimetableEntry 
CREATE PROCEDURE DeleteTimetableEntry
    @TimetableId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Timetable
    SET 
        IsDeleted = 1,
        DeletionTimeStamp = GETDATE()
    WHERE TimetableId = @TimetableId;
END;
GO