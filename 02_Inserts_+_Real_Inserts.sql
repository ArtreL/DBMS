USE DBS_Movies;

BEGIN -- CREATING REAL NAMES (60 forenames, 40 surnames)

DROP TABLE IF EXISTS vornamen;
DROP TABLE IF EXISTS nachnamen;
CREATE TABLE vornamen (
	name VARCHAR(50), 
	gender VARCHAR(1)
);
CREATE TABLE nachnamen (
	name VARCHAR(50)
);
INSERT INTO vornamen (name, gender) VALUES ('Aubrey','w');
INSERT INTO vornamen (name, gender) VALUES ('Scarlett','w');
INSERT INTO vornamen (name, gender) VALUES ('Zoey','w');
INSERT INTO vornamen (name, gender) VALUES ('Addison','w');
INSERT INTO vornamen (name, gender) VALUES ('Lily','w');
INSERT INTO vornamen (name, gender) VALUES ('Lillian','w');
INSERT INTO vornamen (name, gender) VALUES ('Natalie','w');
INSERT INTO vornamen (name, gender) VALUES ('Hannah','w');
INSERT INTO vornamen (name, gender) VALUES ('Aria','w');
INSERT INTO vornamen (name, gender) VALUES ('Layla','w');
INSERT INTO vornamen (name, gender) VALUES ('Brooklyn','w');
INSERT INTO vornamen (name, gender) VALUES ('Alexa','w');
INSERT INTO vornamen (name, gender) VALUES ('Zoe','w');
INSERT INTO vornamen (name, gender) VALUES ('Penelope','w');
INSERT INTO vornamen (name, gender) VALUES ('Riley','w');
INSERT INTO vornamen (name, gender) VALUES ('Leah','w');
INSERT INTO vornamen (name, gender) VALUES ('Audrey','w');
INSERT INTO vornamen (name, gender) VALUES ('Savannah','w');
INSERT INTO vornamen (name, gender) VALUES ('Allison','w');
INSERT INTO vornamen (name, gender) VALUES ('Samantha','w');
INSERT INTO vornamen (name, gender) VALUES ('Nora','w');
INSERT INTO vornamen (name, gender) VALUES ('Skylar','w'); 
INSERT INTO vornamen (name, gender) VALUES ('Camila','w');
INSERT INTO vornamen (name, gender) VALUES ('Anna','w');
INSERT INTO vornamen (name, gender) VALUES ('Paisley','w');
INSERT INTO vornamen (name, gender) VALUES ('Ariana','w');
INSERT INTO vornamen (name, gender) VALUES ('Ellie','w');
INSERT INTO vornamen (name, gender) VALUES ('Aaliyah','w');
INSERT INTO vornamen (name, gender) VALUES ('Claire','w');
INSERT INTO vornamen (name, gender) VALUES ('Violet','w');
INSERT INTO vornamen (name, gender) VALUES ('Noah','m');
INSERT INTO vornamen (name, gender) VALUES ('Liam','m');
INSERT INTO vornamen (name, gender) VALUES ('Mason','m');
INSERT INTO vornamen (name, gender) VALUES ('Jacob','m');
INSERT INTO vornamen (name, gender) VALUES ('William','m');
INSERT INTO vornamen (name, gender) VALUES ('Ethan','m');
INSERT INTO vornamen (name, gender) VALUES ('James','m');
INSERT INTO vornamen (name, gender) VALUES ('Alexander','m');
INSERT INTO vornamen (name, gender) VALUES ('Michael','m');
INSERT INTO vornamen (name, gender) VALUES ('Benjamin','m');
INSERT INTO vornamen (name, gender) VALUES ('Elijah','m');
INSERT INTO vornamen (name, gender) VALUES ('Daniel','m');
INSERT INTO vornamen (name, gender) VALUES ('Aiden','m');
INSERT INTO vornamen (name, gender) VALUES ('Logan','m');
INSERT INTO vornamen (name, gender) VALUES ('Matthew','m');
INSERT INTO vornamen (name, gender) VALUES ('Lucas','m');
INSERT INTO vornamen (name, gender) VALUES ('Jackson','m');
INSERT INTO vornamen (name, gender) VALUES ('David','m');
INSERT INTO vornamen (name, gender) VALUES ('Oliver','m');
INSERT INTO vornamen (name, gender) VALUES ('Jayden','m');
INSERT INTO vornamen (name, gender) VALUES ('Joseph','m');
INSERT INTO vornamen (name, gender) VALUES ('Gabriel','m');
INSERT INTO vornamen (name, gender) VALUES ('Samuel','m');
INSERT INTO vornamen (name, gender) VALUES ('Carter','m');
INSERT INTO vornamen (name, gender) VALUES ('Anthony','m');
INSERT INTO vornamen (name, gender) VALUES ('John','m');
INSERT INTO vornamen (name, gender) VALUES ('Dylan','m');
INSERT INTO vornamen (name, gender) VALUES ('Luke','m');
INSERT INTO vornamen (name, gender) VALUES ('Henry','m');
INSERT INTO vornamen (name, gender) VALUES ('Andrew','m');


