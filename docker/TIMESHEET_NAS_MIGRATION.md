# Timesheet NAS migration

Project path on NAS:

```text
/volume1/docker/timesheet
```

Database dump included:

```text
timesheet_backup_20260607-183419.sql
```

Run:

```bash
cd /volume1/docker/timesheet
docker compose up -d db
# wait until db is healthy
docker compose exec -T db psql -U timesheet -d timesheet < timesheet_backup_20260607-183419.sql
docker compose up -d --build
```

Open:

```text
http://NAS_IP:3000
```
