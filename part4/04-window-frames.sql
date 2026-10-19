-- -- Total for entire table
-- SUM(views) OVER ()

-- -- Total for each user's partition
-- SUM(views) OVER (
--     PARTITION BY user_id
-- )

-- -- Running total
-- SUM(views) OVER (
--     ORDER BY created_at
-- )

-- -- Running total, explicitly framed
-- SUM(views) OVER (
--     ORDER BY created_at
--     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- )

-- -- 3-row moving total
-- SUM(views) OVER (
--     ORDER BY created_at
--     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- )

-- -- 3-row moving average
-- AVG(views) OVER (
--     ORDER BY created_at
--     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- )

SELECT
    title,
    views,
    SUM(views) OVER (
        ORDER BY views
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM posts;

SELECT
    title,
    views,
    SUM(views) OVER (
        ORDER BY views
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS remaining_views
FROM posts;

--moving window
SELECT
    title,
    views,
    AVG(views) OVER (
        ORDER BY views
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW --FOLLOWING
    ) AS moving_average
FROM posts;