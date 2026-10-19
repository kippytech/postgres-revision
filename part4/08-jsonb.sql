DROP TABLE IF EXISTS documents;

CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data JSONB NOT NULL
);

INSERT INTO documents (data)
VALUES (
    '{
        "name": "Douglas",
        "age": 30,
        "skills": ["Go", "TypeScript"],
        "address": {
            "city": "Nairobi"
        }
    }'
);


UPDATE documents
SET data = jsonb_set(
    data,
    '{address,city}',
    '"Mombasa"'
)
WHERE id = $1;