/* SQL PROJECT */
USE MASTER
GO

/* Create new database */
CREATE DATABASE CourseRegistrationDB
GO

/* Change context to new database before creating tables */
USE CourseRegistrationDB
GO

/* Table Creation Scripts */

-- Table: Student
CREATE TABLE Student (
	G_Number CHAR(9) NOT NULL
	,Last_Name VARCHAR(20) NOT NULL
	,First_Name VARCHAR(20) NOT NULL
	,Street_Num VARCHAR(6)
	,Street_Name VARCHAR(50)
	,City VARCHAR(20)
	,[STATE] CHAR(2)
	,Zip CHAR(5)
	,SSN CHAR(9) NOT NULL
	,Major_Code VARCHAR(4) NOT NULL
	);

-- Table: Course
CREATE TABLE Course (
	Subject_Code CHAR(4) NOT NULL
	,Course_Number CHAR(3) NOT NULL
	,Course_Name VARCHAR(30) NOT NULL
	,[Description] VARCHAR(250)
	,Credit_Hours DECIMAL(2, 1) NOT NULL
	,DEPT_CODE CHAR(4) NOT NULL
	);

-- Table: Course_Offering
CREATE TABLE Course_Offering (
	CRN CHAR(5) NOT NULL
	,Semester CHAR(2) NOT NULL
	,SemYear CHAR(4) NOT NULL
	,Section VARCHAR(3) NOT NULL
	,Max_Students INT NOT NULL
	,Faculty_G_Number CHAR(9)
	,Subject_Code CHAR(4) NOT NULL
	,Course_Number CHAR(3) NOT NULL
	);

-- Table: Registration
CREATE TABLE Registration (
	Student_G_Number CHAR(9) NOT NULL
	,CRN CHAR(5) NOT NULL
	,regDateTime DATETIME NOT NULL
	,Grade CHAR(2)
	,[STATUS] CHAR(1) NOT NULL
	);

-- Table: Department
CREATE TABLE Department (
	DEPT_CODE CHAR(4) NOT NULL
	,Dept_Name VARCHAR(30) NOT NULL
	);

-- Table: Faculty
CREATE TABLE Faculty (
	G_Number CHAR(9) NOT NULL
	,Last_Name VARCHAR(20) NOT NULL
	,First_Name VARCHAR(20) NOT NULL
	,Position VARCHAR(20)
	);

-- Table: Faculty_Appointment
CREATE TABLE Faculty_Appointment (
	DEPT_CODE CHAR(4) NOT NULL
	,Faculty_G_Number CHAR(9) NOT NULL
	,Date_Since DATETIME NOT NULL
	);

-- Table: Classrooms
CREATE TABLE Classrooms (
	Room_Number CHAR(4) NOT NULL
	,Building_Code CHAR(3) NOT NULL
	,Seating_Capacity INT NOT NULL
	,Computer BIT
	,Projector BIT
	,Laptop_Hookup BIT
	);

-- Table: Buildings
CREATE TABLE Buildings (
	Building_Code CHAR(3) NOT NULL
	,Building_Name VARCHAR(30) NOT NULL
	,Street_Number VARCHAR(4)
	,Street_Name VARCHAR(50)
	,Mail_Stop_Num VARCHAR(3)
	,City VARCHAR(20)
	,[STATE] CHAR(2)
	,Zip CHAR(5)
	);

-- Table: Course_Timings
CREATE TABLE Course_Timings (
	Schedule_Code CHAR(10) NOT NULL
	,Day_of_Week_1 CHAR(1) NOT NULL
	,Begin_Time_1 DATETIME NOT NULL
	,End_Time_1 DATETIME NOT NULL
	,Day_of_Week_2 CHAR(1)
	,Begin_Time_2 DATETIME
	,End_Time_2 DATETIME
	,Room_Number CHAR(4) NOT NULL
	,Building_Code CHAR(3) NOT NULL
	,CRN CHAR(5) NOT NULL
	);

