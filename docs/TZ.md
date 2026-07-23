# Timesheet Mobile App - Technical Specification (TZ)

## 1. Project Goal
Build a cross-platform mobile app (Android/iOS) for tracking work time, clients, projects, rates, payments, and debt analytics.

## 2. Product Scope
- Client management (CRUD, contact and billing metadata).
- Project management (CRUD, billing type/rates, defaults, budget).
- Time logging (start/end, break, status, tags, notes, billable/paid flags).
- Calendar view (monthly grid, daily totals, weekly totals, paid/unpaid highlighting).
- Finance dashboard (hours, amounts, unpaid debt, uninvoiced amount, effective rate).
- Backup/sync (MVP: manual backup/restore, post-MVP: scheduled sync).

### 2.1 Current Build Notes (2026-02-25)
- Main start modules implemented: Time, Calendar, Clients, Projects, Statistics, Settings.
- `Data/Database` module now supports local SQLite backup/restore flow (`backups` folder in app documents).
- Time entry status simplified to two values: `open` and `paid`.
- Status color coding is applied in Time list and Calendar:
  - `open` -> yellow
  - `paid` -> green
  - mixed day -> cyan
- Invoice module removed from active app flow and schema migration `v6`.
- Added `expenses` and `mileages` tables with add-entry flow from time form.

## 3. Target Platforms
- Android 10+
- iOS 15+

## 4. Recommended Stack
- UI: Flutter
- State management: Riverpod
- Local DB: SQLite (via Drift)
- Date/time + locale: intl + timezone
- Charts: fl_chart
- Sync: Google Drive (Android), iCloud (iOS)

## 5. Functional Requirements

### 5.1 Clients
Fields:
- `name` (required)
- `address_line_1`
- `address_line_2`
- `address_line_3`
- `phone`
- `fax`
- `email`
- `website`
- `tax_id`
- `description`
- `is_default_client`
- `is_active`

Actions:
- Create, update, archive, list, search.

### 5.2 Projects
Fields:
- `name` (required)
- `client_id` (nullable, means all clients/default)
- `description`
- `tag`
- `default_start_time`
- `default_end_time`
- `default_break_minutes`
- `rounding_rule`
- `billing_type` (`hourly` or `fixed`)
- `hourly_rate`
- `fixed_rate`
- `overtime_enabled`, `overtime_after_minutes`, `overtime_multiplier`
- `night_enabled`, `night_start_time`, `night_end_time`, `night_multiplier`
- `holiday_enabled`, `holiday_multiplier`
- `is_billable_default`
- `budget_mode` (`none`, `hours`, `fees`)
- `budget_hours_limit`
- `budget_fees_limit`
- `is_active`

Actions:
- Create, update, archive, list, filter by client/tag/status.

### 5.3 Time Entries
Fields:
- `project_id` (required)
- `client_id` (auto from project, editable)
- `start_at` (required)
- `end_at` (required)
- `break_minutes`
- `worked_minutes` (derived)
- `applied_rate`
- `amount` (derived)
- `task_description`
- `note`
- `status` (`open`, `paid`)
- `tag`
- `is_billable`
- `is_paid`

Actions:
- Create/edit/delete entry.
- Save and create next entry.
- Save and finish.

Validation:
- `end_at > start_at`
- `break_minutes >= 0`
- `worked_minutes > 0`

### 5.4 Calendar
- Monthly grid with day totals (`hours`, `amount`).
- Week-side summary (`hours`, `amount`).
- Highlight paid/unpaid (green/yellow).
- Drill-down per day to entries.
- Filters: client/project/tag/status.

### 5.5 Dashboard / Analytics
Must show for selected period/filter:
- Hours: total, paid, unpaid.
- Amount: total, paid, unpaid.
- Income blocks: work, expenses, mileage.
- Pending blocks: paid, unpaid, pending.
- Effective hourly rate.

Formulas:
- `worked_minutes = end_at - start_at - break_minutes`
- Hourly amount: `worked_hours * applied_rate`
- Fixed amount: `fixed_rate`
- Effective hourly rate: `(work_income - expenses - mileage) / total_hours`

Rate priority (default):
1. Holiday
2. Night
3. Overtime
4. Base

## 6. Non-Functional Requirements
- Offline-first.
- DB migration support.
- Startup < 2 sec on mid-range device.
- Calendar load < 1 sec for 10k entries.
- Localization: Ukrainian + English.
- Currency configurable (default GBP).
- Timezone-safe datetime handling.

## 7. Data Model
Core tables:
- `clients`
- `projects`
- `time_entries`
- `expenses`
- `mileages`
- `settings`
- `sync_log`

See SQL in `db/schema.sql`.

## 8. MVP Boundaries
In MVP include:
- Clients CRUD
- Projects CRUD with main rate rules
- Time logging
- Calendar totals
- Dashboard totals
- Manual backup/restore placeholder

Out of MVP:
- Team/multi-user
- Full invoice PDF generation
- Fully automatic conflict-aware sync

## 9. Acceptance Criteria (MVP)
- Client and project CRUD works without data corruption.
- Time entry calculations are correct for base hourly and fixed rate.
- Calendar shows correct daily and weekly totals.
- Dashboard paid/unpaid/uninvoiced values match source entries.
- Basic backup/restore pipeline exists and passes manual test.

## 10. Risks and Mitigations
- Complex pricing rules -> implement deterministic rule priority + unit tests.
- Sync conflicts -> start with manual backup, defer full sync conflict policy.
- Timezone errors -> store UTC timestamps + local offset metadata.

## 11. Open Questions
- Exact behavior when night + overtime + holiday overlap (sum/multiply/priority only).
- Fixed rate granularity (per entry / per day / per task).
- Partial payments support required in MVP?
- Required export formats (CSV/PDF/XLSX) and legal invoice fields.
- Mandatory holiday calendars (country-specific).
