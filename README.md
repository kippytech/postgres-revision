# PostgreSQL Full Course

A hands-on PostgreSQL course organized as four chronological parts. It starts with databases and table design, builds through everyday SQL and relational queries, then moves into PostgreSQL features, query planning, administration, security, and integration labs. The examples use small teaching schemas such as products, users/posts/comments/tags, events, appointments, articles, and orders.

## Course at a glance

| Part | Focus |
| --- | --- |
| [Part 1](#part-1--database-and-table-fundamentals) | Database objects, data types, constraints, and keys |
| [Part 2](#part-2--working-with-rows) | CRUD, filtering, sorting, pagination, and `RETURNING` |
| [Part 3](#part-3--relationships-and-querying-related-data) | Relational modeling, joins, aggregates, subqueries, indexes, and transactions |
| [Part 4](#part-4--advanced-postgresql-and-practical-labs) | Advanced SQL, PostgreSQL-specific features, planning, operations, security, and integration |

## Part 1 — Database and table fundamentals

The first part introduces the relational database model and the PostgreSQL object hierarchy: database, schema, table, and rows. The notes in `part1/readme.md` contrast relational tables and relationships with document/key-value storage, and describe cases where relational data, joins, transactions, and database-level validation are useful.

The SQL lessons create a learning database and a `basics` schema, inspect schemas through `information_schema`, and introduce `pgcrypto`. They create tables and cover:

- `SERIAL` and identity columns, primary keys, and generated UUIDs.
- `TEXT`, `VARCHAR`, integer types, `NUMERIC`, `BOOLEAN`, timestamps, `JSONB`, and defaults.
- `NOT NULL`, `UNIQUE`, `CHECK`, and default constraints.
- The difference between `NULL`, an empty string, and numeric zero, including `IS NULL` and `IS NOT NULL`.
- A small event example that reads a JSONB field and checks for a JSONB key.

Files: `part1/01_first_database.sql` through `part1/07_constraints.sql`, plus `part1/09_primary_keys.sql`. The numbering skips `08` in the repository.

## Part 2 — Working with rows

Part 2 builds a sample `products` table and practices the common query and data-change statements against it. The base schema uses UUID identifiers, `NUMERIC` prices, check constraints, a unique SKU, and a `TIMESTAMPTZ` creation time.

In lesson order, the scripts cover:

1. The sample schema and seed rows.
2. Inserting one row and multiple rows.
3. Selecting chosen columns and using output aliases.
4. Basic `WHERE` filters and combining conditions with `AND`, `OR`, `NOT`, and parentheses.
5. Case-sensitive `LIKE` and case-insensitive PostgreSQL `ILIKE` patterns, including `%` and `_` wildcards.
6. `IN`, `NOT IN`, and `BETWEEN` filters.
7. `NULL` checks with `IS NULL` and `IS NOT NULL`.
8. `ORDER BY`, including ordering by more than one column.
9. `LIMIT` and `OFFSET` pagination.
10. Updating one or multiple rows and deleting rows.
11. `RETURNING` to read affected rows after a data-change statement.

Files: `part2/01_sql_concepts_base_file.sql` through `part2/15_returning_after_insert.sql`.

## Part 3 — Relationships and querying related data

Part 3 uses a small publishing example with users, posts, comments, tags, and the junction table `post_tags`. The reset-and-seed script establishes UUID primary keys, foreign keys, defaults, and checks before later lessons query the relationships.

The progression covers:

- Primary-key/foreign-key relationships and one-to-many relationships (users to posts, posts to comments).
- `INNER JOIN` for matching rows and `LEFT JOIN` for retaining rows without a match.
- Many-to-many relationships through a junction table, and joins across three tables.
- Table aliases and output aliases.
- `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`; grouping with `GROUP BY`, and the role of `HAVING` versus `WHERE`.
- `COUNT(DISTINCT ...)` to count unique related rows.
- Scalar and multi-row subquery patterns, including examples using `EXISTS`/`NOT EXISTS`.
- Indexes for filtered and ordered queries, simple/composite indexes, and reading plans with `EXPLAIN ANALYZE`.
- A transaction grouping updates between `BEGIN` and `COMMIT`.

Files: `part3/01_reset_and_seed_relationships.sql` through `part3/13_transactions.sql`.

## Part 4 — Advanced PostgreSQL and practical labs

Part 4 follows the numbered lesson sequence and then includes focused labs in subdirectories.

### Numbered lessons

1. **CTEs** — use a `WITH` query to name an aggregate result and join it into the main query (`01-cte.sql`).
2. **Multi-row subqueries** — `IN`, `NOT IN`, `EXISTS`, and `NOT EXISTS` (`02-multi-row-subquery.sql`).
3. **Window functions** — `OVER`, `PARTITION BY`, ordering, `ROW_NUMBER`, `LAG`, `LEAD`, and calculations that retain individual rows (`03-window-function.sql`).
4. **Window frames** — running totals, remaining totals, and moving averages with explicit `ROWS` frames (`04-window-frames.sql`).
5. **PostgreSQL upsert behavior** — `INSERT ... ON CONFLICT ... DO UPDATE`, `EXCLUDED`, and `RETURNING` (`05-postgres-specifics.sql`).
6. **Query expressions** — `DISTINCT ON`, aggregate `FILTER`, `CASE`, `COALESCE`, `NULLIF`, `GREATEST`, and `LEAST` (`06-query-expressions.sql`).
7. **Arrays** — array columns and literals, subscripting, containment (`@>`), and overlap (`&&`) (`07-arrays-.sql`).
8. **JSONB updates** — JSONB documents and `jsonb_set` (`08-jsonb.sql`).
9. **Data-modifying CTEs** — use `INSERT ... RETURNING` inside a CTE to create related user/post rows (`09-data-modifying-cte..sql`).
10. **Index planning** — inspect plans and buffers, including bitmap scans, primary-key lookup, and joins (`10-index-planner.sql`).
11. **Planner statistics** — inspect `pg_stats`, compare estimated and actual plans, and run `ANALYZE` (`11-query-planner-internals.sql`).
12. **Roles and permissions** — create application, migration, and admin roles; set ownership and grant database, schema, table, and sequence privileges (`12-permissions-lab.sql`).
13. **Partitioning strategies** — range, list, and hash partition definitions (`13-partitioning-strategies.sql`).
14. **Range partitioning example** — insert timestamped events, inspect the child table via `tableoid`, and examine partition pruning (`14-partitioning-example.sql`).

### Focused labs

- **`part4/optimization/`** — a generated customers/orders/order-items workload; indexes for sorting and aggregation; sargable timestamp filters; join and aggregation plans; and extended statistics (`CREATE STATISTICS`) for correlated columns. The scripts use `EXPLAIN (ANALYZE, BUFFERS)`, `work_mem`, and planner settings to compare plan behavior.
- **`part4/performance/`** — a 100,000-row table with `fillfactor`; inspection examples for live/dead tuples, `VACUUM`, HOT updates, and table/index size functions.
- **`part4/incident-diagnosis/`** — diagnostic queries against PostgreSQL statistics views and functions, including `pg_stat_activity`, blocking PIDs, wait events, table statistics, connection counts, WAL archiving, replication status, and database/relation sizes. Notes outline investigation paths for slow queries, locks, long transactions, vacuum, I/O, WAL, replication, and connection pressure.
- **`part4/fulltext/`** — full-text search setup using `tsvector`, weighted title/body vectors, a stored generated column, and a GIN index. Search and ranking query examples are included as comments.
- **`part4/ranges/`** — timestamp range (`TSTZRANGE`) values for appointments, overlap/containment operators, lower/upper bounds, and a GiST index.
- **`part4/plpgsql/`** — PL/pgSQL scalar and table-returning functions, `IF`/`ELSIF`, triggers for update timestamps, and status-change auditing.
- **`part4/rls/`** — tenant/document sample data, row-level security, a tenant-isolation policy using `USING` and `WITH CHECK`, and transaction-local tenant settings with `SET LOCAL`.
- **`part4/security/`** — application-role grants, an audit table and trigger storing old/new row values as JSONB, and a `SECURITY DEFINER` document-reading function with a fixed `search_path`.
- **`part4/fdw/`** — two PostgreSQL services; `postgres_fdw`, a foreign server and user mapping, and a foreign table used to query a remote users table.
- **`part4/logical-replication/`** — publisher/subscriber Compose setup, a publication and subscription for users/posts, and queries (in comments) to inspect replication slots, WAL positions, and subscription/replication state.
- **`part4/backup/`** — PostgreSQL 16 Compose services and scripts for WAL archiving setup, physical base backup with `pg_basebackup`, named restore points, WAL segment switching, and point-in-time recovery to a named restore point.

## Repository structure

```text
.
├── compose.yml                 # Main PostgreSQL 16 service (app_db on port 5432)
├── part1/                      # Database, schema, data types, constraints, keys
├── part2/                      # CRUD, filtering, sorting, pagination
├── part3/                      # Relationships, joins, aggregates, indexes, transactions
└── part4/
    ├── *.sql                   # Numbered advanced SQL and PostgreSQL lessons
    ├── optimization/           # Query-plan and optimization exercises
    ├── performance/            # Table maintenance and storage observations
    ├── incident-diagnosis/     # Operational diagnostic queries
    ├── fulltext/               # Full-text search setup
    ├── ranges/                 # Range type examples
    ├── plpgsql/                # Functions and triggers
    ├── rls/                    # Row-level security lab
    ├── security/               # Audit trigger and privileged function lab
    ├── fdw/                    # postgres_fdw source/target setup
    ├── logical-replication/    # Publication/subscription setup
    └── backup/                 # WAL archive, base backup, and recovery scripts
```

## Running the examples

The root `compose.yml` starts PostgreSQL 16 with database `app_db`, user/password `postgres`, and port `5432`. Start it from the repository root with:

```sh
docker compose up -d
```

Connect with `psql` using `postgresql://postgres:postgres@localhost:5432/app_db`, or use another PostgreSQL client. Run the SQL files in lesson order within the appropriate database. Part 1 explicitly creates a separate learning database named `postgresql_part1`; Part 3's permission lab refers to `postgresql_part3`. Several advanced lab setup files drop and recreate their example tables, and the optimization, FDW, logical replication, and backup labs have their own Compose files or service configuration. Run those labs from their relevant directory and consult their scripts for the expected services and setup order.

These files are teaching exercises rather than a migration system. Some statements assume that earlier scripts have created tables, extensions, data, or indexes; use the relevant setup/seed script first. The backup scripts execute Docker and host-level file/ownership operations, so review their configured paths and commands before running them.

## Example workflows

- **Products CRUD:** create the Part 2 sample data, then follow the insert, filter, update, delete, and `RETURNING` scripts.
- **Publishing relationships:** reset and seed the Part 3 users/posts/comments/tags schema, then query authors, comments, and tags with joins and aggregates.
- **Event data:** explore PostgreSQL JSONB and arrays in the numbered Part 4 lessons, then compare with full-text search, range values, or partitioned event tables in the focused labs.
- **Operational investigation:** load the optimization workload or performance sample, inspect a plan with `EXPLAIN (ANALYZE, BUFFERS)`, and use the incident-diagnosis queries to inspect activity and database health.

## Scope

This README reflects topics and examples present in the repository's SQL, shell, Compose, and notes files. It does not assume a particular lesson delivery format or add topics that are not represented in those materials.
