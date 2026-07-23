#!/bin/sh
set -eu

if [ "${1:-}" = "" ]; then
  echo "Usage: scripts/restore-postgres.sh backups/timesheet-YYYYMMDD-HHMMSS.sql.gz" >&2
  exit 1
fi

BACKUP_FILE="$1"
gzip -dc "$BACKUP_FILE" | docker compose exec -T db psql -U timesheet -d timesheet
