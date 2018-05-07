USE DBS_Movies
GO

--------------------------------------------------------
-- Movie/Genre: Movie ID
--------------------------------------------------------
IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Movie_Genre_Movie_ID')
DROP INDEX IX_Movie_Genre_Movie_ID
ON Movie;
GO

CREATE NONCLUSTERED INDEX IX_Movie_Genre_Movie_ID
ON Movie_Genre(movie_id);
GO

--------------------------------------------------------
-- Movie: Release Year
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Movie_Release_Year')
DROP INDEX IX_Movie_Release_Year 
ON Movie;
GO

CREATE NONCLUSTERED INDEX IX_Movie_Release_Year
ON Movie(release_year);
GO

--------------------------------------------------------
-- TV Show: Release Year
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_TV_Show_Release_Year')
DROP INDEX IX_TV_Show_Release_Year
ON TV_Show;
GO

CREATE NONCLUSTERED INDEX IX_TV_Show_Release_Year
ON TV_Show(release_year);
GO

--------------------------------------------------------
-- Episode: TV Show
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Episode_Tv_Show')
DROP INDEX IX_Episode_Tv_Show 
ON Episode;
GO

CREATE NONCLUSTERED INDEX IX_Episode_Tv_Show
ON Episode(tv_show_id);
GO

--------------------------------------------------------
-- Actor: Last Name
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Actor_Last_Name')
DROP INDEX IX_Actor_Last_Name 
ON Actor;
GO

CREATE NONCLUSTERED INDEX IX_Actor_Last_Name
ON Actor(last_name);
GO

--------------------------------------------------------
-- Cinema: City
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Cinema_City')
DROP INDEX IX_Cinema_City
ON Cinema;
GO

CREATE NONCLUSTERED INDEX IX_Cinema_City
ON Cinema(city);
GO

--------------------------------------------------------
-- Genre: Name
--------------------------------------------------------

IF EXISTS (SELECT name FROM sys.indexes
WHERE name = N'IX_Genre_Name')
DROP INDEX IX_Genre_Name
ON Genre;
GO

CREATE NONCLUSTERED INDEX IX_Genre_Name
ON Genre(name);
GO
