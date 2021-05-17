--liquibase formatted sql

--changeset otil:jpa compliant trigger endDelimiter:/
CREATE OR REPLACE FUNCTION movie_stamp() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF OLD.deleted IS NOT NULL THEN
      RAISE EXCEPTION 'Incorrect state, record % is already deleted.', quote_ident(text(OLD.id));
    ELSE
      NEW.updated = now();
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO movie (
        id, name, original_name, counter, rating, release, link, media_id, media_number, series_id, series_num,
        genre_id, created, updated, deleted, revision, storage_id)
      VALUES (
          -1 * OLD.id, '#' || OLD.id || '#' || OLD.name, OLD.original_name, OLD.counter, OLD.rating, OLD.release,
          OLD.link, OLD.media_id, OLD.media_number, OLD.series_id, OLD.series_num, OLD.genre_id, OLD.created,
          OLD.updated, now(), OLD.revision, OLD.storage_id);
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
/

--changeset otil:applying the jpa compliant trigger
DROP TRIGGER movie_stamp_tr ON movie;

CREATE TRIGGER movie_stamp_tr BEFORE UPDATE OR DELETE
ON movie
  FOR EACH ROW
  EXECUTE PROCEDURE movie_stamp();
