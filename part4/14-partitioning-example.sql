DROP TABLE IF EXISTS events CASCADE;

CREATE TABLE events (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    event_type TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE events_2026_09
PARTITION OF events
FOR VALUES FROM ('2026-09-01')
             TO ('2026-10-01');

CREATE TABLE events_2026_10
PARTITION OF events
FOR VALUES FROM ('2026-10-01')
             TO ('2026-11-01');

CREATE TABLE events_2026_11
PARTITION OF events
FOR VALUES FROM ('2026-11-01')
             TO ('2026-12-01');

INSERT INTO events (user_id, event_type, created_at)
VALUES
    (1, 'login',  '2026-09-10'),
    (2, 'upload', '2026-10-05'),
    (3, 'login',  '2026-10-20'),
    (4, 'logout', '2026-11-02');

SELECT tableoid::regclass, *
FROM events
ORDER BY created_at;


--     tableoid    | id | user_id | event_type |       created_at       
-- ----------------+----+---------+------------+------------------------
--  events_2026_09 |  1 |       1 | login      | 2026-09-10 00:00:00+00
--  events_2026_10 |  2 |       2 | upload     | 2026-10-05 00:00:00+00
--  events_2026_10 |  3 |       3 | login      | 2026-10-20 00:00:00+00
--  events_2026_11 |  4 |       4 | logout     | 2026-11-02 00:00:00+00
-- (4 rows)

--partition pruning.
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM events
WHERE created_at >= '2026-10-01'
  AND created_at < '2026-11-01';