INSERT INTO nachnamen (name) VALUES ('Smith');
INSERT INTO nachnamen (name) VALUES ('Jones');
INSERT INTO nachnamen (name) VALUES ('Williams');
INSERT INTO nachnamen (name) VALUES ('Taylor');
INSERT INTO nachnamen (name) VALUES ('Brown');
INSERT INTO nachnamen (name) VALUES ('Davies');
INSERT INTO nachnamen (name) VALUES ('Evans');
INSERT INTO nachnamen (name) VALUES ('Wilson');
INSERT INTO nachnamen (name) VALUES ('Thomas');
INSERT INTO nachnamen (name) VALUES ('Johnson');
INSERT INTO nachnamen (name) VALUES ('Roberts');
INSERT INTO nachnamen (name) VALUES ('Robinson');
INSERT INTO nachnamen (name) VALUES ('Thompson');
INSERT INTO nachnamen (name) VALUES ('Wright');
INSERT INTO nachnamen (name) VALUES ('Walker');
INSERT INTO nachnamen (name) VALUES ('White');
INSERT INTO nachnamen (name) VALUES ('Edwards');
INSERT INTO nachnamen (name) VALUES ('Hughes');
INSERT INTO nachnamen (name) VALUES ('Green');
INSERT INTO nachnamen (name) VALUES ('Hall');
INSERT INTO nachnamen (name) VALUES ('Lewis');
INSERT INTO nachnamen (name) VALUES ('Harris');
INSERT INTO nachnamen (name) VALUES ('Clarke');
INSERT INTO nachnamen (name) VALUES ('Patel');
INSERT INTO nachnamen (name) VALUES ('Jackson');
INSERT INTO nachnamen (name) VALUES ('Wood');
INSERT INTO nachnamen (name) VALUES ('Turner');
INSERT INTO nachnamen (name) VALUES ('Martin');
INSERT INTO nachnamen (name) VALUES ('Cooper');
INSERT INTO nachnamen (name) VALUES ('Hill');
INSERT INTO nachnamen (name) VALUES ('Ward');
INSERT INTO nachnamen (name) VALUES ('Morris');
INSERT INTO nachnamen (name) VALUES ('Moore');
INSERT INTO nachnamen (name) VALUES ('Clark');
INSERT INTO nachnamen (name) VALUES ('Lee');
INSERT INTO nachnamen (name) VALUES ('King');
INSERT INTO nachnamen (name) VALUES ('Baker');
INSERT INTO nachnamen (name) VALUES ('Harrison');
INSERT INTO nachnamen (name) VALUES ('Morgan');
INSERT INTO nachnamen (name) VALUES ('Allen');
-- CREATING REAL NAMES END
END

