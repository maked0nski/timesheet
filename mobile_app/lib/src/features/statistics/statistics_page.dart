import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../utils/formatters.dart';
import '../../theme/app_theme.dart';

enum _StatsType { histogram, line, pie, mileage }
enum _StatsPeriod { week, month, year }
enum _StatsMetric { hours, amount }

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(l10n.statsTitle),
      ),
      body: ListView(
        children: [
          _menuItem(
            context,
            title: l10n.statsHistogramTitle,
            subtitle: l10n.statsHistogramSubtitle,
            type: _StatsType.histogram,
          ),
          _menuItem(
            context,
            title: l10n.statsLineTitle,
            subtitle: l10n.statsLineSubtitle,
            type: _StatsType.line,
          ),
          _menuItem(
            context,
            title: l10n.statsPieTitle,
            subtitle: l10n.statsPieSubtitle,
            type: _StatsType.pie,
          ),
          _menuItem(
            context,
            title: l10n.statsMileageTitle,
            subtitle: l10n.statsMileageSubtitle,
            type: _StatsType.mileage,
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required _StatsType type,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => _StatisticsDetailsPage(initialType: type)),
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF252E40))),
        ),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).extension<AppColors>()!.mutedText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsDetailsPage extends ConsumerStatefulWidget {
  const _StatisticsDetailsPage({required this.initialType});

  final _StatsType initialType;

  @override
  ConsumerState<_StatisticsDetailsPage> createState() => _StatisticsDetailsPageState();
}