/* Adding Primary Keys */

-- Primary Key: Student
ALTER TABLE Student 
ADD 
	CONSTRAINT PK_Student 
		PRIMARY KEY (G_Number);
-- Primary Key: Course
ALTER TABLE Course 
ADD 
	CONSTRAINT PK_Course 
		PRIMARY KEY (
					Subject_Code
					,Course_Number
					);
-- Primary Key: Course_Offering
ALTER TABLE Course_Offering 
ADD 
	CONSTRAINT 
		PK_Course_Offering 
			PRIMARY KEY (CRN);
-- Primary Key: Registration
ALTER TABLE Registration 
ADD 
	CONSTRAINT PK_Registration 
		PRIMARY KEY (
					Student_G_Number
					,CRN
					);
-- Primary Key: Department
ALTER TABLE Department 
ADD 
	CONSTRAINT PK_Department 
		PRIMARY KEY (DEPT_CODE);
-- Primary Key: Faculty
ALTER TABLE Faculty 
ADD 
	CONSTRAINT PK_Faculty 
		PRIMARY KEY (G_Number);
-- Primary Key: Faculty_Appointment
ALTER TABLE Faculty_Appointment 
ADD 
	CONSTRAINT PK_Faculty_Appointment 
		PRIMARY KEY (
					DEPT_CODE
					,Faculty_G_Number
					);
-- Primary Key: Classrooms
ALTER TABLE Classrooms 
ADD 
	CONSTRAINT PK_Classrooms 
		PRIMARY KEY (
					Room_Number
					,Building_Code
					);
-- Primary Key: Buildings
ALTER TABLE Buildings 
ADD 
	CONSTRAINT PK_Buildings 
		PRIMARY KEY (Building_Code);
-- Primary Key: Course_Timings
ALTER TABLE Course_Timings 
ADD 
	CONSTRAINT PK_Course_Timings 
		PRIMARY KEY (Schedule_Code);

/* Adding Foreign Keys */

-- Foreign Key: Course_Offering
ALTER TABLE Course_Offering 
ADD 
	CONSTRAINT FK_Course_Offering_Faculty 
		FOREIGN KEY (Faculty_G_Number) 
		REFERENCES Faculty(G_Number)

	,CONSTRAINT FK_Course_Offering_Course 
		FOREIGN KEY (
					Subject_Code
					,Course_Number
					) 
		REFERENCES Course(
						Subject_Code
						,Course_Number
						);
-- Foreign Key: Registration
ALTER TABLE Registration 
ADD 
	CONSTRAINT FK_Registration_Student 
		FOREIGN KEY (Student_G_Number) 
		REFERENCES Student (G_Number)
		
	,CONSTRAINT FK_Registration_Course_Offering 
		FOREIGN KEY (CRN) 
		REFERENCES Course_Offering (CRN);
-- Foreign Key: Faculty_Appointment
ALTER TABLE Faculty_Appointment 
ADD 
	CONSTRAINT FK_Faculty_Appointment_Department 
		FOREIGN KEY (DEPT_CODE) 
		REFERENCES Department (DEPT_CODE)
		
	,CONSTRAINT FK_Faculty_Appointment_Faculty 
		FOREIGN KEY (Faculty_G_Number) 
		REFERENCES Faculty (G_Number);
-- Foreign Key: Classrooms
ALTER TABLE Classrooms 
ADD 
	CONSTRAINT FK_Classrooms_Buildings 
		FOREIGN KEY (Building_Code) 
		REFERENCES Buildings (Building_Code);

-- Foreign Key: Course_Timings
ALTER TABLE Course_Timings 
ADD 
	CONSTRAINT FK_Course_Timings_Classrooms 
		FOREIGN KEY (
					Room_Number
					,Building_Code
					) 
		REFERENCES Classrooms (
					Room_Number
					,Building_Code
					)
					
	,CONSTRAINT FK_Course_Timings_Course_Offering 
		FOREIGN KEY (CRN) 
		REFERENCES Course_Offering (CRN);

