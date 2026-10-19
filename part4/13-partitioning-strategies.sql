-- RANGE
-- LIST
-- HASH

--RANGE -> Excellent for time-series data
CREATE TABLE events (
    id BIGINT,
    created_at TIMESTAMPTZ NOT NULL,
    event_type TEXT
) PARTITION BY RANGE (created_at);

CREATE TABLE events_2026_10
PARTITION OF events
FOR VALUES FROM ('2026-10-01')
             TO ('2026-11-01');

CREATE TABLE events_2026_11
PARTITION OF events
FOR VALUES FROM ('2026-11-01')
             TO ('2026-12-01');

--LIST -> Excellent for discrete values
CREATE TABLE users (
    id BIGINT,
    country TEXT
) PARTITION BY LIST (country);

CREATE TABLE users_ke
PARTITION OF users
FOR VALUES IN ('KE');

---HASH -> Excellent for evenly distributing data(hashes the partition key and distributes rows)
CREATE TABLE users (
    id BIGINT,
    email TEXT
) PARTITION BY HASH (id);

CREATE TABLE users_0
PARTITION OF users
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE users_1
PARTITION OF users
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE users_2
PARTITION OF users
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE users_3
PARTITION OF users
FOR VALUES WITH (MODULUS 4, REMAINDER 3);