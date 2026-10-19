DROP TABLE IF EXISTS people;

CREATE TABLE people (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    roles TEXT[]
);

INSERT INTO people (name, roles)
VALUES (
    'Douglas',
    ARRAY['doctor', 'developer']
);

SELECT
    name,
    roles
FROM people;

SELECT roles[1]
FROM people;

SELECT *
FROM people
WHERE roles @> ARRAY['doctor']; --OR ARRAY['doctor'] <@ roles

SELECT *
FROM people
WHERE roles && ARRAY['doctor', 'admin'];