class _StatisticsDetailsPageState extends ConsumerState<_StatisticsDetailsPage> {
  late _StatsType _type;
  _StatsPeriod _period = _StatsPeriod.week;
  _StatsMetric _metric = _StatsMetric.hours;
  DateTime _anchor = DateTime.now();
  bool _showWork = true;
  bool _showOvertime = true;
  bool _showExpenses = false;
  bool _showMileage = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(entriesProvider);
    final expensesAsync = ref.watch(expensesProvider);
    final mileageAsync = ref.watch(mileageProvider);
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    final fmt = AppFormatters(
      locale: AppFormatters.localeFromSettings(settings),
      currencyCode: AppFormatters.currencyFromSettings(settings),
    );

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _typeMenu(),
            _periodMenu(),
          ],
        ),
        actions: [
          const Icon(Icons.filter_list),
          const SizedBox(width: 8),
          const Icon(Icons.view_list),
          const SizedBox(width: 8),
          IconButton(onPressed: _prev, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: _next, icon: const Icon(Icons.chevron_right)),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          final expenses = expensesAsync.valueOrNull ?? const <Expense>[];
          final mileages = mileageAsync.valueOrNull ?? const <Mileage>[];
          final range = _range(_anchor, _period);
          final visible = entries
              .where((e) => !e.startAt.isBefore(range.$1) && e.startAt.isBefore(range.$2))
              .toList();
          final visibleExpenses = expenses
              .where((e) => !e.occurredAt.isBefore(range.$1) && e.occurredAt.isBefore(range.$2))
              .toList();
          final visibleMileage = mileages
              .where((m) => !m.occurredAt.isBefore(range.$1) && m.occurredAt.isBefore(range.$2))
              .toList();
          final totalMinutes = visible.fold<int>(0, (s, e) => s + e.workedMinutes);
          final totalAmount = visible.fold<double>(0, (s, e) => s + e.amount) +
              visibleExpenses.fold<double>(0, (s, e) => s + e.amount) +
              visibleMileage.fold<double>(0, (s, m) => s + m.amount);
          final set = _seriesSet(
            visible,
            visibleExpenses,
            visibleMileage,
            range.$1,
            range.$2,
            _period,
            _metric,
          );
          final chart = _combineSeries(
            work: _showWork ? set.work : null,
            overtime: _showOvertime ? set.overtime : null,
            expenses: _showExpenses ? set.expenses : null,
            mileage: _showMileage ? set.mileage : null,
          );
          final xLabels = _xAxisLabels(range.$1, range.$2, _period);

          return Column(
            children: [
              Container(
                color: colors.surface2,
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(_rangeLabel(range.$1, range.$2, _period, l10n))),
                        Text(
                          _metric == _StatsMetric.hours ? '${_hours(totalMinutes)}${l10n.commonHoursSuffix}' : fmt.money(totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(l10n.statsFilterIncludeNonBillable, style: TextStyle(color: colors.mutedText)),
                        ),
                        Text(
                          fmt.money(totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildChart(
                    chart,
                    _type,
                    metric: _metric,
                    xLabels: xLabels,
                    avgLabel: _avgLabel(chart, _metric, fmt, l10n.commonHoursSuffix),
                    avgTitle: l10n.statsAverageLabel,
                    currencyFormatter: (v) => fmt.money(v),
                    noDataLabel: l10n.statsNoData,
                    hoursSuffix: l10n.commonHoursSuffix,
                  ),
                ),
              ),
              _legend(l10n),
              const SizedBox(height: 8),
              if (_type == _StatsType.histogram || _type == _StatsType.line)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      _modeChip(l10n.statsLegendWork, _showWork, () => setState(() => _showWork = !_showWork)),
                      const SizedBox(width: 8),
                      _modeChip(l10n.statsLegendOvertime, _showOvertime, () => setState(() => _showOvertime = !_showOvertime)),
                      const SizedBox(width: 8),
                      _modeChip(l10n.statsLegendExpenses, _showExpenses, () => setState(() => _showExpenses = !_showExpenses)),
                      const SizedBox(width: 8),
                      _modeChip(l10n.statsLegendMileage, _showMileage, () => setState(() => _showMileage = !_showMileage)),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                child: Row(
                  children: [
                    _bottomToggle(l10n.statsMetricHours, _metric == _StatsMetric.hours, () => setState(() => _metric = _StatsMetric.hours)),
                    const SizedBox(width: 10),
                    _bottomToggle(l10n.statsMetricAmount, _metric == _StatsMetric.amount, () => setState(() => _metric = _StatsMetric.amount)),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonError(e.toString()))),
      ),
    );
  }

  Widget _typeMenu() {
    final l10n = AppLocalizations.of(context)!;
    String label() {
      switch (_type) {
        case _StatsType.histogram:
          return l10n.statsTypeShortHistogram;
        case _StatsType.line:
          return l10n.statsTypeShortLine;
        case _StatsType.pie:
          return l10n.statsTypeShortPie;
        case _StatsType.mileage:
          return l10n.statsTypeShortMileage;
      }
    }

    return PopupMenuButton<_StatsType>(
      onSelected: (v) => setState(() => _type = v),
      initialValue: _type,
      itemBuilder: (_) => [
        PopupMenuItem(value: _StatsType.histogram, child: Text(l10n.statsTypeHistogram)),
        PopupMenuItem(value: _StatsType.line, child: Text(l10n.statsTypeLine)),
        PopupMenuItem(value: _StatsType.pie, child: Text(l10n.statsTypePie)),
        PopupMenuItem(value: _StatsType.mileage, child: Text(l10n.statsTypeMileage)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text(
              label(),
              style: TextStyle(
                fontSize: (MediaQuery.of(context).size.width * 0.055).clamp(18.0, 22.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Widget _periodMenu() {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<_StatsPeriod>(
      onSelected: (v) => setState(() => _period = v),
      initialValue: _period,
      itemBuilder: (_) => [
        PopupMenuItem(value: _StatsPeriod.week, child: Text(l10n.statsPeriodWeek)),
        PopupMenuItem(value: _StatsPeriod.month, child: Text(l10n.statsPeriodMonth)),
        PopupMenuItem(value: _StatsPeriod.year, child: Text(l10n.statsPeriodYear)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_periodLabel(_period, l10n), style: TextStyle(fontSize: (MediaQuery.of(context).size.width * 0.038).clamp(12.0, 16.0), fontWeight: FontWeight.w600)),
          const Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
    );
  }

  Widget _buildChart(
    List<double> values,
    _StatsType type, {
    required _StatsMetric metric,
    required List<String> xLabels,
    required String avgLabel,
    required String Function(Object value) avgTitle,
    required String Function(double) currencyFormatter,
    required String noDataLabel,
    required String hoursSuffix,
  }) {
    if (values.isEmpty) return Center(child: Text(noDataLabel));
    final max = values.reduce(math.max);
    final avg = _averageForPeriod(values);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF253047)),
      ),
      child: CustomPaint(
        painter: _StatsPainter(
          values: values,
          max: max <= 0 ? 1 : max,
          type: type,
          avg: avg,
          metric: metric,
          xLabels: xLabels,
          avgLabel: avgLabel,
          avgTitle: avgTitle,
          currencyFormatter: currencyFormatter,
          hoursSuffix: hoursSuffix,
          labelColor: Theme.of(context).extension<AppColors>()!.mutedText,
          holeColor: Theme.of(context).extension<AppColors>()!.bg,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _legend(AppLocalizations l10n) {
    final items = <Widget>[
      if (_showWork) _Legend(color: const Color(0xFF9FA8F6), label: l10n.statsLegendWork),
      if (_showOvertime) _Legend(color: const Color(0xFFF7D36A), label: l10n.statsLegendOvertime),
      if (_showExpenses) _Legend(color: const Color(0xFF84DFA5), label: l10n.statsLegendExpenses),
      if (_showMileage) _Legend(color: const Color(0xFF69D7DB), label: l10n.statsLegendMileage),
    ];
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.statsNoMetrics,
            style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 4,
        children: items,
      ),
    );
  }

  Widget _modeChip(String text, bool active, VoidCallback onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF445372) : const Color(0xFF2A3140),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? const Color(0xFF9DB8ED) : colors.border,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: active ? Colors.white : colors.mutedText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomToggle(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3A4764) : const Color(0xFF1F2738),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))),
        ),
      ),
    );
  }

  void _prev() {
    setState(() {
      switch (_period) {
        case _StatsPeriod.week:
          _anchor = _anchor.subtract(const Duration(days: 7));
          break;
        case _StatsPeriod.month:
          _anchor = DateTime(_anchor.year, _anchor.month - 1, 1);
          break;
        case _StatsPeriod.year:
          _anchor = DateTime(_anchor.year - 1, 1, 1);
          break;
      }
    });
  }

  void _next() {
    setState(() {
      switch (_period) {
        case _StatsPeriod.week:
          _anchor = _anchor.add(const Duration(days: 7));
          break;
        case _StatsPeriod.month:
          _anchor = DateTime(_anchor.year, _anchor.month + 1, 1);
          break;
        case _StatsPeriod.year:
          _anchor = DateTime(_anchor.year + 1, 1, 1);
          break;
      }
    });
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).extension<AppColors>()!.mutedText;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: muted)),
      ],
    );
  }
}

