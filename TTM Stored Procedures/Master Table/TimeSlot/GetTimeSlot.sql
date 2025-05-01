CREATE OR ALTER PROCEDURE GetTimeSlot
    @ProgramId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ts.TimeSlotId,
        ts.Timeslot,
        ts.FromTime,
        ts.ToTime,
        ts.ProgramId,
        p.ProgramName,
        p.DepartmentId,
        d.DepartmentName,
        d.FacultyId,
        f.FacultyName
    FROM TimeSlot ts
    JOIN Program p ON ts.ProgramId = p.ProgramId
    JOIN Department d ON p.DepartmentId = d.DepartmentId
    JOIN Faculty f ON d.FacultyId = f.FacultyId
    WHERE ts.IsDeleted = 0
      AND ts.IsDisabled = 0
      AND p.IsDeleted = 0
      AND p.IsDisabled = 0
      AND d.IsDeleted = 0
      AND d.IsDisabled = 0
      AND f.IsDeleted = 0
      AND f.IsDisabled = 0
      AND (@ProgramId IS NULL OR ts.ProgramId = @ProgramId)
    ORDER BY ts.Timeslot;
END;

