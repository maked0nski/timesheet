# PostgreSQL backups

Create a backup:

```sh
cd /home/maked0nski/timesheet/docker
sh scripts/backup-postgres.sh
```

Recommended daily cron:

```cron
15 3 * * * cd /home/maked0nski/timesheet/docker && BACKUP_DIR=/home/maked0nski/timesheet/backups sh scripts/backup-postgres.sh
```

Restore from a backup:

```sh
cd /home/maked0nski/timesheet/docker
sh scripts/restore-postgres.sh /home/maked0nski/timesheet/backups/timesheet-YYYYMMDD-HHMMSS.sql.gz
```
