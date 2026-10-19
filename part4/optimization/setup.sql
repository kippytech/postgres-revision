DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    country TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    total NUMERIC(12,2) NOT NULL
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (country, city)
SELECT
    CASE
        WHEN n <= 70000 THEN 'Kenya'
        WHEN n <= 90000 THEN 'USA'
        WHEN n <= 98000 THEN 'India'
        ELSE 'Germany'
    END,
    CASE
        WHEN n <= 70000 THEN
            CASE
                WHEN n % 10 = 0 THEN 'Mombasa'
                ELSE 'Nairobi'
            END
        WHEN n <= 90000 THEN
            CASE
                WHEN n % 10 = 0 THEN 'Chicago'
                ELSE 'New York'
            END
        WHEN n <= 98000 THEN 'Mumbai'
        ELSE 'Berlin'
    END
FROM generate_series(1, 100000) AS n;

INSERT INTO orders (
    customer_id,
    status,
    created_at,
    total
)
SELECT
    (random() * 99999 + 1)::BIGINT,
    CASE
        WHEN random() < 0.70 THEN 'completed'
        WHEN random() < 0.85 THEN 'pending'
        ELSE 'cancelled'
    END,
    NOW() - (random() * INTERVAL '365 days'),
    round((random() * 10000)::numeric, 2)
FROM generate_series(1, 1000000);

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price
)
SELECT
    (random() * 999999 + 1)::BIGINT,
    (random() * 999 + 1)::INTEGER,
    (random() * 5 + 1)::INTEGER,
    round((random() * 500)::numeric, 2)
FROM generate_series(1, 3000000);

ANALYZE customers;
ANALYZE orders;
ANALYZE order_items;