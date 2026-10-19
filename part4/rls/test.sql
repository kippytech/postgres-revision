SELECT *
FROM tenants;

BEGIN;

SET LOCAL app.tenant_id = 'a3ddf6ef-b940-46c3-b557-b0bf917fe6bb';

SELECT *
FROM documents;

COMMIT;

BEGIN;

SET LOCAL app.tenant_id = '0b0b3173-bff1-4061-9853-29b729efee2e';

SELECT *
FROM documents;

COMMIT;

-- Below will result in ERROR:  new row violates row-level security policy for table "documents"
BEGIN;

-- avoid SET w/o LOCAL, otherwise it will be set for the whole session, It remains on that PostgreSQL connection until changed/reset.
-- SET LOCAL only lasts for the current transaction
SET LOCAL app.tenant_id = 'a3ddf6ef-b940-46c3-b557-b0bf917fe6bb';

INSERT INTO documents (
    tenant_id,
    title,
    content
)
VALUES (
    '0b0b3173-bff1-4061-9853-29b729efee2e',
    'Attack',
    'Trying to write into B'
);

COMMIT;

-- const client = await pool.connect();

-- try {
--   await client.query("BEGIN");

--   await client.query(
--     "SET LOCAL app.tenant_id = $1",
--     [tenantId]
--   );

--   const result = await client.query(`
--     SELECT *
--     FROM documents
--     ORDER BY created_at DESC
--   `);

--   await client.query("COMMIT");

--   return result.rows;
-- } catch (err) {
--   await client.query("ROLLBACK");
--   throw err;
-- } finally {
--   client.release();
-- }