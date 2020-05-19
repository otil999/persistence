--liquibase formatted sql

--changeset otil:count-history
CREATE TABLE count_history (
  date              DATE NOT NULL UNIQUE DEFAULT CURRENT_DATE,
  active_movies     INTEGER NOT NULL DEFAULT 0,
  deleted_movies    INTEGER NOT NULL DEFAULT 0,
  active_games      INTEGER NOT NULL DEFAULT 0,
  deleted_games     INTEGER NOT NULL DEFAULT 0,
  active_tv_series  INTEGER NOT NULL DEFAULT 0,
  deleted_tv_series INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX ON count_history (date);
--rollback DROP TABLE count_history;

--changeset otil:count-history-func endDelimiter:/
CREATE FUNCTION update_count_history() RETURNS TRIGGER AS $$
BEGIN
  EXECUTE 'INSERT INTO count_history AS ch' ||
          '  (active_movies, active_games, active_tv_series, deleted_movies, deleted_games, deleted_tv_series) ' ||
          '  VALUES (' ||
          '    (SELECT count(*) FROM movie WHERE deleted IS NULL),' ||
          '    (SELECT count(*) FROM game WHERE deleted IS NULL),' ||
          '    (SELECT count(*) FROM tv_series WHERE deleted IS NULL),' ||
          '    (SELECT count(*) FROM movie WHERE deleted IS NOT NULL),' ||
          '    (SELECT count(*) FROM game WHERE deleted IS NOT NULL),' ||
          '    (SELECT count(*) FROM tv_series WHERE deleted IS NOT NULL))' ||
          '  ON CONFLICT (date) DO UPDATE SET ' ||
          '    active_movies = (SELECT count(*) FROM movie WHERE deleted IS NULL),' ||
          '    active_games = (SELECT count(*) FROM game WHERE deleted IS NULL),' ||
          '    active_tv_series = (SELECT count(*) FROM tv_series WHERE deleted IS NULL),' ||
          '    deleted_movies = (SELECT count(*) FROM movie WHERE deleted IS NOT NULL),' ||
          '    deleted_games = (SELECT count(*) FROM game WHERE deleted IS NOT NULL),' ||
          '    deleted_tv_series = (SELECT count(*) FROM tv_series WHERE deleted IS NOT NULL)' ||
          '  WHERE ch.date = CURRENT_DATE';

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/
--rollback DROP FUNCTION update_count_history;

--changeset otil:game-count-history-trigger
CREATE TRIGGER game_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON game
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();
--rollback DROP TRIGGER game_count_history_tr ON game;

--changeset otil:movie-count-history-trigger
CREATE TRIGGER movie_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON movie
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();
--rollback DROP TRIGGER movie_count_history_tr ON movie;

--changeset otil:tv_series-count-history-trigger
CREATE TRIGGER tv_series_count_history_tr AFTER INSERT OR UPDATE OR DELETE
  ON tv_series
  FOR EACH ROW
  EXECUTE PROCEDURE update_count_history();
--rollback DROP TRIGGER tv_series_count_history_tr ON tv_series;
