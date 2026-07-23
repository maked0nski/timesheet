import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../utils/formatters.dart';
import '../entries/entries_page.dart';
import '../../theme/app_theme.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 360).clamp(0.9, 1.2);
    final weekWidth = (width * 0.12).clamp(42.0, 64.0);
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final selectedMonth = ref.watch(selectedMonthProvider);
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    final fmt = AppFormatters(
      locale: AppFormatters.localeFromSettings(settings),
      currencyCode: AppFormatters.currencyFromSettings(settings),
    );
    final today = DateTime.now();
    final selectedDay = ref.watch(selectedCalendarDayProvider) ??
        (today.year == selectedMonth.year && today.month == selectedMonth.month
            ? DateTime(today.year, today.month, today.day)
            : DateTime(selectedMonth.year, selectedMonth.month, 1));
    final entriesAsync = ref.watch(entriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final clientsAsync = ref.watch(clientsProvider);

    if (selectedDay.month != selectedMonth.month || selectedDay.year != selectedMonth.year) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedCalendarDayProvider.notifier).state = null;
      });
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final fontSize = (maxWidth * 0.09).clamp(14.0, 18.0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _shiftMonth(ref, selectedMonth, -1),
                  icon: const Icon(Icons.chevron_left, size: 20),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () => _showMonthYearPicker(context, ref, selectedMonth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _monthLabel(selectedMonth),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 18),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _shiftMonth(ref, selectedMonth, 1),
                  icon: const Icon(Icons.chevron_right, size: 20),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showMonthYearPicker(context, ref, selectedMonth),
            icon: const Icon(Icons.filter_list),
          ),
          const Icon(Icons.view_week_outlined),
          const SizedBox(width: 14),
          const Icon(Icons.view_list_outlined),
          const SizedBox(width: 10),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          final period = _monthRange(selectedMonth);
          final monthEntries = entries
              .where((e) => !e.startAt.isBefore(period.$1) && e.startAt.isBefore(period.$2))
              .toList();
          final dayMap = _buildDayMap(monthEntries);
          final monthMinutes = monthEntries.fold<int>(0, (s, e) => s + e.workedMinutes);
          final monthAmount = monthEntries.fold<double>(0, (s, e) => s + e.amount);
          final paidAmount = monthEntries
              .where((e) => e.status == 'paid' || e.isPaid)
              .fold<double>(0, (s, e) => s + e.amount);
          final openAmount = monthAmount - paidAmount;
          final selectedEntries = monthEntries
              .where((e) => _isSameDay(e.startAt, selectedDay))
              .toList()
            ..sort((a, b) => a.startAt.compareTo(b.startAt));

          final projects = projectsAsync.valueOrNull ?? const <Project>[];
          final clients = clientsAsync.valueOrNull ?? const <Client>[];
          final projectById = {for (final p in projects) p.id: p};
          final clientById = {for (final c in clients) c.id: c};

          return Column(
            children: [
              Container(
                color: colors.surface2,
                padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 6 * scale),
                child: Row(
                  children: [
                    Text('#${monthEntries.length}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14 * scale)),
                    const Spacer(),
                    Text(_hoursLabel(monthMinutes), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14 * scale)),
                  ],
                ),
              ),
              Container(
                color: colors.surface2,
                padding: EdgeInsets.fromLTRB(10 * scale, 0, 10 * scale, 6 * scale),
                child: Row(
                  children: [
                    Text(
                      l10n.calendarFilter(l10n.commonFilterNone),
                      style: TextStyle(color: colors.mutedText, fontSize: 12 * scale),
                    ),
                    const Spacer(),
                    Text(
                      '${fmt.money(openAmount)} ${fmt.money(paidAmount)} ${fmt.money(monthAmount)}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12 * scale),
                    ),
                  ],
                ),
              ),
              _weekdayRow(scale, weekWidth, l10n, colors),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2 * scale),
                  child: _monthGrid(
                    context,
                    ref,
                    scale: scale,
                    weekWidth: weekWidth,
                    selectedMonth: selectedMonth,
                    selectedDay: selectedDay,
                    dayMap: dayMap,
                    l10n: l10n,
                    colors: colors,
                  ),
                ),
              ),
              _dayDetails(
                context,
                ref,
                scale: scale,
                fmt: fmt,
                l10n: l10n,
                colors: colors,
                selectedDay: selectedDay,
                entries: selectedEntries,
                projectById: projectById,
                clientById: clientById,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonError(e.toString()))),
      ),
    );
  }

  Widget _weekdayRow(double scale, double weekWidth, AppLocalizations l10n, AppColors colors) {
    final labels = [
      l10n.calendarWeek,
      l10n.calendarMon,
      l10n.calendarTue,
      l10n.calendarWed,
      l10n.calendarThu,
      l10n.calendarFri,
      l10n.calendarSat,
      l10n.calendarSun,
    ];
    return Container(
      color: colors.surface4,
      child: Row(
        children: [
          SizedBox(
            width: weekWidth,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3 * scale),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: colors.border),
                  bottom: BorderSide(color: colors.border),
                ),
              ),
              child: Center(
                child: Text(
                  labels.first,
                  style: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w600, fontSize: 12 * scale),
                ),
              ),
            ),
          ),
          ...labels.skip(1).map(
                (l) => Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3 * scale),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: colors.border),
                        bottom: BorderSide(color: colors.border),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l,
                        style: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w600, fontSize: 12 * scale),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _monthGrid(
    BuildContext context,
    WidgetRef ref, {
    required double scale,
    required double weekWidth,
    required DateTime selectedMonth,
    required DateTime selectedDay,
    required Map<DateTime, _DaySummary> dayMap,
    required AppLocalizations l10n,
    required AppColors colors,
  }) {
    final first = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final offset = first.weekday - DateTime.monday;
    final gridStart = first.subtract(Duration(days: offset));

    final weekStarts = List.generate(6, (w) => gridStart.add(Duration(days: w * 7)));

    return Column(
      children: weekStarts.map((weekStart) {
        final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
        final weekEntries = weekDays.map((d) => dayMap[_normalize(d)]).whereType<_DaySummary>().toList();
        final weekMinutes = weekEntries.fold<int>(0, (s, e) => s + e.minutes);
        final weekAmount = weekEntries.fold<double>(0, (s, e) => s + e.amount);
        return Expanded(
          child: Row(
            children: [
              SizedBox(
                width: weekWidth,
                child: Container(
                  margin: EdgeInsets.all(1 * scale),
                  padding: EdgeInsets.all(4 * scale),
                  color: colors.surface3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_weekNumber(weekStart)}', style: TextStyle(color: colors.mutedText, fontSize: 11 * scale)),
                      const Spacer(),
                      if (weekMinutes > 0)
                        Text(
                          _hoursLabel(weekMinutes),
                          style: TextStyle(color: colors.mutedText, fontSize: 11 * scale),
                        ),
                      if (weekAmount > 0)
                        Text(weekAmount.toStringAsFixed(0), style: TextStyle(color: colors.mutedText, fontSize: 10 * scale)),
                    ],
                  ),
                ),
              ),
              ...weekDays.map((day) {
                final summary = dayMap[_normalize(day)];
                final inMonth = day.month == selectedMonth.month;
                final isSelected = _isSameDay(day, selectedDay);
                final baseColor = !inMonth
                    ? colors.surface4
                    : isSelected
                        ? colors.surface3
                        : colors.bg;
                final textColor = day.weekday >= 6 ? const Color(0xFFE8A8A8) : colors.mutedText;
                final statusColor = summary == null ? const Color(0xFF88A0B8) : _statusColor(summary.status);

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final normalized = _normalize(day);
                      if (_isSameDay(normalized, selectedDay)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EntryFormPage(initialDay: normalized)),
                        );
                        return;
                      }
                      ref.read(selectedCalendarDayProvider.notifier).state = normalized;
                    },
                    child: Container(
                      margin: EdgeInsets.all(1 * scale),
                      padding: EdgeInsets.all(4 * scale),
                      decoration: BoxDecoration(
                        color: baseColor,
                        border: Border.all(color: colors.border),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: inMonth ? textColor : colors.mutedText.withValues(alpha: 102),
                                fontSize: 12 * scale,
                              ),
                            ),
                          ),
                          if (summary != null)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _hoursLabel(summary.minutes),
                                      style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 11 * scale),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      summary.amount.toStringAsFixed(0),
                                      style: TextStyle(color: statusColor, fontSize: 10 * scale),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isSelected)
                            const Center(
                              child: Text('+', style: TextStyle(color: Colors.white, fontSize: 18, height: 1)),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _dayDetails(
    BuildContext context,
    WidgetRef ref, {
    required double scale,
    required AppFormatters fmt,
    required AppLocalizations l10n,
    required AppColors colors,
    required DateTime selectedDay,
    required List<TimeEntry> entries,
    required Map<int, Project> projectById,
    required Map<int, Client> clientById,
  }) {
    final dayMinutes = entries.fold<int>(0, (s, e) => s + e.workedMinutes);
    final dayAmount = entries.fold<double>(0, (s, e) => s + e.amount);
    final dayStatusColor = _dayStatusColor(entries, colors);
    return Container(
      height: 130 * scale,
      color: colors.surface4,
      child: Column(
        children: [
          Container(
            color: colors.surface2,
            padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 4 * scale),
            child: Row(
              children: [
                Text(fmt.date(selectedDay, 'MM/dd EEE'), style: TextStyle(fontSize: 12 * scale)),
                const Spacer(),
                Text(
                  '${_hoursLabel(dayMinutes)} ${fmt.money(dayAmount)}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12 * scale, color: dayStatusColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EntryFormPage(initialDay: selectedDay)),
                      ),
                      child: Text(l10n.calendarAddEntry),
                    ),
                  )
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (_, index) {
                      final e = entries[index];
                      final project = projectById[e.projectId];
                      final client = clientById[e.clientId];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EntryFormPage(entry: e)),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFF263042))),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4 * scale,
                                height: 46 * scale,
                                color: _statusColor(e.status == 'paid' || e.isPaid ? 'paid' : 'open'),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${fmt.date(e.startAt, 'HH:mm')} - ${fmt.date(e.endAt, 'HH:mm')}',
                                        style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${client?.name ?? l10n.commonClient} ${project?.name ?? l10n.commonProject}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: colors.mutedText, fontSize: 12 * scale),
                                      ),
                                      Text(
                                        '${l10n.calendarRate}: ${fmt.money(e.appliedRate)}${l10n.commonPerHourSuffix}${(e.taskDescription ?? '').isEmpty ? '' : ' · ${e.taskDescription}'}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: colors.mutedText, fontSize: 11 * scale),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8 * scale),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(_hoursLabel(e.workedMinutes),
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12 * scale)),
                                    Text(fmt.money(e.amount),
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12 * scale, color: _statusColor(e.status == 'paid' || e.isPaid ? 'paid' : 'open'))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMonthYearPicker(BuildContext context, WidgetRef ref, DateTime selectedMonth) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    var year = selectedMonth.year;
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final now = DateTime.now();
            return AlertDialog(
              backgroundColor: const Color(0xFF232936),
              contentPadding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              content: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(DateFormat('LLL, yyyy').format(selectedMonth), style: TextStyle(color: colors.mutedText)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(DateTime(now.year, now.month)),
                          child: Text(l10n.calendarThisMonth),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => year -= 1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('$year', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => year += 1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(12, (index) {
                        final month = index + 1;
                        final isSelected = year == selectedMonth.year && month == selectedMonth.month;
                        return SizedBox(
                          width: 68,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: isSelected ? const Color(0xFFFFB0A8) : colors.mutedText,
                            ),
                            onPressed: () => Navigator.of(context).pop(DateTime(year, month)),
                            child: Text(DateFormat('LLL').format(DateTime(2026, month))),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked == null) return;
    ref.read(selectedMonthProvider.notifier).state = picked;
    ref.read(selectedCalendarDayProvider.notifier).state = null;
  }

  void _shiftMonth(WidgetRef ref, DateTime current, int delta) {
    final shifted = DateTime(current.year, current.month + delta, 1);
    ref.read(selectedMonthProvider.notifier).state = shifted;
    ref.read(selectedCalendarDayProvider.notifier).state = null;
  }

  String _monthLabel(DateTime value) {
    final raw = DateFormat('LLLL yyyy').format(value);
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }
}

Map<DateTime, _DaySummary> _buildDayMap(List<TimeEntry> entries) {
  final map = <DateTime, _DaySummary>{};
  for (final e in entries) {
    final day = _normalize(e.startAt);
    final curr = map[day];
    final status = (e.status == 'paid' || e.isPaid) ? 'paid' : 'open';
    if (curr == null) {
      map[day] = _DaySummary(minutes: e.workedMinutes, amount: e.amount, status: status);
    } else {
      final mixed = curr.status == status ? status : 'mixed';
      map[day] = _DaySummary(minutes: curr.minutes + e.workedMinutes, amount: curr.amount + e.amount, status: mixed);
    }
  }
  return map;
}

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

(DateTime, DateTime) _monthRange(DateTime month) {
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 1);
  return (start, end);
}

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

Color _statusColor(String status) {
  if (status == 'paid') return const Color(0xFF65D68C);
  if (status == 'mixed') return const Color(0xFF69D7DB);
  return const Color(0xFFE9D05D);
}

String _hours(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

String _hoursLabel(int minutes) => _hours(minutes);

Color _dayStatusColor(List<TimeEntry> entries, AppColors colors) {
  if (entries.isEmpty) return colors.mutedText;
  final allPaid = entries.every((e) => e.status == 'paid' || e.isPaid);
  return _statusColor(allPaid ? 'paid' : 'open');
}

int _weekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final days = date.difference(firstDayOfYear).inDays;
  return ((days + firstDayOfYear.weekday - 1) ~/ 7) + 1;
}

class _DaySummary {
  const _DaySummary({
    required this.minutes,
    required this.amount,
    required this.status,
  });

  final int minutes;
  final double amount;
  final String status;
}