/*  ADDING OTHER CONSTRAINTS (DEFAULT; UNIQUE; CHECK) TO TABLES */

/*
1.	TABLE: STUDENT
	a.	G-Number always begins with G and is followed by mix of up to 8 alphabets and digits.  
	b.	Last Name, and First Name can only include alphabets spaces and hyphens 
	c.	Zip can only be 5 digits
	d.	Major Code default value is UNDC, otherwise it is either 3 or 4 alphabets
	e.	No two students can have the same SSN

*/
ALTER TABLE STUDENT
ADD
	/*
		a.	G-Number always begins with G and is followed by mix of up to 8 alphabets and digits.  
	*/
	CONSTRAINT CHK_GNum 
		CHECK (
			G_Number LIKE 'G%' -- begins with a G
			AND 
			G_Number NOT LIKE '%[^A-Z0-9]%' -- nothing other than A-Z0-9
			AND
			LEN(G_Number) = 9 -- G followed by 8 alphabets and digits
		)
	/*
		b.	Last Name, and First Name can only include alphabets spaces and hyphens 
	*/
	, CONSTRAINT CHK_FName_LName 
		CHECK (
			First_Name NOT LIKE '%[^A-Z -]%' -- nothing other than A-Z space -
			AND
			Last_Name NOT LIKE '%[^A-Z -]%' -- nothing other than A-Z space -
		)
	/*
		c.	Zip can only be 5 digits
	*/
	, CONSTRAINT CHK_ZIP 
		CHECK (
			ZIP NOT LIKE '%[^0-9]%' -- nothing other than 0-9
			AND
			LEN(ZIP) = 5
		) -- alternative: ZIP LIKE '[0-9][0-9][0-9][0-9][0-9]'
	/*
		d.	PART 1: Major Code default value is UNDC 
	*/
	, CONSTRAINT DEF_Major DEFAULT 'UNDC' FOR Major_Code 
	/*
		d.	PART 2: otherwise it is either 3 or 4 alphabets 
	*/
	, CONSTRAINT CHK_MajorCodeLength
		CHECK (LEN(Major_Code) BETWEEN 3 AND 4)
	/*
		e.	No two students can have the same SSN
		NOTE: Unique Constraint does not allow for NULL
	*/
	, CONSTRAINT UQ_SSN 
		UNIQUE(SSN)
;

/*
2.	TABLE: REGISTRATION
a.	regDateTime: if data is not provided, it is default set to datetime at the time of INSERT
b.	Status can be only one of: E, W, A
c.	Grade:
	i.	Only for Status E can there be grade; otherwise it should be NULL
	ii.	Grade, if present, can be only one of: A+, A, A-, B+, B, B-, C+, C, D, F
*/


ALTER TABLE REGISTRATION
	ADD
	/*
		a.	regDateTime: if data is not provided, it is default set to datetime at the time of INSERT
	*/
	CONSTRAINT DEF_regDate DEFAULT GETDATE() FOR regDateTime
	/*
		b.	Status can be only one of: E, W, A
	*/
	, CONSTRAINT CHK_STATUS
		CHECK (
				[STATUS] IN ('E','W', 'A')
			)
	/*
		c.	Grade:
		i.	Only for Status E can there be grade; otherwise it should be NULL
		ii.	Grade, if present, can be only one of: A+, A, A-, B+, B, B-, C+, C, D, F

	*/
	, CONSTRAINT CHK_GRADE
		CHECK (
				(
					[STATUS] = 'E' 
					AND GRADE IN 
						('A+','A','A-','B+','B','B-','C+','C','D','F')
				)
				OR
				GRADE IS NULL
			)

;

