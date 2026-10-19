SELECT
    attname,
    n_distinct,
    most_common_vals,
    most_common_freqs,
    histogram_bounds,
    correlation
FROM pg_stats
WHERE tablename = 'posts';

EXPLAIN
SELECT *
FROM posts
WHERE status = 'published';

ANALYZE posts;

EXPLAIN
SELECT *
FROM posts
WHERE status = 'published';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE status = 'published';

-- if an api is slow:

-- bad query
-- bad index
-- missing index
-- wrong index
-- bad cardinality estimate
-- stale statistics
-- lock contention
-- long transaction
-- I/O pressure
-- connection exhaustion