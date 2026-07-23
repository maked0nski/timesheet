import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get geolocation => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isDefaultClient => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().nullable().references(Clients, #id)();
  TextColumn get name => text()();
  TextColumn get billingType => text().withDefault(const Constant('hourly'))();
  RealColumn get hourlyRate => real().withDefault(const Constant(0))();
  RealColumn get fixedRate => real().withDefault(const Constant(0))();
  IntColumn get defaultBreakMinutes => integer().withDefault(const Constant(0))();
  BoolColumn get overtimeEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get overtimeAfterMinutes => integer().withDefault(const Constant(480))();
  RealColumn get overtimeMultiplier => real().withDefault(const Constant(1.5))();
  BoolColumn get nightEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get nightStartMinute => integer().withDefault(const Constant(1320))();
  IntColumn get nightEndMinute => integer().withDefault(const Constant(360))();
  RealColumn get nightMultiplier => real().withDefault(const Constant(1.25))();
  BoolColumn get holidayEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get holidayMultiplier => real().withDefault(const Constant(2.0))();
  BoolColumn get isBillableDefault => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TimeEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  IntColumn get clientId => integer().nullable().references(Clients, #id)();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  IntColumn get workedMinutes => integer()();
  RealColumn get appliedRate => real()();
  RealColumn get amount => real()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  BoolColumn get isBillable => boolean().withDefault(const Constant(true))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  TextColumn get taskDescription => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get occurredAt => dateTime()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Mileages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get occurredAt => dateTime()();
  RealColumn get distance => real().withDefault(const Constant(0))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalMinutes,
    required this.paidMinutes,
    required this.unpaidMinutes,
    required this.totalAmount,
    required this.paidAmount,
    required this.unpaidAmount,
    required this.uninvoicedAmount,
  });

  final int totalMinutes;
  final int paidMinutes;
  final int unpaidMinutes;
  final double totalAmount;
  final double paidAmount;
  final double unpaidAmount;
  final double uninvoicedAmount;

  String get totalHoursLabel => _formatMinutes(totalMinutes);
  String get paidHoursLabel => _formatMinutes(paidMinutes);
  String get unpaidHoursLabel => _formatMinutes(unpaidMinutes);

  static String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '$h:${m.toString().padLeft(2, '0')}';
  }
}

