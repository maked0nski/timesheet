import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/clients_repository.dart';
import '../../data/repositories/data_repository.dart';
import '../../data/repositories/entries_repository.dart';
import '../../data/repositories/finance_repository.dart';
import '../../data/repositories/projects_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final clientsRepositoryProvider = Provider<ClientsRepository>((ref) {
  return ClientsRepository(ref.watch(appDatabaseProvider));
});

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository(ref.watch(appDatabaseProvider));
});

final entriesRepositoryProvider = Provider<EntriesRepository>((ref) {
  return EntriesRepository(ref.watch(appDatabaseProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(entriesRepositoryProvider));
});

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  return DataRepository(ref.watch(appDatabaseProvider));
});

final selectedClientFilterProvider = StateProvider<int?>((_) => null);
final selectedProjectFilterProvider = StateProvider<int?>((_) => null);
final selectedFromDateProvider = StateProvider<DateTime?>((_) => null);
final selectedToDateProvider = StateProvider<DateTime?>((_) => null);

final entriesFilterProvider = Provider<EntriesFilter>((ref) {
  return EntriesFilter(
    clientId: ref.watch(selectedClientFilterProvider),
    projectId: ref.watch(selectedProjectFilterProvider),
    from: ref.watch(selectedFromDateProvider),
    to: ref.watch(selectedToDateProvider),
  );
});

final clientsProvider = StreamProvider((ref) {
  return ref.watch(clientsRepositoryProvider).watch();
});

final projectsProvider = StreamProvider((ref) {
  return ref.watch(projectsRepositoryProvider).watch();
});

final entriesProvider = StreamProvider((ref) {
  final filter = ref.watch(entriesFilterProvider);
  return ref.watch(entriesRepositoryProvider).watchFiltered(filter);
});

final dashboardProvider = StreamProvider((ref) {
  final filter = ref.watch(entriesFilterProvider);
  return ref.watch(dashboardRepositoryProvider).watchFiltered(filter);
});

final settingsProvider = StreamProvider((ref) {
  return ref.watch(settingsRepositoryProvider).watchAll();
});

final expensesProvider = StreamProvider((ref) {
  return ref.watch(financeRepositoryProvider).watchExpenses();
});

final mileageProvider = StreamProvider((ref) {
  return ref.watch(financeRepositoryProvider).watchMileages();
});

final selectedMonthProvider = StateProvider<DateTime>((_) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final selectedCalendarDayProvider = StateProvider<DateTime?>((_) => null);

final calendarDaysProvider = StreamProvider((ref) {
  final month = ref.watch(selectedMonthProvider);
  final filter = ref.watch(entriesFilterProvider);
  return ref.watch(entriesRepositoryProvider).watchCalendarMonth(
        year: month.year,
        month: month.month,
        filter: filter,
      );
});

final calendarWeeksProvider = StreamProvider((ref) {
  final month = ref.watch(selectedMonthProvider);
  final filter = ref.watch(entriesFilterProvider);
  return ref.watch(entriesRepositoryProvider).watchCalendarWeekTotals(
        year: month.year,
        month: month.month,
        filter: filter,
      );
});

final calendarDayEntriesProvider = StreamProvider((ref) {
  final day = ref.watch(selectedCalendarDayProvider);
  if (day == null) {
    return Stream.value(const <TimeEntry>[]);
  }
  final filter = ref.watch(entriesFilterProvider);
  return ref.watch(entriesRepositoryProvider).watchEntriesByDay(
        day: day,
        filter: filter,
      );
});
