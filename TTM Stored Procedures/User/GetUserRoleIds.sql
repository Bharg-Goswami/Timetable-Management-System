-- GetUserRoleIds: Get role IDs assigned to a user
CREATE OR ALTER PROCEDURE GetUserRoleIds
    @UserId INT
AS
BEGIN
    SELECT RoleId
    FROM UserRole
    WHERE UserId = @UserId
    AND IsDeleted = 0
    AND IsDisabled = 0
END
GO