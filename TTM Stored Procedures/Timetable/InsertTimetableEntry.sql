CREATE OR ALTER PROCEDURE InsertTimetableEntry
    @AcademicYearId INT,
    @FacultyId INT,
    @DepartmentId INT,
    @ProgramId INT,
    @AcademicClassId INT,
    @DivisionId INT,
    @SubjectId INT,
    @BatchId INT,
    @DayId INT,
    @TimeSlotId INT,
    @StaffId INT,
    @LocationId INT
AS
BEGIN
    INSERT INTO Timetable 
    (AcademicYearId, FacultyId, DepartmentId, ProgramId, AcademicClassId, DivisionId, SubjectId, BatchId, DayId, TimeSlotId, StaffId, LocationId, CreationTimeStamp)
    VALUES 
    (@AcademicYearId, @FacultyId, @DepartmentId, @ProgramId, @AcademicClassId, @DivisionId, @SubjectId, @BatchId, @DayId, @TimeSlotId, @StaffId, @LocationId, GETDATE())
END