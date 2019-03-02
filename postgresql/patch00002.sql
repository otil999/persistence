-- DROP TABLE count_history;
CREATE TABLE IF NOT EXISTS count_history (
  date              DATE NOT NULL UNIQUE DEFAULT CURRENT_DATE,
  active_movies     INTEGER NOT NULL DEFAULT 0,
  deleted_movies    INTEGER NOT NULL DEFAULT 0,
  active_games      INTEGER NOT NULL DEFAULT 0,
  deleted_games     INTEGER NOT NULL DEFAULT 0,
  active_tv_series  INTEGER NOT NULL DEFAULT 0,
  deleted_tv_series INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX ON count_history (date);

CREATE OR REPLACE FUNCTION update_count_history() RETURNS TRIGGER AS $$
DECLARE
  field_name TEXT;
  count_select TEXT;
BEGIN
  IF tg_op = 'UPDATE' OR tg_op = 'INSERT' THEN
    IF tg_table_name = 'movie' THEN
      field_name = 'active_movies';
      count_select = 'SELECT count(*) FROM movie WHERE deleted IS NULL';
    ELSIF tg_table_name = 'game' THEN
      field_name = 'active_games';
      count_select = 'SELECT count(*) FROM game WHERE deleted IS NULL';
    ELSIF tg_table_name = 'tv_series' THEN
      field_name = 'active_tv_series';
      count_select = 'SELECT count(*) FROM tv_series WHERE deleted IS NULL';
    END IF;
  ELSIF tg_op = 'DELETE' THEN
    IF tg_table_name = 'movie' THEN
      field_name = 'deleted_movies';
      count_select = 'SELECT count(*) FROM movie WHERE deleted IS NOT NULL';
    ELSIF tg_table_name = 'game' THEN
      field_name = 'deleted_games';
      count_select = 'SELECT count(*) FROM game WHERE deleted IS NOT NULL';
    ELSIF tg_table_name = 'tv_series' THEN
      field_name = 'deleted_tv_series';
      count_select = 'SELECT count(*) FROM tv_series WHERE deleted IS NOT NULL';
    END IF;
  END IF;

  EXECUTE 'INSERT INTO count_history AS ch (' || field_name || ') ' || count_select ||
          '  ON CONFLICT (date) DO UPDATE SET ' || field_name || ' = (' || count_select || ')' ||
          '  WHERE ch.date = CURRENT_DATE';

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER game_count_history_tr ON game;
CREATE TRIGGER game_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON game
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();

-- DROP TRIGGER movie_count_history_tr ON movie;
CREATE TRIGGER movie_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON movie
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();

-- DROP TRIGGER tv_series_count_history_tr ON tv_series;
CREATE TRIGGER tv_series_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON tv_series
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();
