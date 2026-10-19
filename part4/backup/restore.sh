#!/usr/bin/env bash

set -euo pipefail

RECOVERY_CONTAINER="postgres-recovery-lab"

RECOVERY_DB="backup_lab"
RECOVERY_USER="postgres"

RESTORE_POINT="before_disaster"

BASE_BACKUP_DIR="./base_backup"

RECOVERY_DIR="./recovery_data"

echo "== PostgreSQL Point-in-Time Recovery =="

echo
echo "Checking base backup..."

if [ ! -d "$BASE_BACKUP_DIR" ]; then
    echo "ERROR: $BASE_BACKUP_DIR does not exist."
    echo "Run ./backup.sh first."
    exit 1
fi

if [ ! -f "$BASE_BACKUP_DIR/PG_VERSION" ]; then
    echo "ERROR: $BASE_BACKUP_DIR does not appear to contain a PostgreSQL base backup."
    exit 1
fi

echo "Base backup found."

# mkdir -p "$RECOVERY_DIR"
# cp -a "$BASE_BACKUP_DIR"/. "$RECOVERY_DIR"/

echo
echo "Stopping previous recovery container if it exists..."

docker compose --profile recovery stop recovery 2>/dev/null || true
# docker compose --profile recovery rm -f recovery 2>/dev/null || true

echo
echo "Preparing base backup permissions..."

sudo chown -R 999:999 "$BASE_BACKUP_DIR"

# echo
# echo "Preparing WAL archive permissions..."

# sudo chown -R 999:999 "$ARCHIVE_DIR"

echo
echo "Creating recovery.signal..."

sudo touch "$BASE_BACKUP_DIR/recovery.signal"

echo
echo "Configuring PostgreSQL recovery..."

# PITR configuration
sudo sed -i \
    '/^restore_command =/d;
     /^recovery_target_name =/d;
     /^recovery_target_action =/d' \
    "$BASE_BACKUP_DIR/postgresql.conf"

sudo tee -a "$BASE_BACKUP_DIR/postgresql.conf" > /dev/null <<EOF
restore_command = 'cp /var/lib/postgresql/wal_archive/%f %p'
recovery_target_name = '$RESTORE_POINT'
recovery_target_action = 'pause'
EOF

# cat >> "$BASE_BACKUP_DIR/postgresql.conf" <<EOF

# # PITR configuration
# restore_command = 'cp /var/lib/postgresql/wal_archive/%f %p'
# recovery_target_name = '$RESTORE_POINT'
# recovery_target_action = 'pause'
# EOF

echo
echo "Starting recovery PostgreSQL..."

docker compose --profile recovery up -d recovery

echo
echo "Waiting for PostgreSQL..."

until docker exec "$RECOVERY_CONTAINER" \
    pg_isready \
    -U "$RECOVERY_USER" \
    -d "$RECOVERY_DB" >/dev/null 2>&1
do
    sleep 1
done

echo
echo "Recovery PostgreSQL is ready."

echo
echo "Recovery status:"
docker logs "$RECOVERY_CONTAINER" --tail 30

echo
echo "The database should now be paused at:"
echo "  $RESTORE_POINT"

echo
echo "Connect with:"
echo "  docker exec -it $RECOVERY_CONTAINER psql -U $RECOVERY_USER -d $RECOVERY_DB"

# then SELECT pg_wal_replay_resume(); for the database to resume normal operation.