

-- one query inside another query

-- runs the inner query first
-- outer query 

-- which posts are performing better than average

SELECT 
  title,
  status,
  views
FROM posts
WHERE views > (
    SELECT AVG(views)
    FROM posts
)
ORDER BY views DESC;

-- SELECT p.title
-- FROM posts AS p
-- WHERE EXISTS (
--     SELECT 1
--     FROM comments AS c
--     WHERE c.post_id = p.id
-- );