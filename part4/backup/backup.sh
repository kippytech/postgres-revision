#!/usr/bin/env bash

set -euo pipefail

CONTAINER="postgres-backup-lab"
DATABASE="backup_lab"
USER="postgres"

BASE_BACKUP_DIR="/var/lib/postgresql/base_backup"
HOST_BACKUP_DIR="./base_backup"
HOST_ARCHIVE_DIR="./archive"

echo "== PostgreSQL Base Backup =="

echo
echo "Checking PostgreSQL..."

docker exec "$CONTAINER" \
    pg_isready \
    -U "$USER" \
    -d "$DATABASE"

echo
echo "Configuring WAL archiving..."

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "ALTER SYSTEM SET wal_level = 'replica';"

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "ALTER SYSTEM SET archive_mode = 'on';"

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "ALTER SYSTEM SET archive_command = 'cp %p /var/lib/postgresql/wal_archive/%f';"
# for remote storage, you might use something like:
# ALTER SYSTEM SET archive_command = 'aws s3 cp %p s3://my-postgres-backups/%f'; or 
# ALTER SYSTEM SET archive_command = 'aws s3 cp "%p" "s3://my-postgres-backups/wal/%f" --endpoint-url https://<account-id>.r2.cloudflarestorage.com'
echo
echo "Restarting PostgreSQL..."

docker compose restart postgres

echo
echo "Waiting for PostgreSQL..."

until docker exec "$CONTAINER" \
    pg_isready \
    -U "$USER" \
    -d "$DATABASE" >/dev/null 2>&1
do
    sleep 1
done

echo "PostgreSQL is ready."

echo
echo "Verifying WAL configuration..."

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "SHOW wal_level;"

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "SHOW archive_mode;"

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "SHOW archive_command;"

docker exec -i "$CONTAINER" \
    psql -U "$USER" -d "$DATABASE" < setup.sql

echo
echo "Preparing host backup directory..."

mkdir -p "$HOST_BACKUP_DIR"

echo
echo "Removing previous base backup..."

rm -rf "$HOST_BACKUP_DIR"/*
rm -rf "$HOST_ARCHIVE_DIR"/*

echo
echo "Ensuring PostgreSQL can write to the backup directory..."

#sudo chown -R 999:999 "$HOST_BACKUP_DIR"
sudo chown -R 999:999 "$HOST_ARCHIVE_DIR"

echo
echo "Creating physical base backup..."

docker exec "$CONTAINER" \
    pg_basebackup \
    -U "$USER" \
    -D "$BASE_BACKUP_DIR" \
    -Fp \
    -Xs \
    -P

echo
echo "Base backup completed."

echo
echo "Backup size:"
du -sh "$HOST_BACKUP_DIR"/

echo
echo "Backup location:"
echo "  $HOST_BACKUP_DIR"