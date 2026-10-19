CREATE INDEX idx_orders_created_at
ON orders(created_at);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE created_at::date = CURRENT_DATE;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE created_at >= CURRENT_DATE
  AND created_at < CURRENT_DATE + INTERVAL '1 day';