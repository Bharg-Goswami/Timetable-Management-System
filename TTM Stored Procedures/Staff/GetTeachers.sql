-- Get Staff by DepartmentId (excluding disabled ones)
CREATE PROCEDURE GetTeachers
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        S.StaffId, 
        U.FullName
    FROM StaffDetails S
    INNER JOIN Users U ON S.UserId = U.UserId
    WHERE U.DepartmentId = @DepartmentId
        AND S.IsDeleted = 0 
        AND S.IsDisabled = 0;
END;
GO