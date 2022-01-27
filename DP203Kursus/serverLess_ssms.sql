

    SELECT
        TOP 100 *
    FROM
        OPENROWSET(
            BULK 'https://datalake20220124.dfs.core.windows.net/bidata/1984/data2022_01_24_10_57_50.csv',
            FORMAT = 'CSV',
            HEADER_ROW = TRUE,
            PARSER_VERSION = '2.0'
        ) AS [result]



SELECT		*
FROM		sys.database_principals

