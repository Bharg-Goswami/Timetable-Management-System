CREATE OR ALTER PROCEDURE GetTimetableEntries
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RoleName NVARCHAR(50)
    DECLARE @FacultyId INT
    DECLARE @DepartmentId INT
    DECLARE @DivisionId INT

    -- Get the role of the user
    SELECT TOP 1 @RoleName = R.RoleName
    FROM UserRole UR
    JOIN Role R ON UR.RoleId = R.RoleId
    WHERE UR.UserId = @UserId
    ORDER BY UR.FromDate DESC  -- Get the latest role

    IF @RoleName IS NULL
    BEGIN
        SELECT 'Access Denied: No role found for user.' AS Message;
        RETURN;
    END

    -- Get user's FacultyId, DepartmentId, and DivisionId
    SELECT 
        @FacultyId = U.FacultyId, 
        @DepartmentId = U.DepartmentId
    FROM Users U WHERE U.UserId = @UserId

    SELECT @DivisionId = SD.DivisionId
    FROM StudentDetails SD WHERE SD.UserId = @UserId

    -- Fetch timetable based on role
    IF @RoleName = 'Dean'
    BEGIN
        -- Dean can see all timetable entries of their faculty
        SELECT 
            TT.TimetableId,
            AY.AcademicYearId, AY.AcademicYearCode,
            F.FacultyId, F.FacultyName,
            D.DepartmentId, D.DepartmentName,
            P.ProgramId, P.ProgramName,
            AC.AcademicClassId, AC.AcademicClassName,
            DV.DivisionId, DV.DivisionName,
            S.SubjectId, S.SubjectName,
            B.BatchId, B.BatchName,
            WD.DayId, WD.DayName,
            TS.TimeSlotId, TS.Timeslot,
            ST.StaffId, U.FullName AS StaffName,
            L.LocationId, L.LocationName
        FROM TimeTable TT
        JOIN AcademicYear AY ON TT.AcademicYearId = AY.AcademicYearId
        JOIN Faculty F ON TT.FacultyId = F.FacultyId
        JOIN Department D ON TT.DepartmentId = D.DepartmentId
        JOIN Program P ON TT.ProgramId = P.ProgramId
        JOIN AcademicClass AC ON TT.AcademicClassId = AC.AcademicClassId
        JOIN Division DV ON TT.DivisionId = DV.DivisionId
        JOIN [Subject] S ON TT.SubjectId = S.SubjectId
        JOIN Batch B ON TT.BatchId = B.BatchId
        JOIN [WeekDay] WD ON TT.DayId = WD.DayId
        JOIN TimeSlot TS ON TT.TimeSlotId = TS.TimeSlotId
        JOIN StaffDetails ST ON TT.StaffId = ST.StaffId
        JOIN Users U ON ST.UserId = U.UserId
        JOIN [Location] L ON TT.LocationId = L.LocationId
        WHERE TT.FacultyId = @FacultyId
            AND TT.IsDeleted = 0 
            AND TT.IsDisabled = 0
    END
    ELSE IF @RoleName IN ('HOD', 'TTM', 'Teacher')
    BEGIN
        -- HOD, TTM, and Teacher can see timetable entries of their department
        SELECT 
            TT.TimetableId,
            AY.AcademicYearId, AY.AcademicYearCode,
            F.FacultyId, F.FacultyName,
            D.DepartmentId, D.DepartmentName,
            P.ProgramId, P.ProgramName,
            AC.AcademicClassId, AC.AcademicClassName,
            DV.DivisionId, DV.DivisionName,
            S.SubjectId, S.SubjectName,
            B.BatchId, B.BatchName,
            WD.DayId, WD.DayName,
            TS.TimeSlotId, TS.Timeslot,
            ST.StaffId, U.FullName AS StaffName,
            L.LocationId, L.LocationName
        FROM TimeTable TT
        JOIN AcademicYear AY ON TT.AcademicYearId = AY.AcademicYearId
        JOIN Faculty F ON TT.FacultyId = F.FacultyId
        JOIN Department D ON TT.DepartmentId = D.DepartmentId
        JOIN Program P ON TT.ProgramId = P.ProgramId
        JOIN AcademicClass AC ON TT.AcademicClassId = AC.AcademicClassId
        JOIN Division DV ON TT.DivisionId = DV.DivisionId
        JOIN [Subject] S ON TT.SubjectId = S.SubjectId
        JOIN Batch B ON TT.BatchId = B.BatchId
        JOIN [WeekDay] WD ON TT.DayId = WD.DayId
        JOIN TimeSlot TS ON TT.TimeSlotId = TS.TimeSlotId
        JOIN StaffDetails ST ON TT.StaffId = ST.StaffId
        JOIN Users U ON ST.UserId = U.UserId
        JOIN [Location] L ON TT.LocationId = L.LocationId
        WHERE TT.DepartmentId = @DepartmentId
            AND TT.IsDeleted = 0 
            AND TT.IsDisabled = 0
    END
    ELSE IF @RoleName = 'Student'
    BEGIN
        -- Students can only see timetable entries of their division
        SELECT 
            TT.TimetableId,
            AY.AcademicYearId, AY.AcademicYearCode,
            F.FacultyId, F.FacultyName,
            D.DepartmentId, D.DepartmentName,
            P.ProgramId, P.ProgramName,
            AC.AcademicClassId, AC.AcademicClassName,
            DV.DivisionId, DV.DivisionName,
            S.SubjectId, S.SubjectName,
            B.BatchId, B.BatchName,
            WD.DayId, WD.DayName,
            TS.TimeSlotId, TS.Timeslot,
            ST.StaffId, U.FullName AS StaffName,
            L.LocationId, L.LocationName
        FROM TimeTable TT
        JOIN AcademicYear AY ON TT.AcademicYearId = AY.AcademicYearId
        JOIN Faculty F ON TT.FacultyId = F.FacultyId
        JOIN Department D ON TT.DepartmentId = D.DepartmentId
        JOIN Program P ON TT.ProgramId = P.ProgramId
        JOIN AcademicClass AC ON TT.AcademicClassId = AC.AcademicClassId
        JOIN Division DV ON TT.DivisionId = DV.DivisionId
        JOIN [Subject] S ON TT.SubjectId = S.SubjectId
        JOIN Batch B ON TT.BatchId = B.BatchId
        JOIN [WeekDay] WD ON TT.DayId = WD.DayId
        JOIN TimeSlot TS ON TT.TimeSlotId = TS.TimeSlotId
        JOIN StaffDetails ST ON TT.StaffId = ST.StaffId
        JOIN Users U ON ST.UserId = U.UserId
        JOIN [Location] L ON TT.LocationId = L.LocationId
        WHERE TT.DivisionId = @DivisionId
                AND TT.IsDeleted = 0 
                AND TT.IsDisabled = 0;
    END
    ELSE
    BEGIN
        -- Admin or unauthorized users should not access the timetable
        SELECT 'Access Denied' AS Message
    END
END
