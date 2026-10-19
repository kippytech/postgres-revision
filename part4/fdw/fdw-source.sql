DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL
);

INSERT INTO users (id, name, email)
VALUES
    (1, 'Douglas', 'douglas@example.com'),
    (2, 'Ananya', 'ananya@example.com'),
    (3, 'Rahul', 'rahul@example.com');