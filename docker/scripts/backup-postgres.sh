#!/bin/sh
set -eu

BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"
COMPOSE_DIR="${COMPOSE_DIR:-$(pwd)}"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"
cd "$COMPOSE_DIR"

docker compose exec -T db pg_dump -U timesheet -d timesheet | gzip > "$BACKUP_DIR/timesheet-$STAMP.sql.gz"
find "$BACKUP_DIR" -name 'timesheet-*.sql.gz' -type f -mtime +"$RETENTION_DAYS" -delete
