import '../db/app_database.dart';

class SettingsRepository {
  const SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<Map<String, String>> watchAll() {
    return _db.watchSettings().map((rows) {
      final map = <String, String>{};
      for (final row in rows) {
        map[row.key] = row.value ?? '';
      }
      return map;
    });
  }

  Future<String?> get(String key) => _db.getSetting(key);

  Future<void> set(String key, String value) => _db.setSetting(key, value);

  Future<void> setBool(String key, bool value) => set(key, value ? '1' : '0');
}
