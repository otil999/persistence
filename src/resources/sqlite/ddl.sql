DROP TABLE media;
CREATE TABLE IF NOT EXISTS media (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TABLE series;
CREATE TABLE IF NOT EXISTS series (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TABLE genre;
CREATE TABLE IF NOT EXISTS genre (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TABLE movie;
CREATE TABLE IF NOT EXISTS movie (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT UNIQUE NOT NULL,
    original_name TEXT,
    counter       SMALLINT DEFAULT 0,
    rating        SMALLINT DEFAULT 0,
    release       SMALLINT,
    link          TEXT,
    media_id      INTEGER NOT NULL,
    media_number  INTEGER,
    series_id     INTEGER,
    series_num    INTEGER DEFAULT 1,
    genre_id      INTEGER,
    timestamp     TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (series_id) REFERENCES series(id),
    FOREIGN KEY (genre_id) REFERENCES genre(id)
);

DROP TABLE game; 
CREATE TABLE IF NOT EXISTS game (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT UNIQUE NOT NULL,
    counter       SMALLINT DEFAULT 0,
    rating        SMALLINT DEFAULT 0,
    release       SMALLINT,
    link          TEXT,
    media_id      INTEGER NOT NULL,
    series_id     INTEGER,
    series_num    INTEGER DEFAULT 1,
    genre_id      INTEGER,
    timestamp     TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    long_term     INTEGER NOT NULL DEFAULT 0,
    description   TEXT,
    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (series_id) REFERENCES series(id),
    FOREIGN KEY (genre_id) REFERENCES genre(id)
);

CREATE VIEW random_game AS
	SELECT game.id, series.name, game.name, counter
	FROM game LEFT JOIN series ON (game.series_id = series.id)
	WHERE counter = (SELECT min(counter) FROM game)
	LIMIT 1
	OFFSET (SELECT abs(random()) % count(*)
	        FROM game
	        WHERE counter = (SELECT min(counter) FROM game));

CREATE VIEW random_movie AS
	SELECT movie.id, series.name, movie.name, counter
	FROM movie LEFT JOIN series ON (movie.series_id = series.id)
	WHERE counter = (SELECT min(counter) FROM movie)
	LIMIT 1
	OFFSET (SELECT abs(random()) % count(*)
	        FROM movie
	        WHERE counter = (SELECT min(counter) FROM movie));
