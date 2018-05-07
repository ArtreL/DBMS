--CREATE DATABASE DBS_Movies;

USE DBS_Movies;

DROP TABLE IF EXISTS Movie_Genre;
DROP TABLE IF EXISTS Movie_Actor;
DROP TABLE IF EXISTS Movie_Cinema;

DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Episode;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Cinema;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS TV_Show;

CREATE TABLE Movie (
	id INT PRIMARY KEY IDENTITY(1,1),
	title VARCHAR(70) NOT NULL UNIQUE,
	runtime_min INT NOT NULL,
	release_year INT NOT NULL,
	director VARCHAR(70)
);

CREATE TABLE TV_Show (
	id INT PRIMARY KEY IDENTITY(1,1),
	title VARCHAR(70) NOT NULL UNIQUE,
	release_year INT NOT NULL,
	end_year INT,
	running BIT NOT NULL,
	number_of_seasons INT NOT NULL
);

CREATE TABLE Episode (
	id INT PRIMARY KEY IDENTITY(1,1),
	tv_show_id INT NOT NULL FOREIGN KEY REFERENCES TV_Show (id),
	title VARCHAR(70) NOT NULL,
	season INT NOT NULL,
	number INT NOT NULL,
	CONSTRAINT show_title_season UNIQUE (tv_show_id, title, season)
);

CREATE TABLE Actor (
	id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	birth_year INT,
	gender VARCHAR(1) NOT NULL
);

CREATE TABLE Cinema (
	id INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	street VARCHAR(100) NOT NULL
);

CREATE TABLE Genre (
	id INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(30) NOT NULL
);

CREATE TABLE Movie_Genre (
	movie_id INT NOT NULL FOREIGN KEY REFERENCES Movie (id),
	genre_id INT NOT NULL FOREIGN KEY REFERENCES Genre (id),
	CONSTRAINT movie_genre_id UNIQUE (movie_id, genre_id)
);

CREATE TABLE Movie_Actor (
	movie_id INT NOT NULL FOREIGN KEY REFERENCES Movie (id),
	actor_id INT NOT NULL FOREIGN KEY REFERENCES Actor (id),
	CONSTRAINT movie_actor_id UNIQUE (movie_id, actor_id)
);

CREATE TABLE Movie_Cinema (
	movie_id INT NOT NULL FOREIGN KEY REFERENCES Movie (id),
	cinema_id INT NOT NULL FOREIGN KEY REFERENCES Cinema (id),
	CONSTRAINT movie_cinema_id UNIQUE (movie_id, cinema_id)
);
