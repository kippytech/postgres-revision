CREATE INDEX idx_orders_customer_created
ON orders(customer_id, created_at DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE customer_id = 46390  --50000
ORDER BY created_at DESC
LIMIT 20;