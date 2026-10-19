#!/usr/bin/env bash

set -euo pipefail

CONTAINER="postgres-backup-lab"
DATABASE="backup_lab"
USER="postgres"

RESTORE_POINT="before_disaster"

echo "== Creating PostgreSQL Restore Point =="

echo
echo "Creating restore point: $RESTORE_POINT"

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "SELECT pg_create_restore_point('$RESTORE_POINT');"

echo
echo "Forcing WAL segment switch..."

docker exec "$CONTAINER" \
    psql \
    -U "$USER" \
    -d "$DATABASE" \
    -c "SELECT pg_switch_wal();"

echo
echo "Restore point created successfully:"
echo "  $RESTORE_POINT"