/*
3.	TABLE: COURSE
	a.	Course Name can only include alphabets, spaces, digits and hyphens
	b.	Credit Hours allowed values are 0, 1, 1.5, 2, 3, 6
*/
ALTER TABLE COURSE
ADD
	/*
		a.	Course Name can only include alphabets, spaces, digits and hyphens
	*/
	CONSTRAINT CHK_CourseName 
		CHECK (
			Course_Name NOT LIKE '%[^A-Z0-9 -]%'
		)
	/*
		b.	Credit Hours allowed values are 0, 1, 1.5, 2, 3, 6
	*/
	, CONSTRAINT CHK_CreditHours
		CHECK (
			Credit_Hours IN (0, 1, 1.5, 2, 3, 6)
		)
	
;

/*
4.	TABLE: [COURSE OFFERING]
	a.	SemYear can be any year between 1990s to 2999 (Hint: SemYear is implemented as char(4), not a number)
	b.	Section number is always 3 digits
	c.	CRN is a surrogate key introduced to replace previous primary key which was composite of (Subject Code, Course Number, Semester, SemYear, Section)
*/

ALTER TABLE COURSE_OFFERING
ADD
	/*
		a.	SemYear can be any year between 1990s to 2999 (Hint: SemYear is implemented as char(4), not a number)
	*/
	CONSTRAINT CHK_SemYear
		CHECK (
			CAST(SemYear AS INT) BETWEEN 1990 AND 2999
		)
	/*
			b.	Section number is always 3 digits
	*/
	, CONSTRAINT CHK_Section
		CHECK ( 
			LEN(Section) = 3 
			AND Section NOT LIKE '%[^0-9]%'
		)
	/*
		c.	CRN is a surrogate key introduced to replace previous primary key which was composite of (Subject Code, Course Number, Semester, SemYear, Section)
	*/
	, CONSTRAINT UQ_courseOffer
		UNIQUE(
				Subject_Code
				, Course_Number
				, Semester
				, SemYear
				, Section
				)
;

/*
10.	TABLE: FACULTY
	a.	G-Number always begins with G and is followed by mix of up to 8 alphabets and digits.  (Hint: check for presence of any value outside of [A-Z] and [0-9])
	b.	Last Name, and First Name can only include alphabets space hyphen (Hint: check for presence of any value outside of A-Z to make the decision)

*/
ALTER TABLE FACULTY
ADD
	/*
	a.	G-Number always begins with G and is followed by mix of up to 8 alphabets and digits.  (Hint: check for presence of any value outside of [A-Z] and [0-9])
	*/
	CONSTRAINT CHK_FGNUMBER
		CHECK (
			G_Number LIKE 'G%' -- begins with a G
			AND 
			G_Number NOT LIKE '%[^A-Z0-9]%' -- nothing other than A-Z0-9
			AND
			LEN(G_Number) = 9 -- G followed by 8 alphabets and digits
		)
	/*
		b.	Last Name, and First Name can only include alphabets space hyphen
	*/
	, CONSTRAINT CHK_Fac_FName_LName 
		CHECK (
			First_Name NOT LIKE '%[^A-Z -]%' -- nothing other than A-Z space -
			AND
			Last_Name NOT LIKE '%[^A-Z -]%' -- nothing other than A-Z space -
		)
;


-- Constraints
/* Check Constraint on Faculty Table for Position */
ALTER TABLE Faculty
ADD CONSTRAINT CHK_Position CHECK (Position IN ('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer'));


/* Foregin key Constraint on Course_Timings Table for Room and Builing */
ALTER TABLE Course_Timings
ADD CONSTRAINT FK_Course_Timings_Room_Building FOREIGN KEY (Room_Number, Building_Code) REFERENCES Classrooms (Room_Number, Building_Code);

ALTER TABLE Course_Timings
ADD CONSTRAINT CHK_Time_Range CHECK (Begin_Time_1 < End_Time_1 AND (Begin_Time_2 IS NULL OR Begin_Time_2 < End_Time_2));

/*Check constraints on Buildings ensuring:
  A)Building_Code is composed of letters only
  B)Preventing spaces at the beginning or end*/
