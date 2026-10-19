DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS sensitive_documents;

CREATE TABLE sensitive_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL
);

INSERT INTO sensitive_documents (title, content)
VALUES
    ('Document A', 'Secret A'),
    ('Document B', 'Secret B');

CREATE TABLE audit_log (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,

    old_data JSONB,
    new_data JSONB,

    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    changed_by TEXT NOT NULL
);

CREATE ROLE security_app LOGIN PASSWORD 'security_password';

GRANT USAGE ON SCHEMA public
TO security_app;

GRANT SELECT, INSERT, UPDATE, DELETE
ON sensitive_documents
TO security_app;

GRANT SELECT, INSERT, UPDATE, DELETE
ON audit_log
TO security_app;