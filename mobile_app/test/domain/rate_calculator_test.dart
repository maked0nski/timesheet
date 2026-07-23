import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/src/domain/rate_calculator.dart';

void main() {
  group('RateCalculator', () {
    const calculator = RateCalculator();

    test('calculates base hourly amount', () {
      final result = calculator.calculate(
        startAt: DateTime(2026, 1, 1, 9),
        endAt: DateTime(2026, 1, 1, 17),
        breakMinutes: 0,
        billingType: 'hourly',
        hourlyRate: 15,
        fixedRate: 0,
      );

      expect(result.workedMinutes, 480);
      expect(result.amount, 120);
    });

    test('applies overtime after threshold', () {
      final result = calculator.calculate(
        startAt: DateTime(2026, 1, 1, 9),
        endAt: DateTime(2026, 1, 1, 20),
        breakMinutes: 0,
        billingType: 'hourly',
        hourlyRate: 10,
        fixedRate: 0,
        rules: const RateRuleSet(
          overtimeEnabled: true,
          overtimeAfterMinutes: 480,
          overtimeMultiplier: 1.5,
          nightEnabled: false,
          nightStartMinute: 1320,
          nightEndMinute: 360,
          nightMultiplier: 1.25,
          holidayEnabled: false,
          holidayMultiplier: 2.0,
          isHoliday: false,
        ),
      );

      expect(result.workedMinutes, 660);
      expect(result.amount, 125);
    });

    test('applies night multiplier by priority over overtime', () {
      final result = calculator.calculate(
        startAt: DateTime(2026, 1, 1, 22),
        endAt: DateTime(2026, 1, 2, 7),
        breakMinutes: 0,
        billingType: 'hourly',
        hourlyRate: 20,
        fixedRate: 0,
        rules: const RateRuleSet(
          overtimeEnabled: true,
          overtimeAfterMinutes: 120,
          overtimeMultiplier: 1.5,
          nightEnabled: true,
          nightStartMinute: 1320,
          nightEndMinute: 360,
          nightMultiplier: 1.25,
          holidayEnabled: false,
          holidayMultiplier: 2.0,
          isHoliday: false,
        ),
      );

      expect(result.amount, 225);
      expect(result.appliedRate, 25);
    });

    test('applies holiday multiplier as highest priority', () {
      final result = calculator.calculate(
        startAt: DateTime(2026, 12, 25, 9),
        endAt: DateTime(2026, 12, 25, 17),
        breakMinutes: 0,
        billingType: 'hourly',
        hourlyRate: 30,
        fixedRate: 0,
        rules: const RateRuleSet(
          overtimeEnabled: true,
          overtimeAfterMinutes: 60,
          overtimeMultiplier: 3.0,
          nightEnabled: true,
          nightStartMinute: 1320,
          nightEndMinute: 360,
          nightMultiplier: 2.0,
          holidayEnabled: true,
          holidayMultiplier: 2.0,
          isHoliday: true,
        ),
      );

      expect(result.amount, 480);
      expect(result.appliedRate, 60);
    });
  });
}