ALTER TABLE Buildings
ADD 
  CONSTRAINT CHK_Building_Code
    CHECK(
      Building_Code NOT LIKE '%[^A-Z -]%'
      AND Building_Code NOT LIKE ' %' 
      AND Building_Code NOT LIKE '% ' 
         );
/* Check constraint ensuring:
  A)State is exactly 2 letters
  B)Preventing spaces at the beginning or end
  C)State is composed of letters only */
   ALTER TABLE Buildings
   ADD
   CONSTRAINT CHK_STATE
    CHECK (
      [STATE] NOT LIKE '%[^A-Z]%'
      AND LEN([STATE]) = 2
      AND [STATE] NOT LIKE ' %'  
      AND [STATE] NOT LIKE '% '
      )
  ;
-- Composite key of Subject_Code and Course_Number
ALTER TABLE COURSE
ADD
CONSTRAINT UQ_Course UNIQUE (Subject_Code, Course_Number);

/*
Ensures faculty cannot be appointed to a department before the university was founded by preventing invalid appointment dates that are too far in the past before the GMU was founded.
*/
ALTER TABLE Faculty_Appointment
ADD CONSTRAINT CHK_Appointment_After_1949 
CHECK (YEAR(Date_Since) >= 1949 AND Date_Since <= GETDATE());

-- Ensures department names entered are only letters, hyphens, & spaces.
ALTER TABLE Department
ADD CONSTRAINT CHK_Dept_Name CHECK (Dept_Name NOT LIKE '%[^A-Z -]%' AND Dept_Name NOT LIKE ' %' AND Dept_Name NOT LIKE '% ');

ALTER TABLE Faculty 
ADD CONSTRAINT UQ_FacultyName UNIQUE (First_Name, Last_Name);

/*                                                                                                                  
Prevent typos by standardizing input for scheduling. The Day_of_Week_1 column in the Course_Timings table can only contain a valid three-character abbreviation representing a day of the week.
*/
ALTER TABLE Course_Timings
ADD CONSTRAINT CHK_Day_of_Week_1 
CHECK (Day_of_Week_1 IN ('M', 'T', 'W', 'R', 'F'));

-- Ensures ZIP code is a 5-digit number (Mason Korea also uses 5-digit)
ALTER TABLE Buildings
ADD CONSTRAINT CHK_Building_Zip CHECK (Zip NOT LIKE '%[^0-9]%' AND LEN(Zip) = 5);

--FUNCTIONS

--1) Returns a report for a given student.

CREATE FUNCTION GetStudentTranscript(@GNumber CHAR(9))
RETURNS TABLE
AS
RETURN
(
    SELECT
        CONCAT(CO.Semester, ' ', CO.SemYear) AS SemesterYear,
        C.Course_Number,
        C.Course_Name,
        R.Grade
    FROM Registration R
    JOIN Course_Offering CO 
		ON R.CRN = CO.CRN
    JOIN Course C 
		ON CO.Subject_Code = C.Subject_Code AND CO.Course_Number = C.course_Number
    WHERE R.Student_G_Number = @GNumber
);
GO

--2)Returns a summary about specific course offering based on its CRN.

CREATE FUNCTION GetCourseInfoByCRN(@CRN CHAR(5))
RETURNS TABLE
AS
RETURN
(
    SELECT
        CONCAT(C.Course_Number, C.Course_Name, CO.Section) AS CourseInfo, 
        CO.Max_Students,
        COUNT(R.Student_G_Number) AS NumberEnrolled
    FROM Course_Offering CO
    JOIN Course C ON C.Subject_Code = CO.Subject_Code AND C.Course_Number = CO.Course_Number
    LEFT JOIN Registration R ON CO.CRN = R.CRN
    WHERE CO.CRN = @CRN
    GROUP BY C.Course_Number, C.Course_Name, CO.Section, CO.Max_Students
);
GO

