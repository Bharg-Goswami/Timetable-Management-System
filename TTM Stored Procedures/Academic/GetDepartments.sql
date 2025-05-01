GO
-- Get Departments by FacultyId
CREATE PROCEDURE GetDepartments
    @FacultyId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DepartmentId,
        DepartmentName
    FROM Department
    WHERE FacultyId = @FacultyId
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO
