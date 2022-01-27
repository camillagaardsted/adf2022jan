CREATE TABLE [dbo].[Date]
(
    [DateID] int NOT NULL,
    [Date] datetime NULL,
    [DateBKey] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DaySuffix] varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeek] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfQuarter] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfYear] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfMonth] varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Month] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Quarter] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [QuarterName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Year] char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [YearName] char(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthYear] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MMYYYY] char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FirstDayOfMonth] date NULL,
    [LastDayOfMonth] date NULL,
    [FirstDayOfQuarter] date NULL,
    [LastDayOfQuarter] date NULL,
    [FirstDayOfYear] date NULL,
    [LastDayOfYear] date NULL,
    [IsHolidayUSA] bit NULL,
    [IsWeekday] bit NULL,
    [HolidayUSA] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);



-- load data 
COPY INTO [dbo].[Date]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Date'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Date] - Taxi dataset');



-- Vi skal AD bruger og have ret til at oprette logins og users 


CREATE LOGIN adf20220126 FROM EXTERNAL PROVIDER

CREATE LOGIN [BI GROUP] FROM EXTERNAL PROVIDER

SELECT      * 
FROM        sys.server_principals

CREATE LOGIN Ottosql WITH PASSWORD ='Pa55w.rd'

USE dwpool

CREATE USER [BI GROUP] FROM EXTERNAL PROVIDER


SELECT *
FROM sys.database_principals

CREATE TABLE dbo.Covid19Positive
(
    Dato DATE
    , NyeSmittede INT
    , PositivPct DECIMAL(9,2)
)

-- NB ALTER ROLE ADD MEMBER fungerer ikke på synapse - de bruger stadig de gamle stored proc
EXEC sp_addrolemember 'db_datareader', 'adf20220126'
EXEC sp_addrolemember 'db_datawriter', 'adf20220126'
EXEC sp_addrolemember 'db_ddladmin', 'adf20220126'

GRANT ADMINISTER DATABASE BULK OPERATIONS TO adf20220126


SELECT  * FROM dbo.Covid19Positive


CREATE TABLE dbo.Membership  
  (MemberID int ,  
   FirstName varchar(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL,  
   LastName varchar(100) NOT NULL,  
   Phone varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,  
   Email varchar(100) MASKED WITH (FUNCTION = 'email()') NULL,
   Salary INT MASKED WITH (FUNCTION = 'default()') NULL,  
   cprnr varchar(10) MASKED WITH (FUNCTION = 'partial(6,"-XXXX",0)') NULL  
)

INSERT Membership (MemberId,FirstName, LastName, Phone, Email, Salary,cprnr) VALUES   
(1,'Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com',35000,'0112801234'),  
(2,'Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co',25000,'0112801234'),  
(3,'Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net',35000,'0112801234');  

INSERT Membership (MemberId,FirstName, LastName, Phone, Email, Salary,cprnr) VALUES   
(2,'Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co',25000,'0112801234')

INSERT Membership (MemberId,FirstName, LastName, Phone, Email, Salary,cprnr) VALUES
(3,'Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net',35000,'0112801234')

SELECT * FROM Membership;  

CREATE USER OttoNysgerrig WITHOUT LOGIN

GRANT SELECT ON dbo.Membership to OttoNysgerrig

EXECUTE AS USER = 'OttoNysgerrig'
    SELECT * FROM Membership;  
REVERT


EXECUTE AS USER = 'OttoNysgerrig'
    SELECT * FROM Membership
    WHERE salary = 35000 
REVERT

GRANT UNMASK TO OttoNysgerrig