class _StatsPainter extends CustomPainter {
  _StatsPainter({
    required this.values,
    required this.max,
    required this.type,
    required this.avg,
    required this.metric,
    required this.xLabels,
    required this.avgLabel,
    required this.avgTitle,
    required this.currencyFormatter,
    required this.hoursSuffix,
    required this.labelColor,
    required this.holeColor,
  });

  final List<double> values;
  final double max;
  final _StatsType type;
  final double avg;
  final _StatsMetric metric;
  final List<String> xLabels;
  final String avgLabel;
  final String Function(Object value) avgTitle;
  final String Function(double) currencyFormatter;
  final String hoursSuffix;
  final Color labelColor;
  final Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = _buildAxisConfig(metric, values);
    final leftPad = (size.width * 0.13).clamp(42.0, 64.0);
    final rightPad = (size.width * 0.02).clamp(4.0, 10.0);
    final topPad = (size.height * 0.02).clamp(4.0, 10.0);
    final bottomPad = (size.height * 0.08).clamp(22.0, 34.0);
    final chartRect = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final grid = Paint()..color = const Color(0xFF2A3142);
    for (var i = 0; i <= axis.tickCount - 1; i++) {
      final ratio = i / (axis.tickCount - 1);
      final y = chartRect.bottom - chartRect.height * ratio;
      canvas.drawLine(Offset(chartRect.left, y), Offset(chartRect.right, y), grid);
      final value = axis.step * i;
      final label = axis.format(value);
      _paintText(
        canvas,
        label,
        Offset(2, y - 7),
        TextStyle(fontSize: (size.width * 0.028).clamp(10.0, 12.0), color: labelColor),
      );
    }
    for (var i = 0; i <= 10; i++) {
      final x = chartRect.left + chartRect.width * i / 10;
      canvas.drawLine(Offset(x, chartRect.top), Offset(x, chartRect.bottom), grid);
    }

