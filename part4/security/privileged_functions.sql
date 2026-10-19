-- UPDATE sensitive_documents
-- SET content = 'Modified secret'
-- WHERE title = 'Document A';

-- SELECT
--     table_name,
--     operation,
--     old_data,
--     new_data,
--     changed_by,
--     changed_at
-- FROM audit_log;

-- Function runs with the privileges of its owner
CREATE OR REPLACE FUNCTION get_document(
    document_id UUID
)
RETURNS TABLE (
    id UUID,
    title TEXT,
    content TEXT
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
    SELECT
        d.id,
        d.title,
        d.content
    FROM public.sensitive_documents AS d
    WHERE d.id = document_id;
$$;

-- Allow the application role to execute the function
GRANT EXECUTE
ON FUNCTION get_document(UUID)
TO security_app;

-- REVOKE SELECT
-- ON sensitive_documents
-- FROM security_app;

-- SELECT *
-- FROM get_document('7a2d06ad-ea00-4f60-8ee4-90ea899b05bc');