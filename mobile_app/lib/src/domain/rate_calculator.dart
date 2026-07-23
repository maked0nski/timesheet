class RateRuleSet {
  const RateRuleSet({
    required this.overtimeEnabled,
    required this.overtimeAfterMinutes,
    required this.overtimeMultiplier,
    required this.nightEnabled,
    required this.nightStartMinute,
    required this.nightEndMinute,
    required this.nightMultiplier,
    required this.holidayEnabled,
    required this.holidayMultiplier,
    required this.isHoliday,
  });

  final bool overtimeEnabled;
  final int overtimeAfterMinutes;
  final double overtimeMultiplier;
  final bool nightEnabled;
  final int nightStartMinute;
  final int nightEndMinute;
  final double nightMultiplier;
  final bool holidayEnabled;
  final double holidayMultiplier;
  final bool isHoliday;

  static const defaults = RateRuleSet(
    overtimeEnabled: false,
    overtimeAfterMinutes: 480,
    overtimeMultiplier: 1.5,
    nightEnabled: false,
    nightStartMinute: 1320,
    nightEndMinute: 360,
    nightMultiplier: 1.25,
    holidayEnabled: false,
    holidayMultiplier: 2.0,
    isHoliday: false,
  );
}

class RateCalculationResult {
  const RateCalculationResult({
    required this.workedMinutes,
    required this.appliedRate,
    required this.amount,
  });

  final int workedMinutes;
  final double appliedRate;
  final double amount;
}

class RateCalculator {
  const RateCalculator();

  RateCalculationResult calculate({
    required DateTime startAt,
    required DateTime endAt,
    required int breakMinutes,
    required String billingType,
    required double hourlyRate,
    required double fixedRate,
    RateRuleSet rules = RateRuleSet.defaults,
  }) {
    final totalMinutes = endAt.difference(startAt).inMinutes;
    final workedMinutes = totalMinutes - breakMinutes;
    if (workedMinutes <= 0) {
      throw ArgumentError('Worked minutes must be positive.');
    }

    if (billingType == 'fixed') {
      return RateCalculationResult(
        workedMinutes: workedMinutes,
        appliedRate: fixedRate,
        amount: fixedRate,
      );
    }

    if (rules.holidayEnabled && rules.isHoliday) {
      final rate = hourlyRate * rules.holidayMultiplier;
      return RateCalculationResult(
        workedMinutes: workedMinutes,
        appliedRate: rate,
        amount: (workedMinutes / 60) * rate,
      );
    }

    if (rules.nightEnabled && _intersectsNight(startAt, endAt, rules.nightStartMinute, rules.nightEndMinute)) {
      final rate = hourlyRate * rules.nightMultiplier;
      return RateCalculationResult(
        workedMinutes: workedMinutes,
        appliedRate: rate,
        amount: (workedMinutes / 60) * rate,
      );
    }

    if (rules.overtimeEnabled && workedMinutes > rules.overtimeAfterMinutes) {
      final regularMinutes = rules.overtimeAfterMinutes;
      final overtimeMinutes = workedMinutes - regularMinutes;
      final regularAmount = (regularMinutes / 60) * hourlyRate;
      final overtimeAmount = (overtimeMinutes / 60) * hourlyRate * rules.overtimeMultiplier;
      return RateCalculationResult(
        workedMinutes: workedMinutes,
        appliedRate: hourlyRate,
        amount: regularAmount + overtimeAmount,
      );
    }

    return RateCalculationResult(
      workedMinutes: workedMinutes,
      appliedRate: hourlyRate,
      amount: (workedMinutes / 60) * hourlyRate,
    );
  }

  bool _intersectsNight(DateTime startAt, DateTime endAt, int nightStartMinute, int nightEndMinute) {
    final startM = startAt.hour * 60 + startAt.minute;
    final endM = endAt.hour * 60 + endAt.minute;

    if (nightStartMinute < nightEndMinute) {
      return (startM < nightEndMinute && endM > nightStartMinute);
    }

    final inLateNight = startM >= nightStartMinute || endM >= nightStartMinute;
    final inEarlyNight = startM < nightEndMinute || endM <= nightEndMinute;
    return inLateNight || inEarlyNight;
  }
}
