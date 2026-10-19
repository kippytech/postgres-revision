DROP TABLE IF EXISTS articles;

CREATE TABLE articles (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL

    search_vector TSVECTOR
    GENERATED ALWAYS AS (
        setweight(
            to_tsvector('english', title),
            'A'
        )
        ||
        setweight(
            to_tsvector('english', body),
            'B'
        )
    ) STORED
);

CREATE INDEX idx_articles_search_vector
ON articles
USING GIN (search_vector);

-- setweight(
--     to_tsvector('english', title),
--     'A'
-- )
-- ||
-- setweight(
--     to_tsvector('english', body),
--     'B'
-- )

INSERT INTO articles (title, body)
VALUES
(
    'PostgreSQL Indexes',
    'PostgreSQL indexes make database queries faster by avoiding unnecessary table scans.'
),
(
    'Understanding PostgreSQL Joins',
    'PostgreSQL joins combine rows from multiple tables using relationships between columns.'
),
(
    'Building Backend APIs',
    'Backend applications often use PostgreSQL databases to store application data.'
),
(
    'Database Performance',
    'Database performance depends on indexes, query planning, statistics, and efficient SQL.'
),
(
    'Learning Linux Networking',
    'Linux networking fundamentals are important when building high performance backend services.'
);

-- ALTER TABLE articles
-- ADD COLUMN search_vector TSVECTOR
-- GENERATED ALWAYS AS (
--     setweight(to_tsvector('english', title), 'A')
--     ||
--     setweight(to_tsvector('english', body), 'B')
-- ) STORED;

-- CREATE INDEX idx_articles_search_vector
-- ON articles
-- USING GIN (search_vector);

-- SELECT
--     id,
--     title
-- FROM articles
-- WHERE to_tsvector('english', title || ' ' || body)
--       @@
--       to_tsquery('english', 'postgresql');

-- SELECT
--     id,
--     title,
--     ts_rank(
--         to_tsvector('english', title || ' ' || body),
--         to_tsquery('english', 'postgresql')
--     ) AS rank
-- FROM articles
-- WHERE to_tsvector('english', title || ' ' || body)
--       @@ to_tsquery('english', 'postgresql')
-- ORDER BY rank DESC;

-- SELECT
--     id,
--     title,
--     ts_rank(
--         setweight(to_tsvector('english', title), 'A')
--         ||
--         setweight(to_tsvector('english', body), 'B'),
--         websearch_to_tsquery('english', 'postgresql')
--     ) AS rank
-- FROM articles
-- WHERE (
--     setweight(to_tsvector('english', title), 'A')
--     ||
--     setweight(to_tsvector('english', body), 'B')
-- )
-- @@
-- websearch_to_tsquery('english', 'postgresql')
-- ORDER BY rank DESC;