BEGIN -- INSERTING INTO Actor
	DECLARE @forename VARCHAR(255)
	DECLARE @lastname VARCHAR(255)
	DECLARE @gender VARCHAR 
	DECLARE @year INT

	DECLARE @GetForenames_C CURSOR
	SET @GetForenames_C = CURSOR FOR 
		SELECT name, gender
		FROM vornamen;
	DECLARE @GetLastnames_C CURSOR
	SET @GetLastnames_C = CURSOR FOR 
		SELECT name
		FROM nachnamen;
	
	OPEN @GetLastnames_C;
	FETCH NEXT FROM @GetLastnames_C INTO @lastname

	WHILE @@FETCH_STATUS = 0
	BEGIN
		OPEN @GetForenames_C;
		FETCH NEXT FROM @GetForenames_C INTO @forename, @gender
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @year = 1970 + RAND() * 30
			INSERT INTO Actor (first_name, last_name, gender, birth_year) 
				VALUES(@forename, @lastname, @gender, @year);
			FETCH NEXT FROM @GetForenames_C INTO @forename, @gender
		END
		FETCH NEXT FROM @GetLastnames_C INTO @lastname
		CLOSE @GetForenames_C;
	END

	CLOSE @GetLastnames_C;
	DEALLOCATE @GetForenames_C;
	DEALLOCATE @GetLastnames_C;
END -- END OF ACTOR INSERTION

BEGIN -- INSERTING INTO Cinema
INSERT INTO Cinema (name, city, street) VALUES 
	('Haydn Kino', 'Wien', 'Mariahilfer Straße 57'),
	('Village Cinema Wien Mitte', 'Wien', 'Landstraßer Hauptstraße 2A'),
	('Artis International', 'Wien', 'Schultergasse 5'),
	('Apollo Kino', 'Stockerau', 'Bahnhofstraße 5'),
	('CINEPLEXX Donau Plex', 'Wien', 'Donau Zentrum'),
	('Hollywood Megaplex SCN', 'Wien', 'Guglgasse 11'),
	('UCI KINOWELT Millennium City', 'Wien', 'Am Handelskai');
END -- END OF Cinema INSERTION

BEGIN -- INSERTING INTO Genre
INSERT INTO Genre (name) VALUES	
	('Abenteuerfilm'),
	('Antikfilm'),
	('Piratenfilm'),
	('Ritterfilm'),
	('Sandalenfilm'),
	('Actionfilm'),
	('Katastrophenfilm'),
	('Actionkomödie'),
	('Lederhosenfilm'),
	('Fantasyfilm'),
	('Filmbiografie'),
	('Filmkomödie'),
	('Culture-Clash-Komödie'),
	('Filmparodie'),
	('Horrorfilm'),
	('Horrorkomödie'),
	('Monsterfilm'),
	('Slasher-Film'),
	('Splatterfilm'),
	('Tierhorrorfilm'),
	('Vampirfilm'),
	('Zombiefilm'),
	('Kriegsfilm'),
	('Kriminalfilm'),
	('Detektivfilm'),
	('Film noir'),
	('Gangsterfilm'),
	('Gefängnisfilm'),
	('Gerichtsfilm'),
	('Heist-Movie'),
	('Kriminalkomödie'),
	('Polizeifilm'),
	('Serial-Killer-Film'),
	('Spionagefilm'),
	('Liebesfilm'),
	('Martial-Arts-Film'),
	('Musikfilm'),
	('Roadmovie'),
	('Science-Fiction-Film'),
	('Sportfilm'),
	('Thriller'),
	('Western');
END -- END OF Genre INSERTION

