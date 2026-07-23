import '../../domain/models/calendar_summary.dart';
import '../db/app_database.dart';

class EntriesFilter {
  const EntriesFilter({
    this.clientId,
    this.projectId,
    this.from,
    this.to,
  });

  final int? clientId;
  final int? projectId;
  final DateTime? from;
  final DateTime? to;

  bool match(TimeEntry entry) {
    if (clientId != null && entry.clientId != clientId) return false;
    if (projectId != null && entry.projectId != projectId) return false;
    if (from != null && entry.startAt.isBefore(from!)) return false;
    if (to != null && entry.startAt.isAfter(to!)) return false;
    return true;
  }
}

class EntriesRepository {
  const EntriesRepository(this._db);

  final AppDatabase _db;

  Stream<List<TimeEntry>> watch() => _db.watchEntries();

  Stream<List<TimeEntry>> watchFiltered(EntriesFilter filter) {
    return watch().map((entries) => entries.where(filter.match).toList());
  }

  Stream<List<TimeEntry>> watchEntriesByDay({
    required DateTime day,
    required EntriesFilter filter,
  }) {
    return watchFiltered(filter).map(
      (entries) => entries
          .where(
            (e) => e.startAt.year == day.year && e.startAt.month == day.month && e.startAt.day == day.day,
          )
          .toList()
        ..sort((a, b) => a.startAt.compareTo(b.startAt)),
    );
  }

  Future<void> create(TimeEntriesCompanion entry) async {
    await _db.addTimeEntry(entry);
  }

  Future<void> update(TimeEntry entry, TimeEntriesCompanion patch) async {
    await _db.updateTimeEntry(entry, patch);
  }

  Future<void> delete(int id) async {
    await _db.deleteTimeEntry(id);
  }

  Future<void> markPaid(List<int> ids) async {
    await _db.markEntriesPaid(ids, isPaid: true);
  }

  Stream<List<CalendarDaySummary>> watchCalendarMonth({
    required int year,
    required int month,
    required EntriesFilter filter,
  }) {
    return watchFiltered(filter).map((entries) {
      final dayMap = <DateTime, _Accumulator>{};

      for (final entry in entries) {
        if (entry.startAt.year != year || entry.startAt.month != month) {
          continue;
        }
        final day = DateTime(entry.startAt.year, entry.startAt.month, entry.startAt.day);
        final acc = dayMap.putIfAbsent(day, () => _Accumulator());
        acc.totalMinutes += entry.workedMinutes;
        acc.totalAmount += entry.amount;
        if (entry.isPaid) {
          acc.paidAmount += entry.amount;
        } else if (entry.isBillable) {
          acc.unpaidAmount += entry.amount;
        }
      }

      final days = dayMap.entries
          .map(
            (e) => CalendarDaySummary(
              day: e.key,
              totalMinutes: e.value.totalMinutes,
              totalAmount: e.value.totalAmount,
              paidAmount: e.value.paidAmount,
              unpaidAmount: e.value.unpaidAmount,
            ),
          )
          .toList()
        ..sort((a, b) => a.day.compareTo(b.day));

      return days;
    });
  }

  Stream<List<CalendarWeekSummary>> watchCalendarWeekTotals({
    required int year,
    required int month,
    required EntriesFilter filter,
  }) {
    return watchCalendarMonth(year: year, month: month, filter: filter).map((days) {
      final weekMap = <DateTime, _Accumulator>{};
      for (final day in days) {
        final weekStart = _mondayOf(day.day);
        final acc = weekMap.putIfAbsent(weekStart, () => _Accumulator());
        acc.totalMinutes += day.totalMinutes;
        acc.totalAmount += day.totalAmount;
      }

      final weeks = weekMap.entries
          .map(
            (e) => CalendarWeekSummary(
              weekStart: e.key,
              totalMinutes: e.value.totalMinutes,
              totalAmount: e.value.totalAmount,
            ),
          )
          .toList()
        ..sort((a, b) => a.weekStart.compareTo(b.weekStart));

      return weeks;
    });
  }

  DateTime _mondayOf(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return normalized.subtract(Duration(days: normalized.weekday - DateTime.monday));
  }
}

class DashboardRepository {
  const DashboardRepository(this._entriesRepository);

  final EntriesRepository _entriesRepository;

  Stream<DashboardSummary> watchFiltered(EntriesFilter filter) {
    return _entriesRepository.watchFiltered(filter).map((entries) {
      var totalMinutes = 0;
      var paidMinutes = 0;
      var unpaidMinutes = 0;
      var totalAmount = 0.0;
      var paidAmount = 0.0;
      var unpaidAmount = 0.0;
      var pendingAmount = 0.0;

      for (final entry in entries) {
        totalMinutes += entry.workedMinutes;
        totalAmount += entry.amount;

        if (entry.isPaid) {
          paidMinutes += entry.workedMinutes;
          paidAmount += entry.amount;
        } else if (entry.isBillable) {
          unpaidMinutes += entry.workedMinutes;
          unpaidAmount += entry.amount;
        }

        if (entry.isBillable && !entry.isPaid) {
          pendingAmount += entry.amount;
        }
      }

      return DashboardSummary(
        totalMinutes: totalMinutes,
        paidMinutes: paidMinutes,
        unpaidMinutes: unpaidMinutes,
        totalAmount: totalAmount,
        paidAmount: paidAmount,
        unpaidAmount: unpaidAmount,
        uninvoicedAmount: pendingAmount,
      );
    });
  }
}

class _Accumulator {
  int totalMinutes = 0;
  double totalAmount = 0;
  double paidAmount = 0;
  double unpaidAmount = 0;
}
