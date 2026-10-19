DROP TABLE IF EXISTS user_profiles;

CREATE TABLE user_profiles (
    user_id SERIAL PRIMARY KEY,
    display_name TEXT NOT NULL,
    login_count INTEGER NOT NULL DEFAULT 0
);

INSERT INTO user_profiles (
    user_id,
    display_name,
    login_count
)
VALUES (
    1,
    'Douglas',
    5
)
RETURNING *;

INSERT INTO user_profiles (
    user_id,
    display_name
)
VALUES (
    1,
    'Kippy'
)
ON CONFLICT (user_id)
DO UPDATE
SET display_name = EXCLUDED.display_name -- Updates Douglas to Kippy
WHERE user_profiles.display_name IS DISTINCT FROM EXCLUDED.display_name  --NOT NECESSARY, BUT GOOD PRACTICE
RETURNING *;

-- SELECT *
-- FROM user_profiles;

-- INSERT INTO page_views (page_id, views)
-- VALUES ('123', 1)
-- ON CONFLICT (page_id)
-- DO UPDATE
-- SET views = page_views.views + EXCLUDED.views;

    --               INSERT
    --                 │
    --           uniqueness check
    --                 │
    --       ┌─────────┴─────────┐
    --       │                   │
    --    no conflict          conflict
    --       │                   │
    --    INSERT             ┌────┴────┐
    --                       │         │
    --                  DO NOTHING  DO UPDATE