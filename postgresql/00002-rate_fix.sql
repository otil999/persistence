--liquibase formatted sql

--changeset otil:make-rating-columns-real
ALTER TABLE game ALTER COLUMN rating TYPE real;
ALTER TABLE tv_series ALTER COLUMN rating TYPE real;
