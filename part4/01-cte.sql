WITH average_views AS (
    SELECT AVG(views) AS avg_views
    FROM posts
)
SELECT
    p.title,
    p.views
FROM posts AS p
CROSS JOIN average_views AS av
WHERE p.views > av.avg_views;