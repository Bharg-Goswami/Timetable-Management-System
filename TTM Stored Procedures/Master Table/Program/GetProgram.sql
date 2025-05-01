CREATE OR ALTER PROCEDURE GetProgram
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ProgramId,
        p.ProgramCode,
        p.ProgramName,
        p.ProgramType,
        p.Degree,
        p.AcademicYearId,
        ay.AcademicYearCode,
        p.DepartmentId,
        d.DepartmentName,
        d.FacultyId,
        f.FacultyName
    FROM Program p
    JOIN AcademicYear ay ON p.AcademicYearId = ay.AcademicYearId
    JOIN Department d ON p.DepartmentId = d.DepartmentId
    JOIN Faculty f ON d.FacultyId = f.FacultyId
    WHERE p.IsDeleted = 0
      AND p.IsDisabled = 0
      AND ay.IsDeleted = 0
      AND ay.IsDisabled = 0
      AND d.IsDeleted = 0
      AND d.IsDisabled = 0
      AND f.IsDeleted = 0
      AND f.IsDisabled = 0
    ORDER BY p.ProgramName;
END;

