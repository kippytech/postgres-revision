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

INSERT INTO users VALUES
    (1, 'Ananya', 'ananya@example.com'),
    (2, 'Rahul', 'rahul@example.com');

INSERT INTO posts VALUES
    (1, 1, 'Learning PostgreSQL'),
    (2, 2, 'Logical Replication');

CREATE PUBLICATION app_publication
FOR TABLE users, posts;

-- SELECT
--     slot_name,
--     slot_type,
--     active,
--     restart_lsn
-- FROM pg_replication_slots;

-- SELECT
--     pid,
--     application_name,
--     client_addr,
--     state,
--     sync_state,
--     sent_lsn,
--     write_lsn,
--     flush_lsn,
--     replay_lsn
-- FROM pg_stat_replication;

-- SELECT *
-- FROM pg_stat_subscription;

-- current/replay_lsn = 0/198A048
-- restart_lsn        = 0/1989FF8
-- SELECT pg_wal_lsn_diff(
--     '0/198A048',
--     '0/1989FF8'
-- );

-- SELECT
--     slot_name,
--     active,
--     pg_size_pretty(
--         pg_wal_lsn_diff(
--             pg_current_wal_lsn(),
--             restart_lsn
--         )
--     ) AS retained_wal
-- FROM pg_replication_slots;