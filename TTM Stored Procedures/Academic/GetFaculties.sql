GO
-- Get Faculties
CREATE PROCEDURE GetFaculties
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FacultyId,
        FacultyName
    FROM Faculty 
    WHERE IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO