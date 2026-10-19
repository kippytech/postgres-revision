DROP INDEX idx_orders_customer_created;

CREATE INDEX idx_orders_customer_total
ON orders(customer_id)
INCLUDE (total);

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    customer_id,
    COUNT(*),
    SUM(total)
FROM orders
GROUP BY customer_id;

SET enable_indexscan = off;
SET enable_indexonlyscan = off;

SET work_mem = '64MB';

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    customer_id,
    COUNT(*),
    SUM(total)
FROM orders
GROUP BY customer_id;

RESET enable_indexscan;
RESET enable_indexonlyscan;

RESET work_mem

-- docker exec -i postgres-lab   psql -U postgres -d app_db < part4/optimization/aggregation.sql
-- ERROR:  index "idx_orders_customer_created" does not exist
-- ERROR:  relation "idx_orders_customer_total" already exists
--                                                                            QUERY PLAN                                                                           
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
--  GroupAggregate  (cost=0.42..39053.69 rows=91301 width=48) (actual time=0.402..447.567 rows=99996 loops=1)
--    Group Key: customer_id
--    Buffers: shared hit=3835
--    ->  Index Only Scan using idx_orders_customer_total on orders  (cost=0.42..30412.42 rows=1000000 width=14) (actual time=0.359..205.530 rows=1000000 loops=1)
--          Heap Fetches: 0
--          Buffers: shared hit=3835
--  Planning:
--    Buffers: shared hit=134
--  Planning Time: 3.121 ms
--  Execution Time: 453.477 ms
-- (10 rows)

-- SET
-- SET
--                                                                    QUERY PLAN                                                                    
-- -------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=57533.31..81805.65 rows=91301 width=48) (actual time=833.623..1142.679 rows=99996 loops=1)
--    Group Key: customer_id
--    Buffers: shared hit=9105, temp read=6933 written=10287
--    ->  Gather Merge  (cost=57533.31..78838.36 rows=182602 width=48) (actual time=833.601..954.368 rows=288839 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          Buffers: shared hit=9105, temp read=6933 written=10287
--          ->  Sort  (cost=56533.29..56761.54 rows=91301 width=48) (actual time=799.645..818.342 rows=96280 loops=3)
--                Sort Key: customer_id
--                Sort Method: external merge  Disk: 8832kB
--                Buffers: shared hit=9105, temp read=6933 written=10287
--                Worker 0:  Sort Method: external merge  Disk: 8712kB
--                Worker 1:  Sort Method: external merge  Disk: 8616kB
--                ->  Partial HashAggregate  (cost=40990.06..46200.34 rows=91301 width=48) (actual time=413.952..702.920 rows=96280 loops=3)
--                      Group Key: customer_id
--                      Planned Partitions: 4  Batches: 21  Memory Usage: 8249kB  Disk Usage: 11424kB
--                      Buffers: shared hit=9089, temp read=3663 written=7008
--                      Worker 0:  Batches: 21  Memory Usage: 8249kB  Disk Usage: 11128kB
--                      Worker 1:  Batches: 21  Memory Usage: 8249kB  Disk Usage: 11016kB
--                      ->  Parallel Seq Scan on orders  (cost=0.00..13255.67 rows=416667 width=14) (actual time=0.045..74.976 rows=333333 loops=3)
--                            Buffers: shared hit=9089
--  Planning Time: 0.124 ms
--  Execution Time: 1153.991 ms
-- (23 rows)

-- RESET
-- RESET
-- dagginho@DESKTOP-BUGKGO7:~/projects/postgres-course/postgres_full_course_2026$

--for WORK_MEM=64MB
-- QUERY PLAN                                                       
-- ------------------------------------------------------------------------------------------------------------------------
--  HashAggregate  (cost=26589.00..27730.26 rows=91301 width=48) (actual time=701.576..747.784 rows=99996 loops=1)
--    Group Key: customer_id
--    Batches: 1  Memory Usage: 44049kB
--    Buffers: shared hit=9089
--    ->  Seq Scan on orders  (cost=0.00..19089.00 rows=1000000 width=14) (actual time=0.024..90.882 rows=1000000 loops=1)
--          Buffers: shared hit=9089
--  Planning Time: 0.177 ms
--  Execution Time: 758.112 ms
-- (8 rows)