--3)It calculates how many days hasve passed between the semester start date of a specific course offering and a given registration date.
CREATE FUNCTION DaysSinceSemesterStart(
    @CRN CHAR(5),
    @RegDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @SemStart DATE;
    DECLARE @DaysPassed INT;

    -- Get the semester start date for the CRN
    SELECT @SemStart = MIN(CT.Begin_Time_1)
    FROM Course_Timings CT
    JOIN Course_Offering CO ON CT.CRN = CO.CRN
    WHERE CO.CRN = @CRN;

    -- Calculate the difference in days between registration date and semester start
    SET @DaysPassed = DATEDIFF(DAY, @SemStart, @RegDate);

    RETURN @DaysPassed;
END;
GO

--VIEWS

--View Table for Course Offerings 
CREATE VIEW COURSE_OFFERINGS 
AS 
SELECT
CO.CRN
, CO.SEMESTER
, CO.SemYear AS [Semester year]
, CO.SECTION
, C.SUBJECT_CODE
, C.COURSE_NUMBER
, C.[Description] 
, C.CREDIT_HOURS
, CONCAT(F.FIRST_NAME, F.LAST_NAME) AS [FACTULY FULL NAME]
, F.POSITION AS [FACULTY POSITION]
, CT.DAY_OF_WEEK_1
, CT.BEGIN_TIME_1
, CT.END_TIME_1
, CT.DAY_OF_WEEK_2
, CT.BEGIN_TIME_2
, CT.END_TIME_2
, CL.ROOM_NUMBER 
, CL.BUILDING_CODE
, B.BUILDING_NAME

FROM COURSE_OFFERING CO JOIN COURSE C
    ON CO.SUBJECT_CODE = C.SUBJECT_CODE 
        AND CO.COURSE_NUMBER = C.COURSE_NUMBER
LEFT JOIN FACULTY F
    ON CO.FACULTY_G_NUMBER = F.G_NUMBER 
LEFT JOIN COURSE_TIMINGS CT
    ON CO.CRN = CT.CRN
LEFT JOIN Classrooms CL
    ON CT.ROOM_NUMBER = CL.ROOM_NUMBER
        AND CT.BUILDING_CODE = CL.BUILDING_CODE
LEFT JOIN Buildings B
    ON CL.BUILDING_CODE = B.BUILDING_CODE

--View table for Master Class Roster
CREATE VIEW Master_Class_Roster 
AS
SELECT
    CONCAT(s.First_Name, s.Last_Name) as [Full Name]
    , S.G_Number
    , S.Major_Code
    , R.regDateTime
    , R.Grade
    , R.CRN
FROM
    Student S JOIN Registration R 
            ON S.G_Number = R.Student_G_Number;

-- View Table for Enrollment Report
CREATE VIEW Enrollment_Report AS
SELECT
    CO.Semester,
    CO.SemYear,
    CONCAT(C.Subject_Code, C.Course_Number) AS Subject_Course,
    CO.Section,
    C.Course_Name,
    CONCAT(B.Building_Name, CT.Room_Number) AS Location,
    CONCAT(F.First_Name, F.Last_Name) AS Faculty_Name,
    CO.Max_Students AS Max_Enrollment,
    COUNT(R.Student_G_Number) AS Number_Enrolled
FROM Course_Offering CO
JOIN Course C 
    ON CO.Subject_Code = C.Subject_Code AND CO.Course_Number = C.Course_Number
JOIN Faculty F 
    ON CO.Faculty_G_Number = F.G_Number
JOIN Course_Timings CT 
    ON CO.CRN = CT.CRN
JOIN Buildings B 
    ON CT.Building_Code = B.Building_Code
LEFT JOIN Registration R 
    ON CO.CRN = R.CRN
GROUP BY 
    CO.Semester,
    CO.SemYear,
    C.Subject_Code,
    C.Course_Number,
    CO.Section,
    C.Course_Name,
    B.Building_Name,
    CT.Room_Number,
    F.First_Name,
    F.Last_Name,
    CO.Max_Students;

--TRIGGERS

--Trigger that prevents students from registering for overlapping classes.

CREATE TRIGGER trigger_CheckStudentRegistration
ON Registration
AFTER INSERT
AS
BEGIN
    -- Check for course over-enrollment based on the new inserts
    IF EXISTS (
        SELECT i.CRN
        FROM inserted i
        JOIN Course_Offering co ON i.CRN = co.CRN
        GROUP BY i.CRN, co.Max_Students
        HAVING 
            COUNT(*) + (
                SELECT COUNT(*) 
                FROM Registration r 
                WHERE r.CRN = i.CRN
            ) > co.Max_Students
    )
    BEGIN
        PRINT 'REGISTRATION FAILED: Course is full silly.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


--Trigger that prevents multiple sections of the same course in the same semester.

   CREATE TRIGGER trigger_PreventMultipleSectionsSameCourse
ON Registration
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Course_Offering co_new ON i.CRN = co_new.CRN
        JOIN Registration r ON i.Student_G_Number = r.Student_G_Number
        JOIN Course_Offering co_existing ON r.CRN = co_existing.CRN
        WHERE co_new.Subject_Code = co_existing.Subject_Code
          AND co_new.Course_Number = co_existing.Course_Number
          AND co_new.Semester = co_existing.Semester
          AND co_new.SemYear = co_existing.SemYear
          AND co_new.CRN <> co_existing.CRN
    )
    BEGIN
        PRINT 'REGISTRATION FAILED: You cannot register for multiple sections of the same course in the same semester, goofy.';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


