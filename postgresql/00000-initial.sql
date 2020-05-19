--liquibase formatted sql

--changeset otil:initial structure endDelimiter:/
CREATE OR REPLACE FUNCTION stamp() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF OLD.deleted IS NOT NULL THEN
      RAISE EXCEPTION 'Incorrect state, record % is already deleted.', quote_ident(text(OLD.id));
    ELSE
      NEW.updated = now();
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.deleted IS NOT NULL THEN
      RETURN OLD;
    ELSE
      EXECUTE 'UPDATE ' || tg_table_name ||
              ' SET name = ' || quote_literal('#' || OLD.id || '#' || OLD.name) || ', deleted = now()' ||
              ' WHERE id = ' || OLD.id;
      RETURN NULL;
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE base (
  created  TIMESTAMP NOT NULL DEFAULT now(),
  updated  TIMESTAMP,
  deleted  TIMESTAMP,
  revision INTEGER
);

CREATE TABLE media (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

CREATE TRIGGER media_stamp_tr BEFORE UPDATE OR DELETE
  ON media
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE TABLE series (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

CREATE TRIGGER series_stamp_tr BEFORE UPDATE OR DELETE
  ON series
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE TABLE IF NOT EXISTS genre (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

CREATE TRIGGER genre_stamp_tr BEFORE UPDATE OR DELETE
  ON genre
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE TABLE movie (
  id            BIGSERIAL PRIMARY KEY,
  name          TEXT UNIQUE NOT NULL,
  original_name TEXT,
  counter       SMALLINT DEFAULT 0,
  rating        REAL DEFAULT 0.0,
  release       SMALLINT,
  link          TEXT,
  media_id      INTEGER NOT NULL,
  media_number  INTEGER,
  series_id     INTEGER,
  series_num    INTEGER DEFAULT 1,
  genre_id      INTEGER,
  FOREIGN KEY (media_id) REFERENCES media(id),
  FOREIGN KEY (series_id) REFERENCES series(id),
  FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON movie (original_name);
CREATE INDEX ON movie (counter);

CREATE TRIGGER movie_stamp_tr BEFORE UPDATE OR DELETE
  ON movie
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE TABLE IF NOT EXISTS game (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT UNIQUE NOT NULL,
  counter     SMALLINT DEFAULT 0,
  rating      SMALLINT DEFAULT 0,
  release     SMALLINT,
  link        TEXT,
  media_id    INTEGER NOT NULL,
  series_id   INTEGER,
  series_num  INTEGER DEFAULT 1,
  genre_id    INTEGER,
  long_term   BOOLEAN,
  description TEXT,
  FOREIGN KEY (media_id) REFERENCES media(id),
  FOREIGN KEY (series_id) REFERENCES series(id),
  FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON game (counter);
CREATE INDEX ON game (long_term);

CREATE TRIGGER game_stamp_tr BEFORE UPDATE OR DELETE
  ON game
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE TABLE IF NOT EXISTS tv_series (
  id            BIGSERIAL PRIMARY KEY,
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
  FOREIGN KEY (media_id) REFERENCES media(id),
  FOREIGN KEY (series_id) REFERENCES series(id),
  FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON tv_series (original_name);
CREATE INDEX ON tv_series (counter);

CREATE TRIGGER tv_series_stamp_tr BEFORE UPDATE OR DELETE
  ON tv_series
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

CREATE OR REPLACE VIEW random_game AS
  SELECT game.id, series.name AS series, game.name, counter
    FROM game LEFT JOIN series ON (game.series_id = series.id)
    WHERE counter = (SELECT min(counter) FROM game)
    LIMIT 1
    OFFSET (SELECT floor(random() * count(*))
              FROM game
              WHERE counter = (SELECT min(counter) FROM game));

CREATE OR REPLACE VIEW random_movie AS
  SELECT movie.id, series.name AS series, movie.name, counter
    FROM movie LEFT JOIN series ON (movie.series_id = series.id)
    WHERE counter = (SELECT min(counter) FROM movie)
    LIMIT 1
    OFFSET (SELECT floor(random() * count(*))
              FROM movie
              WHERE counter = (SELECT min(counter) FROM movie));

CREATE OR REPLACE VIEW random_tv_series AS
  SELECT tv_series.id, series.name AS series, tv_series.name, counter
    FROM tv_series LEFT JOIN series ON (tv_series.series_id = series.id)
    WHERE counter = (SELECT min(counter) FROM tv_series)
    LIMIT 1
    OFFSET (SELECT floor(random() * count(*))
              FROM tv_series
              WHERE counter = (SELECT min(counter) FROM tv_series));
