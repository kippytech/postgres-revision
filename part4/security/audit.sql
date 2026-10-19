CREATE OR REPLACE FUNCTION audit_row()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF TG_OP = 'INSERT' THEN

        INSERT INTO audit_log (
            table_name,
            operation,
            new_data,
            changed_by
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            to_jsonb(NEW),
            current_user
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO audit_log (
            table_name,
            operation,
            old_data,
            new_data,
            changed_by
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            to_jsonb(OLD),
            to_jsonb(NEW),
            current_user
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        INSERT INTO audit_log (
            table_name,
            operation,
            old_data,
            changed_by
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            to_jsonb(OLD),
            current_user
        );

        RETURN OLD;

    END IF;

END;
$$;

-- Attach audit trigger to sensitive_documents
DROP TRIGGER IF EXISTS sensitive_documents_audit
ON sensitive_documents;

CREATE TRIGGER sensitive_documents_audit
AFTER INSERT OR UPDATE OR DELETE
ON sensitive_documents
FOR EACH ROW
EXECUTE FUNCTION audit_row();

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