# Deploy

Images are built and published to GHCR by `.github/workflows/docker-publish.yml`
on every push to `master`, then a Watchtower webhook (`WATCHTOWER_TOKEN` repo
secret) tells the server to pull and restart. The server never builds anything
locally — see `docker/docker-compose.prod.yml`.

## GitHub Actions secrets (repo settings → Secrets and variables → Actions)

Only one is needed — CI never touches runtime secrets, only build + push +
trigger:

- `WATCHTOWER_TOKEN` — bearer token for `POST https://deploy.yermakov.pp.ua/v1/update`

## Server-side files (not in git)

Deploy directory: `/home/maked0nski/timesheet/docker`.

**`.env`** (read by `app` via `env_file`, and by `db` via explicit `environment:`):
- `DATABASE_URL`
- `SESSION_SECRET`
- `ADMIN_USERNAME`
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`
- `PUBLIC_APP_URL`
- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_SECURE`
- `SMTP_USER`
- `SMTP_PASS`
- `SMTP_FROM`
- `POSTGRES_PASSWORD`

## Secrets backup

An encrypted snapshot of the file above lives outside this repo, at
`D:\projects\_secrets_backup\timesheet_env_<date>.tar.gz.gpg`
(AES-256, passphrase in the owner's password manager — never in git).
