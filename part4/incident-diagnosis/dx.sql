-- SELECT
--     pid,
--     usename,
--     application_name,
--     client_addr,
--     state,
--     wait_event_type,
--     wait_event,
--     query_start,
--     xact_start,
--     query
-- FROM pg_stat_activity
-- WHERE datname = current_database()
-- ORDER BY query_start;

-- Find long-running queries
SELECT
    pid,
    usename,
    state,
    now() - query_start AS query_duration,
    wait_event_type,
    wait_event,
    query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY query_start;

-- Find idle transactions
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    now() - xact_start AS transaction_age,
    state,
    query
FROM pg_stat_activity
WHERE xact_start IS NOT NULL  --WHERE state LIKE 'idle in transaction%'
ORDER BY xact_start;

-- Find blocking queries
SELECT
    blocked.pid AS blocked_pid,
    blocking.pid AS blocking_pid,
    blocked.query AS blocked_query,
    blocking.query AS blocking_query
FROM pg_stat_activity blocked
CROSS JOIN LATERAL
    unnest(pg_blocking_pids(blocked.pid)) AS bp(blocking_pid)
JOIN pg_stat_activity blocking
    ON blocking.pid = bp.blocking_pid;

-- Wait events (can be  Lock, IO, IPC, Timeout, Client, Extension, Activity, Buffer, Config, Concurrency, LWLock, Network, Scheduler, or other)
SELECT
    pid,
    state,
    wait_event_type,
    wait_event,
    query
FROM pg_stat_activity
WHERE state = 'active';

-- Check for dead tuples and table bloat
SELECT
    relname,
    n_live_tup,
    n_dead_tup,
    last_autovacuum,
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

-- application bug
--        ↓
-- long transaction
--        ↓
-- old snapshot
--        ↓
-- vacuum can't remove everything
--        ↓
-- dead tuples accumulate
--        ↓
-- table bloat
--        ↓
-- more I/O
--        ↓
-- queries get slower

-- Show max connections
SHOW max_connections;

-- Show current connections
SELECT count(*)
FROM pg_stat_activity;

-- Show connections by state(active, idle, idle in transaction, etc.)
SELECT
    state,
    count(*)
FROM pg_stat_activity
GROUP BY state;

-- Show connections by application name(eg. psql, pgAdmin, etc.)
SELECT
    application_name,
    count(*)
FROM pg_stat_activity
GROUP BY application_name
ORDER BY count(*) DESC;

SELECT
    pid,
    backend_type,
    usename,
    application_name,
    state,
    query
FROM pg_stat_activity
ORDER BY backend_type, pid;

-- WAL growth statistics
SELECT
    archived_count,
    failed_count,
    last_archived_wal,
    last_failed_wal,
    last_archived_time,
    last_failed_time
FROM pg_stat_archiver;

-- Replication lag statistics
SELECT
    pid,
    application_name,
    client_addr,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn
FROM pg_stat_replication;

-- SELECT
--     slot_name,
--     slot_type,
--     active,
--     restart_lsn,
--     confirmed_flush_lsn
-- FROM pg_replication_slots;

-- SELECT
--     slot_name,
--     pg_size_pretty(
--         pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)
--     ) AS retained_wal
-- FROM pg_replication_slots;

-- Database size statistics eg in Disk pressure
SELECT
    datname,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;

SELECT
    relname,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

--Temporary file problems
    -- Sort Method: external merge
    -- Disk Usage: ...
    -- or
    -- Hash
    -- Batches: 21


        --      APPLICATION IS SLOW
        --              │
        --              ▼
        --   Is PostgreSQL involved?
        --        /           \
        --      no             yes
        --      │               │
        -- investigate      pg_stat_activity
        -- application            │
        --                        ▼
        --              What is PostgreSQL doing?
        --                /       |       \
        --             running  waiting   idle
        --               │        │         │
        --               ▼        ▼         ▼
        --           EXPLAIN   lock?    connection
        --           ANALYZE   I/O?     pooling?
        --             │
        --             ▼
        --        bad plan?
        --       /          \
        --     yes           no
        --      │             │
        -- stats/index/    CPU/I/O/
        -- query shape     concurrency

        -- And separately:

        -- Database health
        -- │
        -- ├── connections
        -- ├── locks
        -- ├── long transactions
        -- ├── vacuum/autovacuum
        -- ├── WAL
        -- ├── disk
        -- ├── replication
        -- ├── query performance
        -- └── backups

--                         USER REPORTS:
--                  "APP IS SLOW"
--                        │
--                        ▼
--              ┌───────────────────┐
--              │ IS POSTGRES       │
--              │ INVOLVED?         │
--              └─────────┬─────────┘
--                        │ YES
--                        ▼
--               TAKE A DB SNAPSHOT
--                        │
--                        ▼
--                 pg_stat_activity
--                        │
--        ┌───────────────┼────────────────┐
--        │               │                │
--        ▼               ▼                ▼
--  CONNECTIONS        ACTIVE          TRANSACTIONS
--        │               │                │
--        ▼               ▼                ▼
--  exhaustion?       running?          long?
--  pooling?          waiting?          idle xact?
--        │               │                │
--        │         ┌─────┴─────┐          │
--        │         ▼           ▼          │
--        │       LOCK/I/O    EXECUTING    │
--        │         │           │          │
--        │         ▼           ▼          │
--        │      diagnose     EXPLAIN       │
--        │                     │           │
--        │                     ▼           │
--        │              plan / stats /     │
--        │              indexes / SQL      │
--        │                                 │
--        └──────────────┬──────────────────┘
--                       ▼
--                 DB HEALTH CHECK
--                       │
--              ┌────────┼─────────┐
--              ▼        ▼         ▼
--           VACUUM     WAL    REPLICATION
--              │        │         │
--              └────────┼─────────┘
--                       ▼
--                     DISK
--                       │
--                       ▼
--               FORM ROOT CAUSE
--                       │
--                       ▼
--                   MITIGATE
--                       │
--                       ▼
--                    VERIFY