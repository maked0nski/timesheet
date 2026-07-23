import '../db/app_database.dart';

class ProjectsRepository {
  const ProjectsRepository(this._db);

  final AppDatabase _db;

  Stream<List<Project>> watch({bool includeArchived = false}) {
    return _db.watchProjects(includeArchived: includeArchived);
  }

  Future<void> create({
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
  }) async {
    await _db.addProject(
      name: name,
      clientId: clientId,
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
    );
  }

  Future<void> update(
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
  }) async {
    await _db.updateProject(
      project,
      name: name,
      clientId: clientId,
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
    );
  }

  Future<void> archive(int id) async {
    await _db.archiveProject(id);
  }

  Future<void> delete(int id) async {
    await _db.deleteProject(id);
  }

  Future<List<Project>> activeList() => _db.getActiveProjects();
}
