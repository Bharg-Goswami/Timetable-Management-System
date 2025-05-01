CREATE OR ALTER PROCEDURE CreateLocation
    @LocationCode VARCHAR(50),
    @LocationName VARCHAR(255),
    @FloorNo INT,
    @BuildingName VARCHAR(255),
    @Description VARCHAR(500),
    @Capacity INT,
    @FacultyId INT,
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            THROW 50011, 'Error: Faculty not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
        BEGIN
            THROW 50012, 'Error: Department not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate LocationCode
        IF EXISTS (SELECT 1 FROM Location WHERE LocationCode = @LocationCode AND IsDeleted = 0)
        BEGIN
            THROW 50013, 'Error: Location code already exists.', 1;
            RETURN;
        END

        -- Insert new Location
        INSERT INTO Location (LocationCode, LocationName, FloorNo, BuildingName, Description, Capacity, FacultyId, DepartmentId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@LocationCode, @LocationName, @FloorNo, @BuildingName, @Description, @Capacity, @FacultyId, @DepartmentId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Location created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

