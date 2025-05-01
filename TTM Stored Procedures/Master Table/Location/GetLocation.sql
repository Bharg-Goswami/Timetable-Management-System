CREATE OR ALTER PROCEDURE GetLocation
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        l.LocationId,
        l.LocationCode,
        l.LocationName,
        l.FloorNo,
        l.BuildingName,
        l.Description,
        l.Capacity,
        l.FacultyId,
        f.FacultyName,
        l.DepartmentId,
        d.DepartmentName
    FROM Location l
    JOIN Faculty f ON l.FacultyId = f.FacultyId
    JOIN Department d ON l.DepartmentId = d.DepartmentId
    WHERE l.IsDeleted = 0
      AND l.IsDisabled = 0
      AND f.IsDeleted = 0
      AND f.IsDisabled = 0
      AND d.IsDeleted = 0
      AND d.IsDisabled = 0
    ORDER BY l.LocationName;
END;

