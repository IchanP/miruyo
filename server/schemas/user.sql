-- Users

CREATE TABLE users (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username text NOT NULL,
    password_hash text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    anilist_username text NOT NULL
    -- TODO Anilist user id instead?
);

CREATE UNIQUE INDEX users_username_lower_idx ON users (lower(username));

CREATE TABLE user_list (
    user_id bigint REFERENCES users,
    list_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    media_ids bigint[]
    list_name text
);

CREATE TYPE anime_format as ENUM ('TV', 'TV_SHORT', 'MOVIE', 'SPECIAL', 'OVA', 'ONA', 'MUSIC');

-- TODO think about how to match in genre and stuff later (tags?)
CREATE TABLE anilist_anime (
    id bigint PRIMARY KEY,
    title text NOT NULL,
    image_href text,
    format anime_format NOT NULL
);