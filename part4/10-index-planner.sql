INSERT INTO posts (user_id, title, status, views)
SELECT
    (SELECT id FROM users WHERE name = 'Ananya'),
    'Generated post ' || g,
    CASE
        WHEN g % 10 = 0 THEN 'published'
        ELSE 'draft'
    END,
    g
FROM generate_series(1, 100000) AS g;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE status = 'published';

-- "There are quite a lot of matching rows. An ordinary Index Scan would require lots of individual table-row fetches. I'll use the index to identify all matching locations, organize those locations into a bitmap, then fetch the relevant table pages."
-- Bitmap Heap Scan on posts
--   Recheck Cond: (status = 'published')
--   Heap Blocks: exact=1137
--   Buffers: shared hit=1146

--   -> Bitmap Index Scan on idx_posts_status
--        Index Cond: (status = 'published')
--        Buffers: shared hit=9

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE id = (
    SELECT id
    FROM posts
    LIMIT 1
);

-- Index Scan using posts_pkey on posts  (cost=0.75..8.77 rows=1 width=100) (actual time=0.033..0.035 rows=1 loops=1)
--    Index Cond: (id = $0)
--    Buffers: shared hit=5
--    InitPlan 1 (returns $0)
--      ->  Limit  (cost=0.00..0.34 rows=1 width=16) (actual time=0.014..0.015 rows=1 loops=1)
--            Buffers: shared hit=1
--            ->  Seq Scan on posts posts_1  (cost=0.00..1171.11 rows=3411 width=16) (actual time=0.013..0.014 rows=1 loops=1)
--                  Buffers: shared hit=1
--  Planning Time: 0.291 ms
--  Execution Time: 0.061 ms
-- (10 rows)

EXPLAIN (ANALYZE, BUFFERS)
SELECT u.name, p.title
FROM users u
JOIN posts p
  ON p.user_id = u.id;

-- Seq Scan?
-- Index Scan?
-- Bitmap Scan?

-- Nested Loop?
-- Hash Join?
-- Merge Join?

-- Sort?
-- HashAggregate?
-- GroupAggregate?