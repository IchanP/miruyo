-- migrate:up

-- Users

CREATE TABLE users (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username text NOT NULL,
    password_hash text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    anilist_username text NOT NULL,
    anilist_id bigint NOT NULL UNIQUE
);

CREATE UNIQUE INDEX users_username_lower_idx ON users (lower(username));

CREATE TYPE media_format as ENUM ('TV', 'TV_SHORT', 'MOVIE', 'SPECIAL', 'OVA', 'ONA', 'MUSIC', 'MANGA', 'NOVEL', 'ONE_SHOT');
CREATE TYPE media_type as ENUM ('MANGA', 'ANIME');

-- TODO think about how to match in genre and stuff later (tags?)
CREATE TABLE anilist_media (
    id bigint PRIMARY KEY,
    en_title text,
    romaji_title text NOT NULL, -- Anilist can deliver nulled romaji_titles, this needs to be handled in code
    native_title text,
    image_href text,
    format media_format,
    media_type media_type NOT NULL,
    fetched_at timestamptz NOT NULL DEFAULT now()
);

CREATE TYPE watch_status as ENUM ('CURRENT', 'PLANNING', 'COMPLETED', 'DROPPED', 'PAUSED', 'REPEATING');

CREATE TABLE user_media (
    user_id bigint REFERENCES users ON DELETE CASCADE,
    media_id bigint REFERENCES anilist_media ON DELETE RESTRICT,
    watch_status watch_status NOT NULL,
    PRIMARY KEY (user_id, media_id)
);

-- migrate:down

DROP TABLE user_media;
DROP TABLE anilist_media;
DROP TABLE users;

DROP TYPE watch_status, media_format, media_type;