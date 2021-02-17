--liquibase formatted sql

--changeset otil:media-labels
CREATE TABLE media_labels (
    media_id BIGINT NOT NULL,
    label    TEXT   NOT NULL
);

--changeset otil:media-for-assets
CREATE TABLE movie_media (
    movie_id BIGINT NOT NULL REFERENCES movie(id),
    media_id BIGINT NOT NULL REFERENCES media(id)
);

CREATE TABLE game_media (
    game_id BIGINT NOT NULL REFERENCES game(id),
    media_id BIGINT NOT NULL REFERENCES media(id)
);
