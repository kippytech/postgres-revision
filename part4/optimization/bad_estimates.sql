EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM customers
WHERE country = 'Kenya'
  AND city = 'Nairobi';

CREATE STATISTICS customers_country_city_stats
(
    dependencies,
    mcv
)
ON country, city
FROM customers;

ANALYZE customers;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM customers
WHERE country = 'Kenya'
  AND city = 'Nairobi';