-- WITH ranked AS (
--     SELECT
--         p.*,
--         ROW_NUMBER() OVER (
--             PARTITION BY user_id
--             ORDER BY views DESC
--         ) AS rn
--     FROM posts p
-- )
-- SELECT *
-- FROM ranked
-- WHERE rn = 1;

SELECT DISTINCT ON (user_id)
    user_id,
    title,
    views
FROM posts
ORDER BY user_id, views DESC;
--for each user:
    -- highest views comes first
    -- → therefore that row survives

SELECT
    COUNT(*) AS total_posts,
    COUNT(*) FILTER (
        WHERE status = 'published'
    ) AS published_posts,
    COUNT(*) FILTER (
        WHERE status = 'draft'
    ) AS draft_posts
FROM posts;

SELECT
    user_id,
    COUNT(*) AS total,
    COUNT(*) FILTER (
        WHERE status = 'published'
    ) AS published,
    COUNT(*) FILTER (
        WHERE status = 'draft'
    ) AS drafts
FROM posts
GROUP BY user_id;

SELECT
    title,
    views,
    CASE
        WHEN views >= 150 THEN 'high'
        WHEN views >= 75 THEN 'medium'
        ELSE 'low'
    END AS popularity
FROM posts;

SELECT
    title,
    COALESCE(status, 'unknown') AS status
FROM posts;

SELECT NULLIF(views, 0)
FROM posts;

SELECT
    GREATEST(10, 20, 5);

SELECT
    LEAST(10, 20, 5);