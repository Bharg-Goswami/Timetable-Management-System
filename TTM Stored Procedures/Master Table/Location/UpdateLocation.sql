CREATE OR ALTER PROCEDURE UpdateLocation
    @LocationId INT,
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
        -- Check if Location exists
        IF NOT EXISTS (SELECT 1 FROM Location WHERE LocationId = @LocationId AND IsDeleted = 0)
        BEGIN
            THROW 50014, 'Error: Location not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            THROW 50015, 'Error: Faculty not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
        BEGIN
            THROW 50016, 'Error: Department not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate LocationCode
        IF EXISTS (SELECT 1 FROM Location WHERE LocationCode = @LocationCode AND LocationId <> @LocationId AND IsDeleted = 0)
        BEGIN
            THROW 50017, 'Error: Location code already exists.', 1;
            RETURN;
        END

        -- Update Location
        UPDATE Location
        SET LocationCode = @LocationCode,
            LocationName = @LocationName,
            FloorNo = @FloorNo,
            BuildingName = @BuildingName,
            Description = @Description,
            Capacity = @Capacity,
            FacultyId = @FacultyId,
            DepartmentId = @DepartmentId,
            UpdationTimeStamp = GETDATE()
        WHERE LocationId = @LocationId;

        COMMIT TRANSACTION;
        PRINT 'Success: Location updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