    final avgPaint = Paint()
      ..color = const Color(0xFFE26A6A)
      ..strokeWidth = 1.5;
    final avgY = chartRect.bottom - chartRect.height * (avg / axis.maxValue);
    for (var x = chartRect.left; x < chartRect.right; x += 8) {
      canvas.drawLine(Offset(x, avgY), Offset(math.min(x + 4, chartRect.right), avgY), avgPaint);
    }
    _paintText(
      canvas,
      avgTitle(avgLabel),
      Offset(chartRect.right - (size.width * 0.28).clamp(100.0, 140.0), math.max(chartRect.top + 2, avgY - 16)),
      TextStyle(
        fontSize: (size.width * 0.032).clamp(11.0, 13.0),
        color: labelColor,
        fontWeight: FontWeight.w600,
      ),
    );

    if (type == _StatsType.pie) {
      _drawPie(canvas, chartRect.size, Offset(chartRect.left, chartRect.top));
      return;
    }

    if (type == _StatsType.line || type == _StatsType.mileage) {
      _drawLine(canvas, chartRect, axis.maxValue);
      _drawXLabels(canvas, chartRect);
      return;
    }

    _drawBars(canvas, chartRect, axis.maxValue);
    _drawXLabels(canvas, chartRect);
  }

  void _drawBars(Canvas canvas, Rect rect, double axisMax) {
    final bar = Paint()..color = const Color(0xFF9FA8F6);
    final w = rect.width / values.length;
    for (var i = 0; i < values.length; i++) {
      final h = rect.height * (values[i] / axisMax);
      final left = rect.left + i * w + w * 0.15;
      final barRect = Rect.fromLTWH(left, rect.bottom - h, w * 0.7, h);
      canvas.drawRect(barRect, bar);
    }
  }

  void _drawLine(Canvas canvas, Rect rect, double axisMax) {
    final line = Paint()
      ..color = const Color(0xFF9FA8F6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final dot = Paint()..color = const Color(0xFF9FA8F6);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1 ? rect.center.dx : rect.left + rect.width * i / (values.length - 1);
      final y = rect.bottom - rect.height * (values[i] / axisMax);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, dot);
    }
    canvas.drawPath(path, line);
  }

  void _drawPie(Canvas canvas, Size size, Offset offset) {
    final center = Offset(offset.dx + size.width / 2, offset.dy + size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35;
    final total = values.fold<double>(0, (s, v) => s + v);
    if (total <= 0) return;
    const colors = [
      Color(0xFF7AB8F0),
      Color(0xFFC181D5),
      Color(0xFF7FC786),
      Color(0xFFE9D0D8),
      Color(0xFFEA8750),
    ];
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = 2 * math.pi * (values[i] / total);
      final p = Paint()..color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, true, p);
      start += sweep;
    }
    final hole = Paint()..color = holeColor;
    canvas.drawCircle(center, radius * 0.52, hole);
  }

  void _drawXLabels(Canvas canvas, Rect rect) {
    if (xLabels.isEmpty) return;
    final step = xLabels.length > 20 ? 3 : xLabels.length > 12 ? 2 : 1;
    for (var i = 0; i < xLabels.length; i += step) {
      final x = xLabels.length == 1 ? rect.center.dx : rect.left + rect.width * i / (xLabels.length - 1);
      _paintText(
        canvas,
        xLabels[i],
        Offset(x - 8, rect.bottom + 4),
        TextStyle(fontSize: (rect.width * 0.03).clamp(10.0, 12.0), color: labelColor),
      );
    }
    if ((xLabels.length - 1) % step != 0) {
      final last = xLabels.length - 1;
      final x = rect.left + rect.width;
      _paintText(
        canvas,
        xLabels[last],
        Offset(x - 10, rect.bottom + 4),
        TextStyle(fontSize: 10, color: labelColor),
      );
    }
  }

  _AxisConfig _buildAxisConfig(_StatsMetric metric, List<double> data) {
    final rawMax = math.max(0.0, data.fold<double>(0, math.max));
    if (metric == _StatsMetric.hours) {
      const candidates = [0.5, 1.0, 2.0, 4.0, 8.0, 12.0, 24.0];
      var step = 0.5;
      for (final candidate in candidates) {
        if (rawMax / candidate <= 18) {
          step = candidate;
          break;
        }
      }
      final axisMax = math.max(step, (rawMax / step).ceil() * step);
      final tickCount = (axisMax / step).round() + 1;
      return _AxisConfig(
        maxValue: axisMax,
        step: step,
        tickCount: tickCount,
        format: (v) => _hourAxis(v, ''),
      );
    }

    final step = _niceMoneyStep(rawMax);
    final axisMax = math.max(step, (rawMax / step).ceil() * step);
    final tickCount = (axisMax / step).round() + 1;
    return _AxisConfig(
      maxValue: axisMax,
      step: step,
      tickCount: tickCount,
      format: currencyFormatter,
    );
  }

  double _niceMoneyStep(double rawMax) {
    if (rawMax <= 0) return 10;
    const targets = 8;
    final rough = rawMax / targets;
    final exp = (math.log(rough) / math.ln10).floor();
    final power = math.pow(10, exp).toDouble();
    final normalized = rough / power;
    final base = normalized <= 1
        ? 1
        : normalized <= 2
            ? 2
            : normalized <= 5
                ? 5
                : 10;
    return base * power;
  }

  void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _StatsPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.max != max ||
        oldDelegate.type != type ||
        oldDelegate.avg != avg ||
        oldDelegate.metric != metric ||
        oldDelegate.xLabels != xLabels ||
        oldDelegate.avgLabel != avgLabel;
  }
}

