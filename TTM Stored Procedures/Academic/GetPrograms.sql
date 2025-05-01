-- Get Programs by DepartmentId
CREATE PROCEDURE GetPrograms
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ProgramId,
        ProgramCode,
        ProgramName
    FROM Program 
    WHERE DepartmentId = @DepartmentId 
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO