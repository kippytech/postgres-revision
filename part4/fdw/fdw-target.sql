-- 1. Install the FDW extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;


-- 2. Tell PostgreSQL where the remote PostgreSQL server is
CREATE SERVER source_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host 'postgres-source',
    port '5432',
    dbname 'source_db'
);


-- 3. Tell PostgreSQL which remote credentials to use
CREATE USER MAPPING FOR postgres
SERVER source_server
OPTIONS (
    user 'postgres',
    password 'postgres'
);


-- 4. Expose the remote users table as a foreign table
CREATE FOREIGN TABLE remote_users (
    id INTEGER,
    name TEXT,
    email TEXT
)
SERVER source_server
OPTIONS (
    schema_name 'public',
    table_name 'users'
);


-- 5. Query the remote table
SELECT *
FROM remote_users
ORDER BY id;