BEGIN -- INSERTING INTO Movie
	INSERT INTO Movie(title, release_year, runtime_min)
	VALUES
		('Werner - Beinhart!', 1990, 99),
		('Werner - Eiskalt!', 2011, 99),
		('Werner - Gekotzt wird später', 2003, 99),
		('Werner - Das muss kesseln!!!', 1996, 99),
		('Werner - Volles Rooäää!!!', 1999, 99),
		('Are We There Yet?', 2005, 99),
		('Bachelor Mother', 1939, 99),
		('Four Rooms', 1995, 99),
		('Ghostbusters II', 1989, 99),
		('The Gold Rush', 1925, 99),
		('The Hudsucker Proxy', 1994, 99),
		('Party Party', 1983, 99),
		('Radio Days', 1987, 99),
		('Trading Places', 1983, 99),
		('Assault on Precinct 13', 2005, 99),
		('200 Cigarettes', 1999, 99),
		('About a Boy', 2002, 99),
		('Bridge and Tunnel', 2014, 99),
		('Diner', 1982, 99),
		('A Long Way Down', 2014, 99),
		('Mermaids', 1990, 99),
		('More American Graffiti', 1979, 99),
		('New Years Day', 1989, 99),
		('Peters Friends', 1992, 99),
		('Sweet Hearts Dance', 1988, 99),
		('After the Thin Man', 1936, 99),
		('Better Luck Tomorrow', 2002, 99),
		('Dhoom', 2004, 99),
		('Entrapment', 1999, 99),
		('The Godfather Part II', 1974, 99),
		('Little Caesar', 1931, 99),
		('Money Train', 1995, 99),
		('Oceans 11', 1960, 99),
		('The Poseidon Adventure', 1972, 99),
		('Beyond the Poseidon Adventure', 1979, 99),
		('Poseidon', 2006, 99),
		('54', 1998, 99),
		('Boogie Nights', 1997, 99),
		('Cavalcade', 1933, 99),
		('The Divorcee', 1930, 99),
		('Fruitvale Station', 2013, 99),
		('Ill Be Seeing You', 1944, 99),
		('Looking for Mr. Goodbar', 1977, 99),
		('Middle of the Night', 1959, 99),
		('My Reputation', 1946, 99),
		('The New Year', 2010, 99),
		('The Passionate Friends', 1949, 99),
		('Penny Serenade', 1941, 99),
		('Pollock', 2000, 99),
		('Il Posto', 1961, 99),
		('Splendor in the Grass', 1961, 99),
		('Til We Meet Again', 1940, 99),
		('Two Lovers', 2008, 99),
		('Antisocial', 2013, 99),
		('The Children', 2008, 99),
		('Day Watch', 2006, 99),
		('End of Days', 1999, 99),
		('Ghostkeeper', 1981, 99),
		('Holidays', 2016, 99),
		('The Mephisto Waltz', 1971, 99),
		('Mystery of the Wax Museum', 1933, 99),
		('New Years Evil', 1980, 99),
		('The Phantom Carriage', 1921, 99),
		('Rosemarys Baby', 1968, 99),
		('Terror Train', 1980, 99),
		('Bundle of Joy', 1956, 99),
		('Carnival Night', 1956, 99),
		('Get Crazy', 1983, 99),
		('Holiday Inn', 1942, 99),
		('New Year Adventures of Masha and Vitya', 1975, 99),
		('Rent', 2005, 99),
		('An Affair to Remember', 1957, 99),
		('The Apartment', 1960, 99),
		('Baby Cakes', 1989, 99),
		('Come Look at Me', 2001, 99),
		('Bridget Joness Diary', 2001, 99),
		('Holiday', 1938, 99),
		('In Search of a Midnight Kiss', 2008, 99),
		('The Irony of Fate', 1976, 99),
		('The Irony of Fate 2', 2007, 99),
		('New Years Eve', 2011, 99),
		('Remember the Night', 1940, 99),
		('Sex and the City: The Movie', 2008, 99),
		('Sleepless in Seattle', 1993, 99),
		('Someone Like You', 2001, 99),
		('Untamed Heart', 1993, 99),
		('Doctor Who', 1996, 99),
		('Snowpiercer', 2013, 99),
		('Strange Days', 1995, 99),
		('The Time Machine', 1960, 99),
		('The End of Evangelion', 1997, 99),
		('Bitter Moon', 1992, 99),
		('Night Train to Paris', 1964, 99),
		('Survivor', 2015, 99),
		('Taboo', 2002, 99),
		('Under Suspicion', 2000, 99);
END -- END OF Movie INSERTION

BEGIN -- INSERTING INTO Movie
	DECLARE @j INT
	SET @j = 0
	DECLARE @stop INT 
	SET @stop = 200000
	DECLARE @length INT
	DECLARE @rel_year INT
	DECLARE @rand FLOAT

	WHILE (@j < @stop)
	BEGIN
		SET @rand = RAND();
		SET @length = 40 + (@rand * 100) + 1;
		SET @rel_year = 1970 + @rand * 48;
		INSERT INTO Movie (title, runtime_min, release_year, director) 
			VALUES ('Movie Title ' + CAST(@j AS VARCHAR), @length, @rel_year,'Director ' + CAST(@j AS VARCHAR));
		SET @j = @j + 1
	END
END -- END OF Movie INSERTION

