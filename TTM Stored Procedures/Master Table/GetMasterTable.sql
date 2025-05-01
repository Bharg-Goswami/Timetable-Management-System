CREATE OR ALTER PROCEDURE GetMasterTimetable
    @FacultyId INT = NULL,
    @DepartmentId INT = NULL,
    @ProgramId INT = NULL,
    @AcademicClassId INT = NULL,
    @DivisionId INT = NULL,
    @DayId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        t.TimetableId,
        ay.AcademicYearCode,
        f.FacultyName,
        d.DepartmentName,
        p.ProgramName,
        ac.AcademicClassName,
        div.DivisionName,
        s.SubjectName,
        b.BatchName,
        wd.DayName,
        ts.Timeslot,
        u.FullName AS StaffName,
        l.LocationName
    FROM Timetable t
    JOIN AcademicYear ay ON t.AcademicYearId = ay.AcademicYearId
    JOIN Faculty f ON t.FacultyId = f.FacultyId
    JOIN Department d ON t.DepartmentId = d.DepartmentId
    JOIN Program p ON t.ProgramId = p.ProgramId
    JOIN AcademicClass ac ON t.AcademicClassId = ac.AcademicClassId
    JOIN Division div ON t.DivisionId = div.DivisionId
    JOIN Subject s ON t.SubjectId = s.SubjectId
    LEFT JOIN Batch b ON t.BatchId = b.BatchId
    JOIN WeekDay wd ON t.DayId = wd.DayId
    JOIN TimeSlot ts ON t.TimeSlotId = ts.TimeSlotId
    JOIN StaffDetails st ON t.StaffId = st.StaffId
    JOIN Users u ON st.UserId = u.UserId
    JOIN Location l ON t.LocationId = l.LocationId
    WHERE t.IsDeleted = 0
      AND t.IsDisabled = 0
      AND (@FacultyId IS NULL OR t.FacultyId = @FacultyId)
      AND (@DepartmentId IS NULL OR t.DepartmentId = @DepartmentId)
      AND (@ProgramId IS NULL OR t.ProgramId = @ProgramId)
      AND (@AcademicClassId IS NULL OR t.AcademicClassId = @AcademicClassId)
      AND (@DivisionId IS NULL OR t.DivisionId = @DivisionId)
      AND (@DayId IS NULL OR t.DayId = @DayId)
    ORDER BY wd.DayId, ts.FromTime;
END;