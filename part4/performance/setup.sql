DROP TABLE IF EXISTS performance_test;

CREATE TABLE performance_test (
    id BIGSERIAL PRIMARY KEY,
    category INTEGER NOT NULL,
    payload TEXT NOT NULL
)
WITH (
    fillfactor = 70
);

INSERT INTO performance_test (category, payload)
SELECT
    (random() * 9)::INTEGER,
    repeat('x', 100)
FROM generate_series(1, 100000);