-- Trigger that prevents students from registering for overlapping classes. 

  CREATE TRIGGER trigger_CheckTimeConflict
ON Registration
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Course_Offering co_new ON i.CRN = co_new.CRN
        JOIN Course_Timings ct_new ON co_new.CRN = ct_new.CRN
        JOIN Registration r ON i.Student_G_Number = r.Student_G_Number
        JOIN Course_Offering co_existing ON r.CRN = co_existing.CRN
        JOIN Course_Timings ct_existing ON co_existing.CRN = ct_existing.CRN
        WHERE co_new.Semester = co_existing.Semester
          AND co_new.SemYear = co_existing.SemYear
          AND (
              -- Compare all day combinations
              ct_new.Day_of_Week_1 = ct_existing.Day_of_Week_1 OR
              ct_new.Day_of_Week_1 = ct_existing.Day_of_Week_2 OR
              ct_new.Day_of_Week_2 = ct_existing.Day_of_Week_1 OR
              ct_new.Day_of_Week_2 = ct_existing.Day_of_Week_2
          )
          AND (
              ct_new.Begin_Time_1 < ct_existing.End_Time_1 AND
              ct_new.End_Time_1 > ct_existing.Begin_Time_1
          )
    )
    BEGIN
        PRINT 'REGISTRATION FAILED: Course time conflicts with an existing registration :(';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

--Trigger that enforces maximum teaching load for faculty.

CREATE TRIGGER trg_ChecksFacultyTeachingAssignments
ON Course_Offering
AFTER INSERT, UPDATE 
AS 
BEGIN
    IF EXISTS (
        SELECT co.Faculty_G_Number, co.Semester, co.SemYear
        FROM Course_Offering co
        JOIN inserted i
            ON co.Faculty_G_Number = i.Faculty_G_Number
           AND co.Semester = i.Semester
           AND co.SemYear = i.SemYear
        WHERE co.Faculty_G_Number IS NOT NULL
        GROUP BY co.Faculty_G_Number, co.Semester, co.SemYear
        HAVING COUNT(*) > 4
    )
    BEGIN
        PRINT 'REGISTRATION FAILED: Faculty members are limited to four teaching assignments per semester.';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


--Trigger that prevents assigning a faculty member to overlapping class times within the same semester.

