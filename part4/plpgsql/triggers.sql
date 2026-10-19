CREATE OR REPLACE FUNCTION update_post_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    NEW.updated_at = NOW();

    RETURN NEW;

END;
$$;


CREATE TRIGGER posts_updated_at
BEFORE UPDATE ON posts
FOR EACH ROW
EXECUTE FUNCTION update_post_timestamp();


CREATE OR REPLACE FUNCTION audit_post_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF OLD.status IS DISTINCT FROM NEW.status THEN

        INSERT INTO post_audit (
            post_id,
            old_status,
            new_status
        )
        VALUES (
            NEW.id,
            OLD.status,
            NEW.status
        );

    END IF;

    RETURN NEW;

END;
$$;


CREATE TRIGGER posts_status_audit
AFTER UPDATE ON posts
FOR EACH ROW
EXECUTE FUNCTION audit_post_status();