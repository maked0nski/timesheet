# TODO - Timesheet

## Phase 0 - Foundation
- [x] Prepare full technical specification (`docs/TZ.md`)
- [x] Define initial DB schema (`db/schema.sql`)
- [x] Create first migration (`db/migrations/001_init.sql`)
- [x] Add demo seed (`db/seeds/001_demo.sql`)
- [x] Add analytics queries (`db/queries/analytics.sql`)
- [ ] Confirm open business rules from `docs/TZ.md` section 11

## Phase 1 - Flutter Project Bootstrap
- [x] Initialize Flutter project (`mobile_app`)
- [ ] Configure lints, flavors, env config
- [x] Add core packages (riverpod, drift, sqlite, intl)
- [x] Implement app routing shell + theme + localization skeleton

## Phase 2 - Data Layer
- [x] Implement Drift database and DAOs for core tables
- [x] Add DB migration for settings persistence (`schemaVersion 5`, `app_settings`)
- [x] Add DB migration `schemaVersion 6` (drop invoices, remove `invoice_id`, add `expenses`/`mileages`)
- [x] Add repository interfaces + implementations
- [ ] Add unit tests for repositories

## Phase 3 - Domain Logic
- [x] Implement rate engine (base/overtime/night/holiday/fixed)
- [x] Implement time-entry calculator service
- [x] Implement dashboard aggregation service
- [x] Add deterministic unit tests for formulas

## Phase 4 - Features (MVP)
- [x] Clients list/create/edit/archive/delete screens
- [x] Projects list/create/edit/archive/delete screens
- [x] Add Time screen with validation and quick-save actions + edit/delete
- [x] Calendar monthly screen + day details + weekly totals + repeat-tap to add entry
- [x] Statistics screen (histogram/line/pie, Hour/Amount toggle, period switch)
- [x] Settings screen with top tabs (General/Time/Invoice/Preferences/App)
- [x] Data screen (Database backup/restore UI flow) instead of placeholder
- [x] Time-entry status narrowed to `open` / `paid` with status colors in Time + Calendar
- [x] Expense/Mileage add actions from time form
- [x] Dashboard with paid/unpaid widgets (uninvoiced pending)

## Phase 5 - Backup & Sync (MVP)
- [x] Implement manual local backup/restore for SQLite file
- [ ] Integrate Google Drive backup (Android)
- [ ] Integrate iCloud backup (iOS)
- [ ] Add backup restore smoke tests

## Phase 6 - Quality
- [ ] Unit tests for calculation and aggregation (>80% critical logic)
- [ ] Integration tests for CRUD and calendar aggregates
- [x] Widget test for statistics menu flow
- [ ] Performance pass on 10k+ entries dataset
- [ ] Beta build (internal testing)

## Immediate Next Actions
- [x] Install Flutter/Dart SDK in environment
- [x] Create `mobile_app` and wire DB schema to Drift
- [x] Implement first usable flow: Client -> Project -> Time Entry
- [x] Remove invoice module from active app flow (UI/repositories/providers)
- [x] Persist settings values to DB (`app_settings` table)
- [x] Remove invoice table/columns from DB schema in migration `v6`
- [ ] Final pass for pixel-perfect parity with reference screenshots (statistics charts still need visual fine-tuning)