CREATE TRIGGER trg_FacultyTimeConflict
ON Course_Offering
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Course_Timings ct_new ON i.CRN = ct_new.CRN
        JOIN Course_Offering co_existing 
            ON co_existing.Faculty_G_Number = i.Faculty_G_Number
           AND co_existing.Semester = i.Semester
           AND co_existing.SemYear = i.SemYear
           AND co_existing.CRN <> i.CRN
        JOIN Course_Timings ct_existing ON co_existing.CRN = ct_existing.CRN
        WHERE i.Faculty_G_Number IS NOT NULL
          AND (
              ct_new.Day_of_Week_1 = ct_existing.Day_of_Week_1 OR
              ct_new.Day_of_Week_1 = ct_existing.Day_of_Week_2 OR
              ct_new.Day_of_Week_2 = ct_existing.Day_of_Week_1 OR
              ct_new.Day_of_Week_2 = ct_existing.Day_of_Week_2
          )
          AND (
              ct_new.Begin_Time_1 < ct_existing.End_Time_1 AND
              ct_new.End_Time_1 > ct_existing.Begin_Time_1
          )
    )
    BEGIN
        PRINT 'REGISTRATION FAILED: Faculty has a scheduling conflict between course times.';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

--An after update trigger on the registration table that enforces time-based rules for registration status changes. 

CREATE TRIGGER trigger_RegistrationStatusCheck
ON dbo.Registration
AFTER UPDATE
AS
BEGIN
    DECLARE 
        @CRN CHAR(5),
        @SemStart DATE,
        @RegDate DATE,
        @Status CHAR(1);

    SELECT 
        @CRN = inserted.CRN,
        @RegDate = inserted.regDateTime,
        @Status = inserted.[STATUS]
    FROM inserted;

    SELECT @SemStart = MIN(CT.Begin_Time_1)
    FROM Course_Timings CT
    JOIN Course_Offering CO ON CT.CRN = CO.CRN
    WHERE CO.CRN = @CRN;

    -- Ensure status changes follow allowed timeframes
-- DATEDIFF() is a SQL function that calculates the difference between 
                     --two dates in a specified unit (days, months, years, etc.).
    IF @Status = 'W' AND DATEDIFF(DAY, @SemStart, @RegDate) > 7
    BEGIN
        RAISERROR('Status change to W not allowed beyond 7 days from semester start.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    IF @Status = 'A' AND (DATEDIFF(DAY, @SemStart, @RegDate) <= 7 OR DATEDIFF(DAY, @SemStart, @RegDate) >= 21)
    BEGIN
        RAISERROR('Status change to A only allowed between 7 and 21 days from semester start.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    IF DATEDIFF(DAY, @SemStart, @RegDate) >= 21
    BEGIN
        RAISERROR('Status change is not allowed beyond 3 weeks from semester start.', 16, 1);
        ROLLBACK;
        RETURN;
    END

END;
GO

--STORED PROCEDURES

-- Stored Procedure that retrieves the roster of students enrolled in a specific course offering identifieds by its CRN.

CREATE PROCEDURE GetCourseRoster @crn char(5)
AS
SELECT
	M.[Full Name]
	, M.G_Number
	, R.regDateTime
	, R.Grade

FROM Master_Class_Roster M JOIN Registration R
	ON M.G_Number = R.Student_G_Number
WHERE R.CRN = @crn
GROUP BY
M.[Full Name], M.G_Number, R.regDateTime, R.Grade
;
GO



USE CourseRegistrationDB

GO

-- Stored Procedure to get transcript info for a given G-Number
CREATE PROCEDURE GetTranscriptByGNumber
    @GNumber CHAR(9)
AS
SELECT
    Course_Offering.Semester + ' ' + Course_Offering.SemYear,
    Course_Offering.Subject_Code + ' ' + Course_Offering.Course_Number,
    Course.Course_Name,
    Registration.Grade
FROM Registration
JOIN Course_Offering
    ON Registration.CRN = Course_Offering.CRN
JOIN Course
    ON Course_Offering.Subject_Code = Course.Subject_Code
    AND Course_Offering.Course_Number = Course.Course_Number
WHERE Registration.Student_G_Number = @GNumber;
GO