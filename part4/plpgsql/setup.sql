DROP TABLE IF EXISTS post_audit;
DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published')),
    views INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO posts (title, status, views)
VALUES
    ('PostgreSQL Internals', 'published', 500),
    ('Learning PL/pgSQL', 'draft', 50),
    ('Database Indexes', 'published', 300);

CREATE TABLE post_audit (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id UUID NOT NULL,
    old_status TEXT,
    new_status TEXT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);