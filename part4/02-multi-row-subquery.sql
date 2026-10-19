SELECT
    title,
    user_id
FROM posts
WHERE user_id IN (
    SELECT id
    FROM users
    WHERE name IN ('Ananya', 'Rahul')
);

SELECT
    title,
    user_id
FROM posts
WHERE user_id NOT IN (
    SELECT id
    FROM users
    WHERE name = 'Ananya'
);

SELECT
    u.name
FROM users AS u
WHERE EXISTS (
    SELECT 1
    FROM posts AS p
    WHERE p.user_id = u.id
);

SELECT
    p.title
FROM posts AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM comments AS c
    WHERE c.post_id = p.id
);

-- SELECT DISTINCT p.title
-- FROM posts AS p
-- JOIN comments AS c
--     ON c.post_id = p.id;