@DriftDatabase(tables: [Clients, Projects, TimeEntries, Expenses, Mileages, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await customStatement('ALTER TABLE time_entries ADD COLUMN invoice_id INTEGER');
          }
          if (from < 3) {
            await customStatement('''
              CREATE TABLE IF NOT EXISTS invoices (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                client_id INTEGER NULL REFERENCES clients(id),
                invoice_number TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'draft',
                total_amount REAL NOT NULL DEFAULT 0,
                issued_at INTEGER NOT NULL,
                due_at INTEGER NULL,
                paid_at INTEGER NULL,
                note TEXT NULL
              )
            ''');
          }
          if (from < 4) {
            await customStatement('ALTER TABLE clients ADD COLUMN address TEXT');
            await customStatement('ALTER TABLE clients ADD COLUMN geolocation TEXT');
            await customStatement('ALTER TABLE clients ADD COLUMN phone TEXT');
            await customStatement('ALTER TABLE clients ADD COLUMN email TEXT');
          }
          if (from < 5) {
            await migrator.createTable(appSettings);
          }
          if (from < 6) {
            await migrator.createTable(expenses);
            await migrator.createTable(mileages);

            await customStatement('PRAGMA foreign_keys = OFF');
            await customStatement('''
              CREATE TABLE time_entries_new (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                project_id INTEGER NOT NULL REFERENCES projects(id),
                client_id INTEGER NULL REFERENCES clients(id),
                start_at INTEGER NOT NULL,
                end_at INTEGER NOT NULL,
                break_minutes INTEGER NOT NULL DEFAULT 0,
                worked_minutes INTEGER NOT NULL,
                applied_rate REAL NOT NULL,
                amount REAL NOT NULL,
                status TEXT NOT NULL DEFAULT 'open',
                is_billable INTEGER NOT NULL DEFAULT 1,
                is_paid INTEGER NOT NULL DEFAULT 0,
                task_description TEXT NULL,
                created_at INTEGER NOT NULL
              )
            ''');
            await customStatement('''
              INSERT INTO time_entries_new (
                id, project_id, client_id, start_at, end_at, break_minutes, worked_minutes,
                applied_rate, amount, status, is_billable, is_paid, task_description, created_at
              )
              SELECT
                id, project_id, client_id, start_at, end_at, break_minutes, worked_minutes,
                applied_rate, amount,
                CASE WHEN status IN ('invoiced', 'paid') THEN 'paid' ELSE status END,
                is_billable,
                CASE WHEN is_paid = 1 OR status IN ('invoiced', 'paid') THEN 1 ELSE 0 END,
                task_description, created_at
              FROM time_entries
            ''');
            await customStatement('DROP TABLE time_entries');
            await customStatement('ALTER TABLE time_entries_new RENAME TO time_entries');
            await customStatement('DROP TABLE IF EXISTS invoices');
            await customStatement('PRAGMA foreign_keys = ON');
          }
        },
      );

  Stream<List<Client>> watchClients({bool includeArchived = false}) {
    final query = select(clients);
    if (!includeArchived) {
      query.where((tbl) => tbl.isActive.equals(true));
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.watch();
  }

  Future<List<Client>> getActiveClients() {
    return (select(clients)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<int> addClient({
    required String name,
    String? address,
    String? geolocation,
    String? phone,
    String? email,
    String? description,
  }) {
    return into(clients).insert(
      ClientsCompanion.insert(
        name: name,
        address: Value(address),
        geolocation: Value(geolocation),
        phone: Value(phone),
        email: Value(email),
        description: Value(description),
      ),
    );
  }

  Future<bool> updateClient(
    Client client, {
    required String name,
    String? address,
    String? geolocation,
    String? phone,
    String? email,
    String? description,
  }) {
    return update(clients).replace(
      client.copyWith(
        name: name,
        address: Value(address),
        geolocation: Value(geolocation),
        phone: Value(phone),
        email: Value(email),
        description: Value(description),
      ),
    );
  }

  Future<int> archiveClient(int id) {
    return (update(clients)..where((tbl) => tbl.id.equals(id))).write(
      const ClientsCompanion(isActive: Value(false)),
    );
  }

  Future<int> deleteClient(int id) {
    return (delete(clients)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<Project>> watchProjects({bool includeArchived = false}) {
    final query = select(projects);
    if (!includeArchived) {
      query.where((tbl) => tbl.isActive.equals(true));
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.watch();
  }

  Future<List<Project>> getActiveProjects() {
    return (select(projects)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<int> addProject({
    required String name,
    required int? clientId,
    required String billingType,
    required double hourlyRate,
    required double fixedRate,
    required int defaultBreakMinutes,
    required bool isBillableDefault,
    required bool overtimeEnabled,
    required int overtimeAfterMinutes,
    required double overtimeMultiplier,
    required bool nightEnabled,
    required int nightStartMinute,
    required int nightEndMinute,
    required double nightMultiplier,
    required bool holidayEnabled,
    required double holidayMultiplier,
  }) {
    return into(projects).insert(
      ProjectsCompanion.insert(
        name: name,
        clientId: Value(clientId),
        billingType: Value(billingType),
        hourlyRate: Value(hourlyRate),
        fixedRate: Value(fixedRate),
        defaultBreakMinutes: Value(defaultBreakMinutes),
        isBillableDefault: Value(isBillableDefault),
        overtimeEnabled: Value(overtimeEnabled),
        overtimeAfterMinutes: Value(overtimeAfterMinutes),
        overtimeMultiplier: Value(overtimeMultiplier),
        nightEnabled: Value(nightEnabled),
        nightStartMinute: Value(nightStartMinute),
        nightEndMinute: Value(nightEndMinute),
        nightMultiplier: Value(nightMultiplier),
        holidayEnabled: Value(holidayEnabled),
        holidayMultiplier: Value(holidayMultiplier),
      ),
    );
  }

  Future<bool> updateProject(
    Project project, {
    required String name,
    required int? clientId,
    required String billingType,
    required double hourlyRate,
    required double fixedRate,
    required int defaultBreakMinutes,
    required bool isBillableDefault,
    required bool overtimeEnabled,
    required int overtimeAfterMinutes,
    required double overtimeMultiplier,
    required bool nightEnabled,
    required int nightStartMinute,
    required int nightEndMinute,
    required double nightMultiplier,
    required bool holidayEnabled,
    required double holidayMultiplier,
  }) {
    return update(projects).replace(
      project.copyWith(
        name: name,
        clientId: Value(clientId),
        billingType: billingType,
        hourlyRate: hourlyRate,
        fixedRate: fixedRate,
        defaultBreakMinutes: defaultBreakMinutes,
        isBillableDefault: isBillableDefault,
        overtimeEnabled: overtimeEnabled,
        overtimeAfterMinutes: overtimeAfterMinutes,
        overtimeMultiplier: overtimeMultiplier,
        nightEnabled: nightEnabled,
        nightStartMinute: nightStartMinute,
        nightEndMinute: nightEndMinute,
        nightMultiplier: nightMultiplier,
        holidayEnabled: holidayEnabled,
        holidayMultiplier: holidayMultiplier,
      ),
    );
  }

  Future<int> archiveProject(int id) {
    return (update(projects)..where((tbl) => tbl.id.equals(id))).write(
      const ProjectsCompanion(isActive: Value(false)),
    );
  }

  Future<int> deleteProject(int id) {
    return (delete(projects)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<TimeEntry>> watchEntries() {
    final query = select(timeEntries)..orderBy([(tbl) => OrderingTerm.desc(tbl.startAt)]);
    return query.watch();
  }

  Future<int> addTimeEntry(TimeEntriesCompanion entry) => into(timeEntries).insert(entry);

  Future<bool> updateTimeEntry(TimeEntry entry, TimeEntriesCompanion patch) {
    return (update(timeEntries)..where((tbl) => tbl.id.equals(entry.id))).write(patch).then((v) => v > 0);
  }

  Future<int> deleteTimeEntry(int id) {
    return (delete(timeEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> markEntriesPaid(List<int> ids, {required bool isPaid}) async {
    for (final id in ids) {
      await (update(timeEntries)..where((tbl) => tbl.id.equals(id))).write(
        TimeEntriesCompanion(
          isPaid: Value(isPaid),
          status: Value(isPaid ? 'paid' : 'open'),
        ),
      );
    }
  }

  Stream<List<Expense>> watchExpenses() {
    return (select(expenses)..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])).watch();
  }

  Stream<List<Mileage>> watchMileages() {
    return (select(mileages)..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])).watch();
  }

  Future<int> addExpense({
    required DateTime occurredAt,
    required double amount,
    String? note,
  }) {
    return into(expenses).insert(
      ExpensesCompanion.insert(
        occurredAt: occurredAt,
        amount: amount,
        note: Value(note),
      ),
    );
  }

  Future<int> addMileage({
    required DateTime occurredAt,
    required double distance,
    required double amount,
    String? note,
  }) {
    return into(mileages).insert(
      MileagesCompanion.insert(
        occurredAt: occurredAt,
        distance: Value(distance),
        amount: Value(amount),
        note: Value(note),
      ),
    );
  }

  Stream<DashboardSummary> watchDashboardSummary() {
    final totalMinutesExpr = timeEntries.workedMinutes.sum();
    final paidMinutesExpr = timeEntries.workedMinutes.sum(filter: timeEntries.isPaid.equals(true));
    final unpaidMinutesExpr =
        timeEntries.workedMinutes.sum(filter: timeEntries.isBillable.equals(true) & timeEntries.isPaid.equals(false));
    final totalAmountExpr = timeEntries.amount.sum();
    final paidAmountExpr = timeEntries.amount.sum(filter: timeEntries.isPaid.equals(true));
    final unpaidAmountExpr =
        timeEntries.amount.sum(filter: timeEntries.isBillable.equals(true) & timeEntries.isPaid.equals(false));
    final pendingExpr = timeEntries.amount.sum(filter: timeEntries.isBillable.equals(true) & timeEntries.isPaid.equals(false));

    final query = selectOnly(timeEntries)
      ..addColumns([
        totalMinutesExpr,
        paidMinutesExpr,
        unpaidMinutesExpr,
        totalAmountExpr,
        paidAmountExpr,
        unpaidAmountExpr,
        pendingExpr,
      ]);

    return query.watchSingle().map((row) {
      return DashboardSummary(
        totalMinutes: row.read(totalMinutesExpr) ?? 0,
        paidMinutes: row.read(paidMinutesExpr) ?? 0,
        unpaidMinutes: row.read(unpaidMinutesExpr) ?? 0,
        totalAmount: row.read(totalAmountExpr) ?? 0,
        paidAmount: row.read(paidAmountExpr) ?? 0,
        unpaidAmount: row.read(unpaidAmountExpr) ?? 0,
        uninvoicedAmount: row.read(pendingExpr) ?? 0,
      );
    });
  }

  Stream<List<AppSetting>> watchSettings() {
    return (select(appSettings)..orderBy([(t) => OrderingTerm.asc(t.key)])).watch();
  }

  Future<String?> getSetting(String settingKey) async {
    final row = await (select(appSettings)..where((t) => t.key.equals(settingKey))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String settingKey, String? settingValue) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        key: Value(settingKey),
        value: Value(settingValue),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearAllData() async {
    await delete(timeEntries).go();
    await delete(expenses).go();
    await delete(mileages).go();
    await delete(projects).go();
    await delete(clients).go();
  }

  Future<File> resolveDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'timesheet.sqlite'));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'timesheet.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