class _AxisConfig {
  const _AxisConfig({
    required this.maxValue,
    required this.step,
    required this.tickCount,
    required this.format,
  });

  final double maxValue;
  final double step;
  final int tickCount;
  final String Function(double) format;
}

(DateTime, DateTime) _range(DateTime anchor, _StatsPeriod period) {
  switch (period) {
    case _StatsPeriod.week:
      final day = DateTime(anchor.year, anchor.month, anchor.day);
      final start = day.subtract(Duration(days: day.weekday - DateTime.monday));
      return (start, start.add(const Duration(days: 7)));
    case _StatsPeriod.month:
      return (DateTime(anchor.year, anchor.month, 1), DateTime(anchor.year, anchor.month + 1, 1));
    case _StatsPeriod.year:
      return (DateTime(anchor.year, 1, 1), DateTime(anchor.year + 1, 1, 1));
  }
}

_SeriesSet _seriesSet(
  List<TimeEntry> entries,
  List<Expense> expensesRows,
  List<Mileage> mileagesRows,
  DateTime start,
  DateTime endExclusive,
  _StatsPeriod period,
  _StatsMetric metric,
) {
  double valueOf(TimeEntry e) => metric == _StatsMetric.hours ? e.workedMinutes / 60 : e.amount;
  final len = switch (period) {
    _StatsPeriod.week => 7,
    _StatsPeriod.month => endExclusive.difference(start).inDays,
    _StatsPeriod.year => 12,
  };
  final work = List<double>.filled(len, 0);
  final overtime = List<double>.filled(len, 0);
  final expenses = List<double>.filled(len, 0);
  final mileage = List<double>.filled(len, 0);
  for (final e in entries) {
    final i = switch (period) {
      _StatsPeriod.week => e.startAt.weekday - 1,
      _StatsPeriod.month => e.startAt.day - 1,
      _StatsPeriod.year => e.startAt.month - 1,
    };
    if (i < 0 || i >= work.length) continue;
    work[i] += valueOf(e);
    final overtimeHours = math.max(0, (e.workedMinutes - 480) / 60);
    if (metric == _StatsMetric.hours) {
      overtime[i] += overtimeHours;
    } else {
      overtime[i] += overtimeHours * e.appliedRate;
    }
  }
  for (final ex in expensesRows) {
    final i = switch (period) {
      _StatsPeriod.week => ex.occurredAt.weekday - 1,
      _StatsPeriod.month => ex.occurredAt.day - 1,
      _StatsPeriod.year => ex.occurredAt.month - 1,
    };
    if (i < 0 || i >= expenses.length) continue;
    expenses[i] += metric == _StatsMetric.hours ? 0 : ex.amount;
  }
  for (final m in mileagesRows) {
    final i = switch (period) {
      _StatsPeriod.week => m.occurredAt.weekday - 1,
      _StatsPeriod.month => m.occurredAt.day - 1,
      _StatsPeriod.year => m.occurredAt.month - 1,
    };
    if (i < 0 || i >= mileage.length) continue;
    mileage[i] += metric == _StatsMetric.hours ? 0 : m.amount;
  }
  return _SeriesSet(work: work, overtime: overtime, expenses: expenses, mileage: mileage);
}

