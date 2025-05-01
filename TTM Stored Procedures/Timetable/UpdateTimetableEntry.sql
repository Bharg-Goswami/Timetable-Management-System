-- SQL script for UpdateTimetableEntry 
GO

CREATE PROCEDURE UpdateTimetableEntry
    @TimetableId INT,
    @AcademicYearId INT = NULL,
    @FacultyId INT = NULL,
    @DepartmentId INT = NULL,
    @ProgramId INT = NULL,
    @AcademicClassId INT = NULL,
    @DivisionId INT = NULL,
    @SubjectId INT = NULL,
    @BatchId INT = NULL,
    @DayId INT = NULL,
    @TimeSlotId INT = NULL,
    @StaffId INT = NULL,
    @LocationId INT = NULL
AS
BEGIN
    UPDATE Timetable
    SET SubjectId = COALESCE(@SubjectId, SubjectId),
        StaffId = COALESCE(@StaffId, StaffId),
        LocationId = COALESCE(@LocationId, LocationId),
        TimeSlotId = COALESCE(@TimeSlotId, TimeSlotId),
        BatchId = COALESCE(@BatchId, BatchId),
        DivisionId = COALESCE(@DivisionId, DivisionId),
        ProgramId = COALESCE(@ProgramId, ProgramId),
        DepartmentId = COALESCE(@DepartmentId, DepartmentId),
        FacultyId = COALESCE(@FacultyId, FacultyId),
        AcademicYearId = COALESCE(@AcademicYearId, AcademicYearId),
        DayId = COALESCE(@DayId, DayId),
        AcademicClassId = COALESCE(@AcademicClassId, AcademicClassId),
        UpdationTimeStamp = GETDATE()
    WHERE TimetableId = @TimetableId;
END;
GO
