

CREATE EXTERNAL DATA SOURCE WWIStorage
WITH
(
    TYPE = Hadoop,
    LOCATION = 'wasbs://wideworldimporters@sqldwholdata.blob.core.windows.net'
);


CREATE EXTERNAL FILE FORMAT TextFileFormat
WITH
(
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (
        FIELD_TERMINATOR = '|',
        USE_TYPE_DEFAULT = FALSE
    )
);

CREATE SCHEMA ext;
GO
CREATE SCHEMA wwi;

CREATE EXTERNAL TABLE [ext].[dimension_City](
    [City Key] [int] NOT NULL,
    [WWI City ID] [int] NOT NULL,
    [City] [nvarchar](50) NOT NULL,
    [State Province] [nvarchar](50) NOT NULL,
    [Country] [nvarchar](60) NOT NULL,
    [Continent] [nvarchar](30) NOT NULL,
    [Sales Territory] [nvarchar](50) NOT NULL,
    [Region] [nvarchar](30) NOT NULL,
    [Subregion] [nvarchar](30) NOT NULL,
    [Location] [nvarchar](76) NULL,
    [Latest Recorded Population] [bigint] NOT NULL,
    [Valid From] [datetime2](7) NOT NULL,
    [Valid To] [datetime2](7) NOT NULL,
    [Lineage Key] [int] NOT NULL
)
WITH (LOCATION='/v1/dimension_City/',
    DATA_SOURCE = WWIStorage,  
    FILE_FORMAT = TextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);  

CREATE EXTERNAL TABLE [ext].[dimension_Customer] (
    [Customer Key] [int] NOT NULL,
    [WWI Customer ID] [int] NOT NULL,
    [Customer] [nvarchar](100) NOT NULL,
    [Bill To Customer] [nvarchar](100) NOT NULL,
       [Category] [nvarchar](50) NOT NULL,
    [Buying Group] [nvarchar](50) NOT NULL,
    [Primary Contact] [nvarchar](50) NOT NULL,
    [Postal Code] [nvarchar](10) NOT NULL,
    [Valid From] [datetime2](7) NOT NULL,
    [Valid To] [datetime2](7) NOT NULL,
    [Lineage Key] [int] NOT NULL
)
WITH (LOCATION='/v1/dimension_Customer/',
    DATA_SOURCE = WWIStorage,  
    FILE_FORMAT = TextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);  
CREATE EXTERNAL TABLE [ext].[dimension_Employee] (
    [Employee Key] [int] NOT NULL,
    [WWI Employee ID] [int] NOT NULL,
    [Employee] [nvarchar](50) NOT NULL,
    [Preferred Name] [nvarchar](50) NOT NULL,
    [Is Salesperson] [bit] NOT NULL,
    [Photo] [varbinary](300) NULL,
    [Valid From] [datetime2](7) NOT NULL,
    [Valid To] [datetime2](7) NOT NULL,
    [Lineage Key] [int] NOT NULL
)
WITH ( LOCATION='/v1/dimension_Employee/',
    DATA_SOURCE = WWIStorage,  
    FILE_FORMAT = TextFileFormat,
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);



-- load data 

CREATE TABLE [wwi].[dimension_City]
WITH
(
    DISTRIBUTION = REPLICATE, -- Distribution findes for tabeller i dedicated pool
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [ext].[dimension_City]
OPTION (LABEL = 'CTAS : Load [wwi].[dimension_City]')
;

SELECT		TOP 100 *
FROM [ext].[dimension_City]

SELECT		TOP 100 *
FROM [wwi].[dimension_City]


-- Vil lave en pipeline i Azure Data Factory som kopierer en zip fil fra https://files.ssi.dk/covid19/overvagning/data/overvaagningsdata-covid19-25012022-f7tr
-- til en container i vores datalake og sørger for at filen er unzipped


-- Vi vil lave transformation af en af csv filerne fra ssi
-- via power query (findes kun ADF og IKKE i synapse)
-- Power Query kan ikke alt det i M som vi plejer 


-- vi står i ADF - hvordan får vi data ind i synapse? sikkerhedsmodellen
-- best practise
-- vi anvender managed identity for adf i Azure AD

-- Synapse - i modul 8 nævnes de specifikt for Synapse - men det findes også onpremise og for Azure SQL Database

-- kryptering

-- TDE - Transparent Data Encryption
-- files at rest beskyttelse - 
-- on prem - ikke slået til default - det kræver vi selv holder styr på nøgler til kryptering
-- i Azure - er det slået til default 


-- Data masking 


CREATE TABLE dbo.Membership  
  (MemberID int IDENTITY PRIMARY KEY,  
   FirstName varchar(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL,  
   LastName varchar(100) NOT NULL,  
   Phone varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,  
   Email varchar(100) MASKED WITH (FUNCTION = 'email()') NULL,
   Salary INT MASKED WITH (FUNCTION = 'default()') NULL,  
   cprnr varchar(10) MASKED WITH (FUNCTION = 'partial(6,"-XXXX",0)') NULL  
)

INSERT Membership (FirstName, LastName, Phone, Email, Salary) VALUES   
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com',35000),  
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co',25000),  
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net',35000);  

SELECT * FROM Membership;  

CREATE USER OttoNysgerrig WITHOUT LOGIN










