-------------------------
-- Stored Procedure 01 --
-------------------------
GO -- Select all Genres
CREATE OR ALTER PROCEDURE
P_SELECT_Genre_AllNames
AS

SET TRANSACTION
ISOLATION LEVEL
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		SELECT name
			FROM Genre
			ORDER BY name ASC;
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 02 --
-------------------------
GO -- Select all Movies with the given Genres
CREATE OR ALTER PROCEDURE
P_SELECT_MovieXGenre_WhereMovieContainsGenre
@GenreList VARCHAR(1000)
AS

SET TRANSACTION
ISOLATION LEVEL	
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @MovieTitle VARCHAR(100)
		DECLARE @MovieID INT
		DECLARE @ParamTable TABLE(GenreName VARCHAR(100))
		DECLARE @MovieResult TABLE(MovieTitle VARCHAR(100))
		DECLARE @Success TINYINT
		DECLARE @SubGenreID INT
		INSERT INTO @ParamTable
			SELECT Genre.id 
				FROM STRING_SPLIT(@GenreList, ',') AS Alias
				JOIN Genre
					ON Genre.name = Alias.value
			
		DECLARE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres CURSOR
		FOR
		SELECT Movie.id, Movie.title
			FROM Movie
				ORDER BY Movie.title ASC

		DECLARE C_SELECT_ParamTable_FetchGivenGenreNames CURSOR 
			FOR
			SELECT GenreName FROM @ParamTable

		OPEN C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
		FETCH NEXT FROM C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
		INTO @MovieID, @MovieTitle
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Success = 1

			OPEN C_SELECT_ParamTable_FetchGivenGenreNames
			FETCH NEXT FROM C_SELECT_ParamTable_FetchGivenGenreNames
			INTO @SubGenreID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @SubGenreID NOT IN (SELECT Alias.genre_id FROM (SELECT Movie_Genre.genre_id FROM Movie_Genre WHERE Movie_Genre.movie_id = @MovieID) AS Alias)
				BEGIN
					SET @Success = 0
					BREAK
				END

				FETCH NEXT FROM C_SELECT_ParamTable_FetchGivenGenreNames
				INTO @SubGenreID
			END

			CLOSE C_SELECT_ParamTable_FetchGivenGenreNames

			IF @Success = 1
			BEGIN
				INSERT INTO @MovieResult (MovieTitle) VALUES (@MovieTitle)
			END

			FETCH NEXT FROM C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
			INTO @MovieID, @MovieTitle
		END

		SELECT * FROM @MovieResult
			ORDER BY MovieTitle ASC

		DEALLOCATE C_SELECT_ParamTable_FetchGivenGenreNames
		CLOSE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
		DEALLOCATE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
	CLOSE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
	DEALLOCATE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 03 --
-------------------------
GO -- Insert a movie with a (new) genre into Movie_Genre
CREATE OR ALTER PROCEDURE
P_INSERT_Movie_Genre_AddGenreToMovie
@MovieTitle VARCHAR(100),
@GenreName VARCHAR(100)
AS

SET TRANSACTION
ISOLATION LEVEL	
SERIALIZABLE
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @MovieID INT
		DECLARE @GenreID INT

		IF @MovieTitle NOT IN (SELECT title FROM Movie)
		BEGIN
			SELECT 'ERROR: Movie title not found.'
		END
		ELSE
		BEGIN
			SET @MovieID = (SELECT id FROM Movie WHERE title = @MovieTitle)
			SET @GenreID = (SELECT id FROM Genre WHERE name = @GenreName)

			IF @GenreID IS NULL
			BEGIN
				INSERT INTO Genre (name) VALUES (@GenreName)
				SET @GenreID = (SELECT id FROM Genre WHERE name = @GenreName)
			END
			
			IF (SELECT COUNT(*) FROM Movie_Genre WHERE movie_id = @MovieID AND genre_id = @GenreID) > 0
			BEGIN
				SELECT CONCAT('ERROR: Genre already associated to movie: ', @MovieTitle)
			END
			ELSE
			BEGIN
				INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (@MovieID, @GenreID)
				SELECT CONCAT('SUCCESS: Genre ', @GenreName, ' added to movie ', @MovieTitle, '.')
			END
		END
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 04 --
-------------------------
GO -- Select all Cinemas
CREATE OR ALTER PROCEDURE
P_SELECT_Cinemas_AllCinemaNamesAddresses
AS

SET TRANSACTION
ISOLATION LEVEL
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		SELECT *
			FROM Cinema
			ORDER BY id ASC;
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 05 --
-------------------------
GO -- Select all Movies in Cinema with their respective Actors
CREATE OR ALTER PROCEDURE
P_SELECT_MovieXMovie_Cinema_AllMoviesInCinema
@CinemaID INT
AS

