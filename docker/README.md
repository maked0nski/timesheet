# Timesheet Web Docker

Самодостатня веб-версія Timesheet з логіном/паролем, PostgreSQL і Docker Compose.

## Запуск

1. Відредагуйте `docker-compose.yml`:
   - `SESSION_SECRET` замініть на довгий випадковий рядок.
   - `ADMIN_USERNAME` і `ADMIN_PASSWORD` задайте для першого входу.
   - `POSTGRES_PASSWORD` і пароль у `DATABASE_URL` мають збігатися.

2. Запустіть:

```powershell
cd D:\projects\timesheet\docker
docker compose up -d --build
```

3. Відкрийте:

```text
http://localhost:3000
```

Перший користувач створюється автоматично з `ADMIN_USERNAME` / `ADMIN_PASSWORD`, якщо його ще немає в БД.

## Дані

PostgreSQL зберігає дані у Docker volume `timesheet_pgdata`. Видалення контейнерів не видаляє дані, але видалення volume видалить всю базу.

## HTTP та HTTPS

У `docker-compose.yml` встановлено `FORCE_INSECURE_COOKIE=1`, щоб логін працював на локальному `http://localhost:3000`.

Для публічного сервера краще поставити reverse proxy з HTTPS, наприклад Caddy, Nginx або Traefik. Після цього можна прибрати `FORCE_INSECURE_COOKIE=1`, щоб cookie працювала тільки через HTTPS.

## Що реалізовано

- Авторизація login/password через server-side session.
- PostgreSQL schema migration при старті.
- Клієнти: створення, список, архівація.
- Проєкти: створення, список, архівація.
- Time entries: створення, список, paid/open, видалення.
- Dashboard totals: години, загальна сума, оплачено, борг, витрати, mileage.
- Витрати і mileage: створення та список.

## Обмеження поточного MVP

- Немає редагування записів через UI, тільки створення/архівація/видалення.
- Немає імпорту з локальної Flutter SQLite БД.
- Немає ролей і багатокористувацького адмін-екрана.
- Розрахунок ставки поки базовий: hourly або fixed. Overtime/night/holiday можна перенести наступним кроком з Flutter `RateCalculator`.

## Корисні команди

```powershell
docker compose logs -f app
docker compose logs -f db
docker compose down
docker compose down -v
```

`docker compose down -v` видаляє volume з базою даних.
