--liquibase formatted sql

--changeset otil:movie-revision
ALTER TABLE movie DISABLE TRIGGER movie_stamp_tr;
ALTER TABLE movie ALTER revision SET DEFAULT 0;
UPDATE movie SET revision = 0;
ALTER TABLE movie ALTER revision SET NOT NULL;
ALTER TABLE movie ENABLE TRIGGER movie_stamp_tr;

--changeset otil:remove-stamp-trigger-movie
DROP TRIGGER movie_stamp_tr ON movie;