SET TRANSACTION
ISOLATION LEVEL
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		SELECT Movie.title, Actor.first_name, Actor.last_name, Actor.gender
			FROM Movie
			JOIN Movie_Cinema
				ON Movie.id = Movie_Cinema.movie_id
			JOIN Movie_Actor
				ON Movie.id = Movie_Actor.movie_id
			JOIN Actor
				ON Movie_Actor.actor_id = Actor.id
			WHERE Movie_Cinema.cinema_id = @CinemaID
				AND Movie.runtime_min > '120'
				AND Movie.release_year = '2012'
			ORDER BY Movie.title ASC;
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 06 --
-------------------------
GO -- Insert TV-Show
CREATE OR ALTER PROCEDURE
P_INSERT_TV_Show_OneRow
@title VARCHAR(100),
@release_year INT,
@end_year INT,
@running TINYINT,
@number_of_seasons INT
AS

SET TRANSACTION
ISOLATION LEVEL
SERIALIZABLE
BEGIN TRY
	BEGIN TRANSACTION
		IF @title NOT IN (SELECT title FROM TV_Show)
		BEGIN
			INSERT INTO TV_Show (title, release_year, end_year, running, number_of_seasons)
			VALUES (@title, @release_year, @end_year, @running, @number_of_seasons)
			SELECT CONCAT('TV-Show ', @title, ' has successfully been added.')
		END
		ELSE
		BEGIN
			SELECT CONCAT('Error: TV-Show ', @title, ' already exists.')
		END
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	SELECT CONCAT('Error adding TV-Show ', @title, '.')
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 07 --
-------------------------
GO -- Select all currently running TV-Shows and display their first season with each episode
CREATE OR ALTER PROCEDURE
P_SELECT_VIEW_TV_Show_Episode_ListRealShowsAndEpisodes
AS

SET TRANSACTION
ISOLATION LEVEL
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		SELECT * FROM V_SELECT_TV_Show_Episode_ListRealShowsAndEpisodes
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 08 --
-------------------------
GO -- Select all real Movies and in which Cinema they are played
CREATE OR ALTER PROCEDURE
P_SELECT_VIEW_CinemaXMovie_RealMovies
AS

SET TRANSACTION
ISOLATION LEVEL
READ UNCOMMITTED
BEGIN TRY
	BEGIN TRANSACTION
		SELECT * FROM V_SELECT_CinemaXMovie_RealMovies
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION
END CATCH

-------------------------
-- Stored Procedure 09 --
-------------------------
GO -- Insert Episode
CREATE OR ALTER PROCEDURE
P_INSERT_Episode_OneRow
@TvShowTitle VARCHAR(100),
@EpisodeTitle VARCHAR(100),
@Season INT,
@Number INT
AS

SET TRANSACTION
ISOLATION LEVEL
SERIALIZABLE
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @TvShowID INT
		SET @TvShowID = (SELECT id FROM TV_Show WHERE title = @TvShowTitle)

		IF @TvShowID IS NOT NULL
		BEGIN
			IF @EpisodeTitle NOT IN (SELECT title FROM Episode WHERE tv_show_id = @TvShowID)
			BEGIN
				INSERT INTO Episode (tv_show_id, title, season, number)
				VALUES (@TvShowID, @EpisodeTitle, @Season, @Number)
				SELECT CONCAT('Episode ', @EpisodeTitle, ' has successfully been added to TV-Show ', @TvShowTitle, '.')
			END
			ELSE
			BEGIN
				SELECT CONCAT('Error: Episode ', @EpisodeTitle, ' already exists in TV-Show ', @TvShowTitle, '.')
			END
		END
		ELSE
		BEGIN
			SELECT CONCAT('Error: TV-Show ', @TvShowTitle, ' does not exist.')
		END
		
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
	SELECT 'Error: Could not add episode'
	ROLLBACK TRANSACTION
END CATCH

---------------------
-- BONUS Cursor 01 --
---------------------
--GO -- Select all Movies with the given Genres
--DECLARE @MovieTitle VARCHAR(100)
--DECLARE @GenreName VARCHAR(100)
--DECLARE @CurrentMovie VARCHAR(100)
--SET @CurrentMovie = ''
--DECLARE @GenreConcat VARCHAR(300)

--DECLARE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres CURSOR
--FOR
--SELECT Movie.title, Genre.name
--	FROM Movie
--		JOIN Movie_Genre
--		ON Movie.id = Movie_Genre.movie_id
--		JOIN Genre
--		ON Movie_Genre.genre_id = Genre.id
--		ORDER BY Movie.title ASC, Genre.name ASC

--OPEN C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
--FETCH NEXT FROM C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
--INTO @MovieTitle, @GenreName
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	IF @CurrentMovie != @MovieTitle
--	BEGIN
--		IF @CurrentMovie != ''
--		BEGIN
--			PRINT CONCAT(@CurrentMovie, ': ', @GenreConcat)
--		END
--		SET @GenreConcat = @GenreName
--	END
--	ELSE
--	BEGIN
--		SET @GenreConcat = CONCAT(@GenreConcat, ', ',@GenreName)
--	END
--	SET @CurrentMovie = @MovieTitle
--	FETCH NEXT FROM C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres
--	INTO @MovieTitle, @GenreName
--	IF @@FETCH_STATUS != 0
--	BEGIN
--		PRINT CONCAT(@CurrentMovie, ': ', @GenreConcat)
--	END
--END

--CLOSE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres

--DEALLOCATE C_SELECT_MovieXMovie_GenreXGenre_PrintAllMoviesWithTheirGenres