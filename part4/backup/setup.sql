DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    customer TEXT NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO payments (customer, amount)
VALUES
    ('Alice', 100.00),
    ('Bob', 250.00),
    ('Charlie', 500.00);

SELECT *
FROM payments
ORDER BY id;