String _periodLabel(_StatsPeriod p, AppLocalizations l10n) {
  switch (p) {
    case _StatsPeriod.week:
      return l10n.statsPeriodWeek;
    case _StatsPeriod.month:
      return l10n.statsPeriodMonth;
    case _StatsPeriod.year:
      return l10n.statsPeriodYear;
  }
}

String _rangeLabel(DateTime start, DateTime endExclusive, _StatsPeriod p, AppLocalizations l10n) {
  if (p == _StatsPeriod.week) {
    final week = _weekNum(start);
    final range =
        '${DateFormat('d').format(start)}-${DateFormat('d MMMM yyyy').format(endExclusive.subtract(const Duration(days: 1)))}';
    return l10n.statsWeekRange(week.toString(), range);
  }
  return '${DateFormat('MM/dd').format(start)} - ${DateFormat('MM/dd/yyyy').format(endExclusive.subtract(const Duration(days: 1)))}';
}

List<String> _xAxisLabels(DateTime start, DateTime endExclusive, _StatsPeriod p) {
  switch (p) {
    case _StatsPeriod.week:
      return List.generate(7, (i) => DateFormat('d').format(start.add(Duration(days: i))));
    case _StatsPeriod.month:
      final days = endExclusive.difference(start).inDays;
      return List.generate(days, (i) => DateFormat('d').format(start.add(Duration(days: i))));
    case _StatsPeriod.year:
      return List.generate(12, (i) => DateFormat('LLL').format(DateTime(start.year, i + 1, 1)));
  }
}

String _hourAxis(double value, String suffix) {
  final hours = value.floor();
  var minutes = ((value - hours) * 60).round();
  var hh = hours;
  if (minutes == 60) {
    hh += 1;
    minutes = 0;
  }
  return '${hh.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}$suffix';
}

List<double> _combineSeries({
  List<double>? work,
  List<double>? overtime,
  List<double>? expenses,
  List<double>? mileage,
}) {
  final len =
      work?.length ?? overtime?.length ?? expenses?.length ?? mileage?.length ?? 0;
  final result = List<double>.filled(len, 0);
  void add(List<double>? src) {
    if (src == null) return;
    for (var i = 0; i < len && i < src.length; i++) {
      result[i] += src[i];
    }
  }

  add(work);
  add(overtime);
  add(expenses);
  add(mileage);
  return result;
}

String _avgLabel(List<double> values, _StatsMetric metric, AppFormatters fmt, String suffix) {
  if (values.isEmpty) return metric == _StatsMetric.hours ? '00:00$suffix' : fmt.money(0);
  final avg = _averageForPeriod(values);
  if (metric == _StatsMetric.hours) {
    final h = avg.floor();
    final m = ((avg - h) * 60).round();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}$suffix';
  }
  return fmt.money(avg);
}

double _averageForPeriod(List<double> values) {
  if (values.isEmpty) return 0;
  final nonZero = values.where((v) => v.abs() > 0.000001).toList();
  if (nonZero.isEmpty) return 0;
  return nonZero.fold<double>(0, (s, v) => s + v) / nonZero.length;
}

class _SeriesSet {
  const _SeriesSet({
    required this.work,
    required this.overtime,
    required this.expenses,
    required this.mileage,
  });

  final List<double> work;
  final List<double> overtime;
  final List<double> expenses;
  final List<double> mileage;
}

int _weekNum(DateTime date) {
  final firstDay = DateTime(date.year, 1, 1);
  final diff = date.difference(firstDay).inDays;
  return ((diff + firstDay.weekday - 1) ~/ 7) + 1;
}

String _hours(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}
