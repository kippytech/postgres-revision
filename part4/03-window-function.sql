SELECT
    title,
    user_id,
    views,
    COUNT(*) OVER (PARTITION BY user_id) AS post_count
FROM posts;

--vs GROUP BY user_id, title, views

-- SELECT
--     user_id,
--     COUNT(*) AS post_count
-- FROM posts
-- GROUP BY user_id;

SELECT
    u.name,
    p.title,
    p.views,
    SUM(p.views) OVER (
        PARTITION BY p.user_id
    ) AS author_total_views
FROM posts p
JOIN users u
    ON u.id = p.user_id;

SELECT
    title,
    views,
    SUM(views) OVER (
        ORDER BY views
    ) AS running_total
FROM posts;

SELECT
    title,
    views,
    ROW_NUMBER() OVER (
        ORDER BY views DESC
    ) AS position
FROM posts;

SELECT
    u.name,
    p.title,
    p.views,
    ROW_NUMBER() OVER (
        PARTITION BY p.user_id
        ORDER BY p.views DESC
    ) AS author_rank
FROM posts p
JOIN users u
    ON u.id = p.user_id;

SELECT
    title,
    views,
    LAG(views) OVER (
        ORDER BY views
    ) AS previous_views
FROM posts;

SELECT
    title,
    views,
    LAG(views) OVER (
        ORDER BY views
    ) AS previous_views,
    views - LAG(views) OVER (
        ORDER BY views
    ) AS difference
FROM posts;

SELECT
    title,
    views,
    LEAD(views, 2, 0) OVER (
        ORDER BY views
    ) AS next_views
FROM posts;

--2 ORDER BY:
SELECT
    title,
    views,
    ROW_NUMBER() OVER (
        ORDER BY views DESC
    ) AS rank
FROM posts
ORDER BY title;

WITH ranked AS (
    SELECT
        title,
        views,
        LAG(views, 1, 0) OVER (   -- COLUMN, OFFSET, DEFAULT
            ORDER BY views
        ) AS previous_views
    FROM posts
)
SELECT *
FROM ranked
WHERE views > previous_views;

SELECT
    title,
    views,
    views - AVG(views) OVER (
        PARTITION BY user_id
    ) AS difference_from_author_avg
FROM posts;