# DB Quick Start

## Prerequisites
- SQLite CLI (`sqlite3`) installed.

## Initialize database
```bash
sqlite3 timesheet.db ".read db/schema.sql"
```

## Seed demo data
```bash
sqlite3 timesheet.db ".read db/seeds/001_demo.sql"
```

## Example analytics run
```bash
sqlite3 timesheet.db ".parameter init" \
  ".parameter set :from_iso '2026-02-01T00:00:00Z'" \
  ".parameter set :to_iso '2026-03-01T00:00:00Z'" \
  ".parameter set :client_id NULL" \
  ".parameter set :project_id NULL" \
  ".read db/queries/analytics.sql"
```

## Notes
- Timestamps in schema are stored in ISO-8601 text format.
- App layer should use UTC in persistence and convert in UI.
