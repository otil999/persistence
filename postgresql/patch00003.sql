CREATE OR REPLACE FUNCTION update_count_history() RETURNS TRIGGER AS $$
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
