-- media
DROP TABLE media;
CREATE TABLE IF NOT EXISTS media (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TRIGGER media_after_tr;
CREATE TRIGGER media_after_tr AFTER UPDATE ON media WHEN NEW.timestamp == OLD.timestamp
BEGIN
	UPDATE media SET timestamp = datetime('now', 'localtime') WHERE id = NEW.id;
END;

-- series
DROP TABLE series;
CREATE TABLE IF NOT EXISTS series (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TRIGGER series_after_tr;
CREATE TRIGGER series_after_tr AFTER UPDATE ON series WHEN NEW.timestamp == OLD.timestamp
BEGIN
	UPDATE series SET timestamp = datetime('now', 'localtime') WHERE id = NEW.id;
END;

-- genre
DROP TABLE genre;
CREATE TABLE IF NOT EXISTS genre (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

DROP TRIGGER genre_after_tr;
CREATE TRIGGER genre_after_tr AFTER UPDATE ON genre WHEN NEW.timestamp == OLD.timestamp
BEGIN
	UPDATE genre SET timestamp = datetime('now', 'localtime') WHERE id = NEW.id;
END;

-- movie
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

DROP TRIGGER movie_after_tr;
CREATE TRIGGER movie_after_tr AFTER UPDATE ON movie WHEN NEW.timestamp == OLD.timestamp
BEGIN
	UPDATE movie SET timestamp = datetime('now', 'localtime') WHERE id = NEW.id;
END;

-- game
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

DROP TRIGGER game_after_tr;
CREATE TRIGGER game_after_tr AFTER UPDATE ON game WHEN NEW.timestamp == OLD.timestamp
BEGIN
	UPDATE game SET timestamp = datetime('now', 'localtime') WHERE id = NEW.id;
END;

-- views for random selections
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