BEGIN -- INSERTING INTO TV_Show
	INSERT INTO TV_Show(title, release_year, end_year, number_of_seasons, running)
	VALUES ('Breaking Bad', 2008, 2013, 5, 0),
	('The Walking Dead', 2010, null, 9, 1),
	('Hey Dad!', 1986, 1994, 10, 0),
	('Offsprng', 2010, 2012, 3, 0),
	('Outland', 2012, 2012, 1, 0),
	('Pizza', 2000, 2007, 7, 0),
	('Black Mirror', 2011, null, 4, 1),
	('The River', 2012, 2012, 3, 0),
	('Hannibal', 2013, 2015, 3, 0),
	('Mindhunter', 2017, null, 1, 1),
	('Outcast', 2016, null, 1, 1);
END -- END OF TV_Show INSERTION

BEGIN -- INSERTING INTO TV_Show
	DECLARE @k INT
	SET @k = 0
	DECLARE @ende INT 
	SET @ende = 200000
	DECLARE @released_year INT
	DECLARE @end_year INT
	DECLARE @running BIT
	DECLARE @noOfSeasons INT
	DECLARE @random FLOAT

	WHILE (@k < @ende)
	BEGIN
		SET @random = RAND();
		SET @released_year = 1970 + @random * 48;
		SET @end_year = @released_year + @random * 5;
		IF @end_year > 2017 
			SET @end_year = NULL;
		IF RAND() > 0.5
			SET @running = 1;
		ELSE
			SET @running = 0;
		SET @noOfSeasons = (1-@random) * 5 + 1;

		INSERT INTO TV_Show(title, release_year, end_year, running, number_of_seasons) 
			VALUES ('TV Show ' + CAST(@k AS VARCHAR), @released_year, @end_year, @running, @noOfSeasons);
		SET @k = @k + 1
	END
END -- END OF TV_Show INSERTION

BEGIN -- INSERTING INTO Episode
	DECLARE @rndm FLOAT;
	DECLARE @episodes INT;
	DECLARE @episodeindex INT;
	DECLARE @seasonindex INT;

	DECLARE @GetTVShows_C CURSOR
	SET @GetTVShows_C = CURSOR FOR 
		SELECT id, end_year, number_of_seasons
		FROM TV_Show;
	DECLARE @TVId INT;
	DECLARE @EndYear INT;
	DECLARE @NumOfSeasons INT;

	OPEN @GetTVShows_C
	FETCH NEXT
	FROM @GetTVShows_C INTO @TVId, @EndYear, @NumOfSeasons

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @seasonindex = 1;
		WHILE @seasonindex <= @NumOfSeasons
		BEGIN
			SET @rndm = RAND();
			SET @episodes = 5 + @rndm * 15;

			SET @episodeindex = 1;
			WHILE @episodeindex <= @episodes
			BEGIN
				INSERT INTO Episode (tv_show_id, title, season, number)
					VALUES(@TVId, 'Episode ' + CAST(@episodeindex AS VARCHAR) + ' - A Title', @seasonindex, @episodeindex);
				SET @episodeindex = @episodeindex + 1;
			END

			SET @seasonindex = @seasonindex + 1;
		END
		
		FETCH NEXT
		FROM @GetTVShows_C INTO @TVId, @EndYear, @NumOfSeasons
	END

	CLOSE @GetTVShows_C;
	DEALLOCATE @GetTVShows_C;
END -- END OF Episode INSERTION

BEGIN -- INSERTING INTO Movie_Actor
	TRUNCATE TABLE Movie_Actor;

	DECLARE @GetMovies_C CURSOR
	SET @GetMovies_C = CURSOR FOR 
		SELECT id
		FROM Movie;
	DECLARE @GetActor_C CURSOR
	SET @GetActor_C = CURSOR FOR 
		SELECT id FROM actor
		ORDER BY id DESC;
	DECLARE @MovId INT;
	DECLARE @ActId INT;
	DECLARE @loopIndex INT;
	
	OPEN @GetMovies_C
	FETCH NEXT
	FROM @GetMovies_C INTO @MovId
	OPEN @GetActor_C
	FETCH NEXT
	FROM @GetActor_C INTO @ActId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @loopIndex = 0;
		WHILE @loopIndex < 3
		BEGIN
			FETCH NEXT
			FROM @GetActor_C INTO @ActId
			
			IF @@FETCH_STATUS != 0
			BEGIN
				CLOSE @GetActor_C
				OPEN @GetActor_C
				FETCH NEXT
				FROM @GetActor_C INTO @ActId
			END

			INSERT INTO Movie_Actor (movie_id, actor_id) 
				VALUES(@MovId, @ActId);

			SET @loopIndex = @loopIndex + 1;
		END

		FETCH NEXT 
		FROM @GetMovies_C INTO @MovId
	END
	
	CLOSE @GetMovies_C;
	DEALLOCATE @GetMovies_C;
	CLOSE @GetActor_C;
	DEALLOCATE @GetActor_C;
