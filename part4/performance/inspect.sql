-- UPDATE performance_test
-- SET payload = repeat('y', 100);

-- SELECT
--     relname,
--     n_live_tup,
--     n_dead_tup
-- FROM pg_stat_user_tables
-- WHERE relname = 'performance_test';

-- VACUUM performance_test;

-- SELECT
--     relname,
--     n_live_tup,
--     n_dead_tup
-- FROM pg_stat_user_tables
-- WHERE relname = 'performance_test';

-- CREATE INDEX idx_performance_category
-- ON performance_test(category);

-- UPDATE performance_test
-- SET payload = repeat('z', 100);

-- SELECT
--     n_tup_upd,
--     n_tup_hot_upd
-- FROM pg_stat_user_tables
-- WHERE relname = 'performance_test';

-- SELECT
--     pg_size_pretty(
--         pg_relation_size('performance_test')
--     ) AS table_size;

-- SELECT
--     pg_size_pretty(
--         pg_total_relation_size('performance_test')
--     ) AS total_size;