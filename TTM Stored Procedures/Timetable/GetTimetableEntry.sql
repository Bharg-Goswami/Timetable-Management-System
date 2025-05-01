CREATE OR ALTER PROCEDURE GetTimetableEntry
    @TimetableId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        t.TimetableId,
        t.AcademicYearId,
        ay.AcademicYearCode,
        t.FacultyId,
        f.FacultyName,
        t.DepartmentId,
        d.DepartmentName,
        t.ProgramId,
        p.ProgramName,
        t.AcademicClassId,
        ac.AcademicClassName,
        t.DivisionId,
        div.DivisionName,
        t.SubjectId,
        s.SubjectName,
        t.BatchId,
        b.BatchName,
        t.DayId,
        wd.[DayName],
        t.TimeSlotId,
        ts.Timeslot,
        t.StaffId,
        u.FullName AS StaffName,
        u.FacultyId AS StaffFacultyId,
        sf.FacultyName AS StaffFacultyName,
        u.DepartmentId AS StaffDepartmentId,
        sd.DepartmentName AS StaffDepartmentName,
        t.LocationId,
        l.LocationName
    FROM Timetable t
    JOIN AcademicYear ay ON t.AcademicYearId = ay.AcademicYearId
    JOIN Faculty f ON t.FacultyId = f.FacultyId
    JOIN Department d ON t.DepartmentId = d.DepartmentId
    JOIN Program p ON t.ProgramId = p.ProgramId
    JOIN AcademicClass ac ON t.AcademicClassId = ac.AcademicClassId
    JOIN Division div ON t.DivisionId = div.DivisionId
    JOIN [Subject] s ON t.SubjectId = s.SubjectId
    JOIN Batch b ON t.BatchId = b.BatchId
    JOIN [WeekDay] wd ON t.DayId = wd.DayId
    JOIN TimeSlot ts ON t.TimeSlotId = ts.TimeSlotId
    JOIN StaffDetails st ON t.StaffId = st.StaffId
    JOIN Users u ON st.UserId = u.UserId
    JOIN Faculty sf ON u.FacultyId = sf.FacultyId
    JOIN Department sd ON u.DepartmentId = sd.DepartmentId
    JOIN [Location] l ON t.LocationId = l.LocationId
    WHERE t.TimetableId = @TimetableId
        AND t.IsDeleted = 0 
        AND t.IsDisabled = 0;
END