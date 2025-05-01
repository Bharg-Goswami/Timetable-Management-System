CREATE OR ALTER PROCEDURE GetDivision
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        div.DivisionId,
        div.DivisionName,
        div.AcademicClassId,
        ac.AcademicClassName,
        ac.ProgramId,
        p.ProgramName,
        p.DepartmentId,
        d.DepartmentName,
        d.FacultyId,
        f.FacultyName
    FROM Division div
    JOIN AcademicClass ac ON div.AcademicClassId = ac.AcademicClassId
    JOIN Program p ON ac.ProgramId = p.ProgramId
    JOIN Department d ON p.DepartmentId = d.DepartmentId
    JOIN Faculty f ON d.FacultyId = f.FacultyId
    WHERE div.IsDeleted = 0
      AND div.IsDisabled = 0
      AND ac.IsDeleted = 0
      AND ac.IsDisabled = 0
      AND p.IsDeleted = 0
      AND p.IsDisabled = 0
      AND d.IsDeleted = 0
      AND d.IsDisabled = 0
      AND f.IsDeleted = 0
      AND f.IsDisabled = 0
    ORDER BY div.DivisionName;
END;

