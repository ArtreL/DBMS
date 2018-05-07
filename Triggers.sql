USE DBS_Movies
GO

--------------------------------------------------------
-- Check if release year is after end year for TV Shows
--------------------------------------------------------
DROP TRIGGER IF EXISTS T_INSERT_TV_Shows
GO

CREATE TRIGGER T_INSERT_TV_Shows ON TV_Show
FOR INSERT
AS
	DECLARE @releaseYear INT;
	DECLARE @endYear INT;

	SELECT @releaseYear = i.release_year FROM INSERTED i;	
	SELECT @endYear = i.end_year FROM INSERTED i;

	IF @releaseYear > @endYear
		BEGIN
			RAISERROR ('The release year cannot be after the end year!', 10, 1)
			SELECT 'The release year cannot be after the end year!'
			ROLLBACK
		END
GO

--------------------------------------------------------
-- Update number_of_seasons of TV-Show when inserted season does not yet exist
--------------------------------------------------------
DROP TRIGGER IF EXISTS T_INSERT_Episode_AddNewSeason
GO

CREATE TRIGGER T_INSERT_Episode_AddNewSeason ON Episode
FOR INSERT
AS
	DECLARE @EpisodeSeason INT
	DECLARE @TvShowSeason INT

	SELECT @EpisodeSeason = i.season FROM INSERTED i
	SET @TvShowSeason = 
		(SELECT number_of_seasons 
			FROM TV_Show
			WHERE id = (SELECT i.tv_show_id FROM INSERTED i))

	IF @EpisodeSeason > @TvShowSeason
	BEGIN
		UPDATE TV_Show 
			SET number_of_seasons = @EpisodeSeason
			WHERE id = (SELECT i.tv_show_id FROM INSERTED i)
		SELECT 'Updated Number of Seasons of TV-Show'
	END
GO

--------------------------------------------------------
-- Actors always stay actors even if they die
--------------------------------------------------------

DROP TRIGGER IF EXISTS T_DELETE_Actor
GO

CREATE TRIGGER T_DELETE_Actor ON Actor
FOR DELETE
AS
	RAISERROR ('Once an actor, always an actor!', 10, 1)
	ROLLBACK
GO

--------------------------------------------------------
-- A movie will always exist even if it's shitty
--------------------------------------------------------

DROP TRIGGER IF EXISTS T_DELETE_Movie
GO

CREATE TRIGGER T_DELETE_Movie ON Movie
FOR DELETE
AS
	RAISERROR ('Once a movie, always a movie!', 10, 1)
	ROLLBACK
GO

--------------------------------------------------------
-- A TV Show will always exist even if it's shitty
--------------------------------------------------------

DROP TRIGGER IF EXISTS T_DELETE_TV_Show
GO

CREATE TRIGGER T_DELETE_TV_Show ON TV_Show
FOR DELETE
AS
	RAISERROR ('Once a TV Show, always a TV Show!', 10, 1)
	ROLLBACK
GO