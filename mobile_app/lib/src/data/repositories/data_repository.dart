import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';

class DataRepository {
  const DataRepository(this._db);

  final AppDatabase _db;

  Future<File> createBackup() async {
    final dbFile = await _db.resolveDatabaseFile();
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'backups'));
    if (!backupDir.existsSync()) {
      backupDir.createSync(recursive: true);
    }
    final name = 'timesheet-backup-${DateTime.now().millisecondsSinceEpoch}.sqlite';
    final out = File(p.join(backupDir.path, name));
    return dbFile.copy(out.path);
  }

  Future<File?> restoreLatestBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'backups'));
    if (!backupDir.existsSync()) return null;
    final backups = backupDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.sqlite'))
        .toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    if (backups.isEmpty) return null;

    final dbFile = await _db.resolveDatabaseFile();
    await _db.close();
    return backups.first.copy(dbFile.path);
  }

  Future<File> restoreBackup(File backup) async {
    final dbFile = await _db.resolveDatabaseFile();
    await _db.close();
    return backup.copy(dbFile.path);
  }

  Future<Directory> backupsDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'backups'));
    if (!backupDir.existsSync()) {
      backupDir.createSync(recursive: true);
    }
    return backupDir;
  }

  Future<void> clearAllData() => _db.clearAllData();
}
