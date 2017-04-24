CREATE ROLE catalog LOGIN PASSWORD 'catalog';

CREATE SCHEMA private;
CREATE SCHEMA common;
CREATE SCHEMA game;
CREATE SCHEMA film;

DROP TABLE private.base;
CREATE TABLE private.base (
    create_user INTEGER,
    modify_user INTEGER,
    delete_user INTEGER,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modify_time TIMESTAMP,
    delete_time TIMESTAMP
);

DROP TABLE private.element;
CREATE TABLE private.element (
    name    TEXT,
    counter SMALLINT DEFAULT 0,
    rating  SMALLINT DEFAULT 0,
    release SMALLINT,
    link    TEXT,
    LIKE private.base INCLUDING DEFAULTS
);

DROP TABLE common.user;
CREATE TABLE common.user (
	user_id    BIGSERIAL PRIMARY KEY,
	login_name TEXT      UNIQUE NOT NULL,
	full_name  TEXT,
	password   TEXT      NOT NULL,
	LIKE private.base INCLUDING DEFAULTS
);

DROP TABLE common.media;
CREATE TABLE common.media (
    media_id BIGSERIAL PRIMARY KEY,
    name     TEXT      UNIQUE NOT NULL,
    LIKE private.base INCLUDING DEFAULTS
);
ALTER TABLE common.media ADD CONSTRAINT media_create_user_user_user_id_key FOREIGN KEY (create_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE common.media ADD CONSTRAINT media_modify_user_user_user_id_key FOREIGN KEY (modify_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE common.media ADD CONSTRAINT media_delete_user_user_user_id_key FOREIGN KEY (delete_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;

DROP TABLE game.series;
CREATE TABLE game.series (
    series_id BIGSERIAL PRIMARY KEY,
    name      TEXT      UNIQUE NOT NULL,
    LIKE private.base INCLUDING DEFAULTS
);
ALTER TABLE game.series ADD CONSTRAINT series_cuser_user_user_id_key FOREIGN KEY (create_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE game.series ADD CONSTRAINT series_muser_user_user_id_key FOREIGN KEY (modify_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE game.series ADD CONSTRAINT series_duser_user_user_id_key FOREIGN KEY (delete_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;

DROP TABLE game.element;
CREATE TABLE game.element (
    element_id BIGSERIAL PRIMARY KEY,
    media_id   BIGINT    REFERENCES common.media ON UPDATE CASCADE ON DELETE RESTRICT,
    series_id  BIGINT    REFERENCES game.series ON UPDATE CASCADE ON DELETE RESTRICT,
	long_term  BOOLEAN   NOT NULL DEFAULT FALSE,
    LIKE private.element INCLUDING DEFAULTS
);
ALTER TABLE game.element ADD CONSTRAINT element_name_key UNIQUE (name);
ALTER TABLE game.element ADD CONSTRAINT element_cuser_user_user_id_key FOREIGN KEY (create_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE game.element ADD CONSTRAINT element_muser_user_user_id_key FOREIGN KEY (modify_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
ALTER TABLE game.element ADD CONSTRAINT element_duser_user_user_id_key FOREIGN KEY (delete_user) REFERENCES common.user(user_id) ON UPDATE CASCADE;
