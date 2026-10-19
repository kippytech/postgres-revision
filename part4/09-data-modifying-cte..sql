WITH new_user AS (
    INSERT INTO users (name)
    VALUES ('Douglas')
    RETURNING id
)
INSERT INTO posts (user_id, title)
SELECT id, 'Learning PostgreSQL'
FROM new_user
RETURNING id, title;

WITH new_user AS (
    INSERT INTO users (name)
    VALUES ('Douglas')
    RETURNING id
),
new_post AS (
    INSERT INTO posts (user_id, title)
    SELECT id, 'PostgreSQL Deep Dive'
    FROM new_user
    RETURNING id
)
SELECT *
FROM new_post;

-- WITH deleted_posts AS (
--     DELETE FROM posts
--     WHERE status = 'draft'
--     RETURNING *
-- )
-- INSERT INTO deleted_posts_archive
-- SELECT *
-- FROM deleted_posts;