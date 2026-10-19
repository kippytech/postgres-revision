-- docker exec -it postgres-lab psql -U postgres -d postgresql_part3

CREATE ROLE app_user
LOGIN
PASSWORD 'app_password';

CREATE ROLE migration_user
LOGIN
PASSWORD 'migration_password';

CREATE ROLE admin_user
LOGIN
PASSWORD 'admin_password';

ALTER DATABASE postgresql_part3
OWNER TO admin_user;

ALTER SCHEMA public OWNER TO admin_user;

GRANT CONNECT
ON DATABASE postgresql_part3
TO app_user, migration_user;

GRANT USAGE
ON SCHEMA public
TO app_user, migration_user;

GRANT
    SELECT,
    INSERT,
    UPDATE,
    DELETE
ON ALL TABLES IN SCHEMA public
TO app_user;

GRANT
    USAGE,
    SELECT
ON ALL SEQUENCES IN SCHEMA public
TO app_user;

GRANT CREATE
ON SCHEMA public
TO migration_user;

ALTER TABLE users OWNER TO migration_user;
ALTER TABLE posts OWNER TO migration_user;
ALTER TABLE comments OWNER TO migration_user;
ALTER TABLE tags OWNER TO migration_user;
ALTER TABLE post_tags OWNER TO migration_user;

-- docker exec -it postgres-lab psql \
--   -U app_user \
--   -d postgresql_part3

-- SELECT *
-- FROM posts
-- LIMIT 5;

-- INSERT INTO posts (user_id, title)
-- SELECT id, 'Permission Test'
-- FROM users
-- LIMIT 1;

-- CREATE TABLE hacker_table (
--     id INTEGER
-- );

-- docker exec -it postgres-lab psql \
--   -U migration_user \
--   -d postgresql_part3

-- ALTER TABLE posts
-- ADD COLUMN migration_test BOOLEAN;

-- ALTER TABLE posts
-- DROP COLUMN migration_test;

-- Default privileges
-- ALTER DEFAULT PRIVILEGES
-- IN SCHEMA public
-- GRANT SELECT, INSERT, UPDATE, DELETE
-- ON TABLES
-- TO app_user;

-- ALTER DEFAULT PRIVILEGES
-- IN SCHEMA public
-- GRANT USAGE, SELECT
-- ON SEQUENCES
-- TO app_user;