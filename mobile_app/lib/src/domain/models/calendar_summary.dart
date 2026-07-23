class CalendarDaySummary {
  const CalendarDaySummary({
    required this.day,
    required this.totalMinutes,
    required this.totalAmount,
    required this.paidAmount,
    required this.unpaidAmount,
  });

  final DateTime day;
  final int totalMinutes;
  final double totalAmount;
  final double paidAmount;
  final double unpaidAmount;
}

class CalendarWeekSummary {
  const CalendarWeekSummary({
    required this.weekStart,
    required this.totalMinutes,
    required this.totalAmount,
  });

  final DateTime weekStart;
  final int totalMinutes;
  final double totalAmount;
}
