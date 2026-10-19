


-- index helps postgres find rows faster 

-- SELECT -> speed it up this particular process
EXPLAIN ANALYZE
SELECT 
  id,
  title,
  status,
  views,
  user_id
FROM posts;

-- /posts?status=published
EXPLAIN ANALYZE
SELECT 
  id,
  title,
  status
FROM posts
WHERE status = 'published';


-- idx_posts_status
-- idx - index 
-- posts - table name 
-- status - column name

CREATE INDEX IF NOT EXISTS idx_posts_status
ON posts(status);

EXPLAIN ANALYZE
SELECT 
  id,
  title,
  status
FROM posts
WHERE status = 'published';

EXPLAIN ANALYZE
SELECT 
  title,
  status,
  views 
FROM posts
WHERE status = 'published'
ORDER BY views DESC;

-- composite index 

CREATE INDEX IF NOT EXISTS idx_posts_status_views
ON posts(status, views DESC);

EXPLAIN ANALYZE
SELECT 
  title,
  status,
  views 
FROM posts
WHERE status = 'published'
ORDER BY views DESC;

-- /users/:id/posts
EXPLAIN ANALYZE
SELECT
  title,
  status,
  views
FROM posts
WHERE user_id = (
    SELECT id
    FROM users 
    WHERE name = 'rahul'
);

CREATE INDEX IF NOT EXISTS idx_posts_user_id
ON posts(user_id);

EXPLAIN ANALYZE
SELECT
  title,
  status,
  views
FROM posts
WHERE user_id = (
    SELECT id
    FROM users 
    WHERE name = 'Rahul'
);