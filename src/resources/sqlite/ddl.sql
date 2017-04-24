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
    genre_id      INTEGER,
    timestamp     TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (series_id) REFERENCES series(id),
    FOREIGN KEY (genre_id) REFERENCES genre(id)
);
