-- GetRolePermissions: Get permissions assigned to a role
CREATE OR ALTER PROCEDURE GetRolePermissions
    @RoleId INT
AS
BEGIN
    SELECT P.[PermissionName]
    FROM RolePermission RP
    JOIN [Permission] P ON RP.PermissionId = P.PermissionId
    WHERE RP.RoleId = @RoleId
    AND P.IsDeleted = 0
    AND P.IsDisabled = 0
END
GO