END -- END OF Movie_Actor INSERTION

BEGIN -- INSERTING INTO Movie_Cinema
	TRUNCATE TABLE Movie_Cinema;

	DECLARE @GetMovie_C CURSOR
	SET @GetMovie_C = CURSOR FOR 
		SELECT id
		FROM Movie;
	DECLARE @GetCinema_C CURSOR
	SET @GetCinema_C = CURSOR FOR 
		SELECT id FROM Cinema
		ORDER BY id DESC;
	DECLARE @MovieId INT;
	DECLARE @CinemaId INT;
	DECLARE @loopIt INT;
	
	OPEN @GetMovie_C
	FETCH NEXT
	FROM @GetMovie_C INTO @MovieId
	OPEN @GetCinema_C
	FETCH NEXT
	FROM @GetCinema_C INTO @CinemaId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @loopIt = 0;
		WHILE @loopIt < 3
		BEGIN
			FETCH NEXT
			FROM @GetCinema_C INTO @CinemaId
			IF @@FETCH_STATUS != 0
			BEGIN
				CLOSE @GetCinema_C
				OPEN @GetCinema_C
				FETCH NEXT
				FROM @GetCinema_C INTO @CinemaId
			END

			INSERT INTO Movie_Cinema (movie_id, cinema_id) 
				VALUES(@MovieId, @CinemaId);

			SET @loopIt = @loopIt + 1;
		END

		FETCH NEXT
		FROM @GetMovie_C INTO @MovieId
	END
	
	CLOSE @GetMovie_C;
	DEALLOCATE @GetMovie_C;
	CLOSE @GetCinema_C;
	DEALLOCATE @GetCinema_C;
END -- END OF Movie_Cinema INSERTION

BEGIN -- INSERTING INTO Movie_Genre
	TRUNCATE TABLE Movie_Genre;

	DECLARE @GetAllMovies_C CURSOR
	SET @GetAllMovies_C = CURSOR FOR 
		SELECT id FROM Movie;
	DECLARE @GetGenre_C CURSOR
	SET @GetGenre_C = CURSOR FOR 
		SELECT id FROM Genre
		ORDER BY id DESC;
	DECLARE @mId INT;
	DECLARE @GenreId INT;
	DECLARE @lIndex INT;
	
	OPEN @GetAllMovies_C
	FETCH NEXT
	FROM @GetAllMovies_C INTO @mId
	OPEN @GetGenre_C
	FETCH NEXT
	FROM @GetGenre_C INTO @GenreId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @lIndex = 0;
		WHILE @lIndex < 3
		BEGIN
			FETCH NEXT
			FROM @GetGenre_C INTO @GenreId
			IF @@FETCH_STATUS != 0
			BEGIN
				CLOSE @GetGenre_C
				OPEN @GetGenre_C
				FETCH NEXT
				FROM @GetGenre_C INTO @GenreId
			END

			INSERT INTO Movie_Genre (movie_id, genre_id) 
				VALUES(@mId, @GenreId);

			SET @lIndex = @lIndex + 1;
		END

		FETCH NEXT
		FROM @GetAllMovies_C INTO @mId
	END
	
	CLOSE @GetAllMovies_C;
	DEALLOCATE @GetAllMovies_C;
	CLOSE @GetGenre_C;
	DEALLOCATE @GetGenre_C;
END -- END OF Movie_Genre INSERTION

-- DROPPING CREATED NAMES
DROP TABLE nachnamen;
DROP TABLE vornamen;