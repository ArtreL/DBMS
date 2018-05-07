-------------
-- View 01 --
-------------
GO -- Select all real Movies and in which Cinema they are played
CREATE OR ALTER VIEW
V_SELECT_CinemaXMovie_RealMovies
AS

SELECT TOP 500 name AS Cinema, title AS Movie_title --TOP XY necessary for 'group by' clause
FROM Cinema
	JOIN Movie_Cinema
	ON Movie_Cinema.cinema_id = Cinema.id
	JOIN Movie
	ON Movie_Cinema.movie_id = Movie.id
WHERE title NOT LIKE 'Movie Title%'
ORDER BY name ASC, title ASC

GO
SELECT * FROM V_SELECT_CinemaXMovie_RealMovies

-------------
-- View 02 --
-------------
GO -- Select all currently running TV-Shows and display their first season with each episode
CREATE OR ALTER VIEW
V_SELECT_TV_Show_Episode_ListRealShowsAndEpisodes
AS

SELECT DISTINCT TOP 200 TV_Show.title AS TV_Show, Episode.title AS Episode_Name, number --TOP XY necessary for 'group by' clause
FROM TV_Show
	JOIN Episode
	ON TV_Show.id = Episode.tv_show_id
WHERE TV_Show.title NOT LIKE 'TV Show%'
AND season = 1
AND running = 1
ORDER BY TV_Show ASC, number ASC, Episode_Name ASC

GO
SELECT * FROM V_SELECT_TV_Show_Episode_ListRealShowsAndEpisodes