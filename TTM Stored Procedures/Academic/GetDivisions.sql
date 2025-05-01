-- Get Divisions by AcademicClassId
CREATE PROCEDURE GetDivisions
    @AcademicClassId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DivisionId,
        DivisionName
    FROM Division 
    WHERE AcademicClassId = @AcademicClassId 
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO