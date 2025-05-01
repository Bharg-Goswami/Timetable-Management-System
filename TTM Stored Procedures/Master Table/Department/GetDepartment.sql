CREATE OR ALTER PROCEDURE GetDepartment
    @FacultyId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        d.DepartmentId,
        d.DepartmentName,
        d.FacultyId,
        f.FacultyName
    FROM Department d
    JOIN Faculty f ON d.FacultyId = f.FacultyId
    WHERE d.IsDeleted = 0
      AND f.IsDeleted = 0
      AND f.IsDisabled = 0
    ORDER BY d.DepartmentName;
END;

