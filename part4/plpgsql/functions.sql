CREATE OR REPLACE FUNCTION classify_views(view_count INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN

    IF view_count >= 500 THEN
        RETURN 'viral';

    ELSIF view_count >= 100 THEN
        RETURN 'popular';

    ELSE
        RETURN 'normal';
    END IF;

END;
$$;


CREATE OR REPLACE FUNCTION get_popular_posts(min_views INTEGER)
RETURNS TABLE (
    id UUID,
    title TEXT,
    views INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY
    SELECT p.id, p.title, p.views
    FROM posts p
    WHERE p.views >= min_views
    ORDER BY p.views DESC;

END;
$$;