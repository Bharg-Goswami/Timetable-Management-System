CREATE OR ALTER PROCEDURE GetFaculty
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        f.FacultyId,
        f.FacultyName
    FROM Faculty f
    WHERE f.IsDeleted = 0
      AND f.IsDisabled = 0
    ORDER BY f.FacultyName;
END;

