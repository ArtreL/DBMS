SELECT 
      database_name = DB_NAME(database_id)
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files 
WHERE database_id = DB_ID() -- for current db 
GROUP BY database_id

SELECT COUNT(*) AS Actor FROM Actor;
SELECT COUNT(*) AS Cinema FROM Cinema;
SELECT COUNT(*) AS Episode FROM Episode;
SELECT COUNT(*) AS Genre FROM Genre;
SELECT COUNT(*) AS Movie FROM Movie;
SELECT COUNT(*) AS Movie_Actor FROM Movie_Actor;
SELECT COUNT(*) AS Movie_Cinema FROM Movie_Cinema;
SELECT COUNT(*) AS Movie_Genre FROM Movie_Genre;
SELECT COUNT(*) AS TV_Show FROM TV_Show;
