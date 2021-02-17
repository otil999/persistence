--liquibase formatted sql

--changeset otil:storage
CREATE TABLE storage_type (
    id   SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    LIKE base INCLUDING ALL
);

CREATE TABLE storage (
    id              SERIAL PRIMARY KEY,
    name            TEXT,
    storage_type_id INTEGER NOT NULL REFERENCES storage_type(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (storage_type_id, name),
    LIKE base INCLUDING ALL
);

ALTER TABLE movie ADD COLUMN storage_id INTEGER REFERENCES storage(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE game ADD COLUMN storage_id INTEGER REFERENCES storage(id) ON UPDATE CASCADE ON DELETE RESTRICT;

DROP TABLE media_labels;
DROP TABLE movie_media;
DROP TABLE game_media;

INSERT INTO storage_type (id, name) VALUES (1, 'CD');
INSERT INTO storage_type (id, name) VALUES (2, 'DVD');
INSERT INTO storage_type (id, name) VALUES (3, 'HDD');
INSERT INTO storage_type (id, name) VALUES (4, 'Pendrive');
INSERT INTO storage_type (id, name) VALUES (5, 'Cloud');
INSERT INTO storage_type (id, name) VALUES (6, 'Streaming');

INSERT INTO storage (name, storage_type_id) VALUES ('Steam', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('GOG', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('Origin', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('UPlay', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('Humble Bundle', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('Epic Game Store', 5);
INSERT INTO storage (name, storage_type_id) VALUES ('Netflix', 6);

CREATE TABLE movie_storage (
    movie_id   BIGINT NOT NULL REFERENCES movie(id),
    storage_id INTEGER NOT NULL REFERENCES storage(id),
    LIKE base INCLUDING ALL
);

CREATE TABLE game_storage (
    game_id BIGINT NOT NULL REFERENCES game(id),
    storage_id INTEGER NOT NULL REFERENCES storage(id),
    LIKE base INCLUDING ALL
);
