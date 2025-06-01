USE  CourseRegistrationDB
GO

-- 1
BULK INSERT [Classrooms]
FROM 'C:\\path\\to\\your\\Classrooms.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Buildings]
FROM 'C:\\path\\to\\your\\Buildings.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Course]
FROM 'C:\\path\\to\\your\\Course.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Course_Offering]
FROM 'C:\\path\\to\\your\\Course_Offering.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Course_Timings]
FROM 'C:\\path\\to\\your\\Course_Timings.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Department]
FROM 'C:\\path\\to\\your\\Department.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '0x0a' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Faculty]
FROM 'C:\\path\\to\\your\\Faculty.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Faculty_Appointment]
FROM 'C:\\path\\to\\your\\Faculty_Appointment.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Registration]
FROM 'C:\\path\\to\\your\\Registration.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '0x0a' -- one of two different new line characters
        , FORMAT = 'CSV')
;

BULK INSERT [Student]
FROM 'C:\\path\\to\\your\\Student.csv' -- full path to file name
WITH (  FIRSTROW = 2  -- Skip the header row
        --, LASTROW = 5 -- optional if you want to limit number of records
        , ROWTERMINATOR = '\n' -- one of two different new line characters
        , FORMAT = 'CSV')
;



