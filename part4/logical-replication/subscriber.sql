CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL
);

CREATE SUBSCRIPTION app_subscription
CONNECTION 'host=publisher port=5432 dbname=source_db user=postgres password=postgres'
PUBLICATION app_publication;