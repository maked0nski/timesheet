import '../db/app_database.dart';

class FinanceRepository {
  const FinanceRepository(this._db);

  final AppDatabase _db;

  Stream<List<Expense>> watchExpenses() => _db.watchExpenses();
  Stream<List<Mileage>> watchMileages() => _db.watchMileages();

  Future<void> addExpense({
    required DateTime occurredAt,
    required double amount,
    String? note,
  }) async {
    await _db.addExpense(occurredAt: occurredAt, amount: amount, note: note);
  }

  Future<void> addMileage({
    required DateTime occurredAt,
    required double distance,
    required double amount,
    String? note,
  }) async {
    await _db.addMileage(
      occurredAt: occurredAt,
      distance: distance,
      amount: amount,
      note: note,
    );
  }
}
