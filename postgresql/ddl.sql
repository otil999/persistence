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

CREATE TABLE IF NOT EXISTS base (
  created TIMESTAMP NOT NULL DEFAULT now(),
  updated TIMESTAMP,
  deleted TIMESTAMP
);

-- media
-- DROP TABLE media;
CREATE TABLE IF NOT EXISTS media (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

-- DROP TRIGGER media_stamp_tr ON media;
CREATE TRIGGER media_stamp_tr BEFORE UPDATE OR DELETE
  ON media
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- series
-- DROP TABLE series;
CREATE TABLE IF NOT EXISTS series (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

-- DROP TRIGGER series_stamp_tr ON series;
CREATE TRIGGER series_stamp_tr BEFORE UPDATE OR DELETE
  ON series
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- genre
-- DROP TABLE genre;
CREATE TABLE IF NOT EXISTS genre (
  id   BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  LIKE base INCLUDING ALL
);

-- DROP TRIGGER genre_stamp_tr ON genre;
CREATE TRIGGER genre_stamp_tr BEFORE UPDATE OR DELETE
  ON genre
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- movie
-- DROP TABLE movie;
CREATE TABLE IF NOT EXISTS movie (
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
--   FOREIGN KEY (media_id) REFERENCES media(id),
--   FOREIGN KEY (series_id) REFERENCES series(id),
--   FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON movie (original_name);
CREATE INDEX ON movie (counter);
CREATE INDEX ON movie (media_id);
CREATE INDEX ON movie (series_id);
CREATE INDEX ON movie (genre_id);

-- DROP TRIGGER movie_stamp_tr ON movie;
CREATE TRIGGER movie_stamp_tr BEFORE UPDATE OR DELETE
  ON movie
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- game
-- DROP TABLE game;
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
--   FOREIGN KEY (media_id) REFERENCES media(id),
--   FOREIGN KEY (series_id) REFERENCES series(id),
--   FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON game (counter);
CREATE INDEX ON game (long_term);
CREATE INDEX ON game (media_id);
CREATE INDEX ON game (series_id);
CREATE INDEX ON game (genre_id);

-- DROP TRIGGER game_stamp_tr ON game;
CREATE TRIGGER game_stamp_tr BEFORE UPDATE OR DELETE
  ON game
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- tv_series
-- DROP TABLE tv_series;
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
--   FOREIGN KEY (media_id) REFERENCES media(id),
--   FOREIGN KEY (series_id) REFERENCES series(id),
--   FOREIGN KEY (genre_id) REFERENCES genre(id),
  LIKE base INCLUDING ALL
);

CREATE INDEX ON tv_series (original_name);
CREATE INDEX ON tv_series (counter);
CREATE INDEX ON tv_series (media_id);
CREATE INDEX ON tv_series (series_id);
CREATE INDEX ON tv_series (genre_id);

-- DROP TRIGGER tv_series_stamp_tr ON tv_series;
CREATE TRIGGER tv_series_stamp_tr BEFORE UPDATE OR DELETE
  ON tv_series
  FOR EACH ROW
  EXECUTE PROCEDURE stamp();

-- views for random selections
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
