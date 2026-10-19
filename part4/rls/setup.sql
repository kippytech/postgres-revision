DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS tenants;

CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL
);

CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    title TEXT NOT NULL,
    content TEXT NOT NULL
);

INSERT INTO tenants (name)
VALUES
    ('Tenant A'),
    ('Tenant B');

INSERT INTO documents (tenant_id, title, content)
SELECT
    t.id,
    'Tenant A document',
    'Secret data for A'
FROM tenants t
WHERE t.name = 'Tenant A';

INSERT INTO documents (tenant_id, title, content)
SELECT
    t.id,
    'Tenant B document',
    'Secret data for B'
FROM tenants t
WHERE t.name = 'Tenant B';

-- CREATE ROLE app_user
-- LOGIN
-- PASSWORD 'app_password';

-- GRANT USAGE ON SCHEMA public
-- TO app_user;

-- GRANT SELECT, INSERT, UPDATE, DELETE
-- ON documents
-- TO app_user;

-- GRANT SELECT
-- ON tenants
-- TO app_user;