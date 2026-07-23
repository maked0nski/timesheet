import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../domain/rate_calculator.dart';
import '../../utils/formatters.dart';
import '../../utils/form_feedback.dart';
import '../../theme/app_theme.dart';

enum _PeriodMode { month, week }
enum _SortMode { date, amount, project, client }

class EntriesPage extends ConsumerStatefulWidget {
  const EntriesPage({super.key});

  @override
  ConsumerState<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends ConsumerState<EntriesPage> {
  _PeriodMode _mode = _PeriodMode.month;
  final DateTime _anchor = DateTime.now();
  _SortMode _sort = _SortMode.date;
  String _statusFilter = 'all';
  int? _projectFilterId;
  int? _clientFilterId;

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(entriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final clientsAsync = ref.watch(clientsProvider);
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
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(l10n.menuTime),
            const SizedBox(width: 14),
            _periodMenu(),
          ],
        ),
        actions: [
          IconButton(onPressed: _openFilterSheet, icon: const Icon(Icons.filter_list)),
          const SizedBox(width: 4),
          IconButton(onPressed: _openSortSheet, icon: const Icon(Icons.sort)),
          const SizedBox(width: 4),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          final period = _buildPeriod(_anchor, _mode);
          final visible = entries
              .where((e) => !e.startAt.isBefore(period.start) && e.startAt.isBefore(period.endExclusive))
              .where((e) => _statusFilter == 'all' ? true : (_statusFilter == 'paid' ? (e.status == 'paid' || e.isPaid) : (e.status != 'paid' && !e.isPaid)))
              .where((e) => _projectFilterId == null ? true : e.projectId == _projectFilterId)
              .where((e) => _clientFilterId == null ? true : e.clientId == _clientFilterId)
              .toList()
            ..sort((a, b) => b.startAt.compareTo(a.startAt));
          _applySort(visible, projectsAsync.valueOrNull ?? const <Project>[], clientsAsync.valueOrNull ?? const <Client>[]);
          final totalMinutes = visible.fold<int>(0, (sum, e) => sum + e.workedMinutes);
          final totalAmount = visible.fold<double>(0, (sum, e) => sum + e.amount);
          final grouped = _groupByDay(visible);
          final projects = projectsAsync.valueOrNull ?? const <Project>[];
          final clients = clientsAsync.valueOrNull ?? const <Client>[];
          final projectById = {for (final p in projects) p.id: p};
          final clientById = {for (final c in clients) c.id: c};

          return Column(
            children: [
              _summaryHeader(
                period: period,
                entriesCount: visible.length,
                totalMinutes: totalMinutes,
                totalAmount: totalAmount,
                fmt: fmt,
                l10n: l10n,
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(child: Text(l10n.timeNoEntries))
                    : ListView.builder(
                        itemCount: grouped.length,
                        itemBuilder: (_, index) {
                          final section = grouped[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                color: colors.surface2,
                                child: Row(
                                  children: [
                                    Text(
                                      fmt.date(section.day, 'dd EEE'),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    Text(fmt.money(section.totalAmount), style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 10),
                                    Text(_hours(section.totalMinutes, l10n.commonHoursSuffix), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              ...section.entries.map(
                                (entry) {
                                  final project = projectById[entry.projectId];
                                  final clientName = clientById[entry.clientId]?.name ??
                                      (project?.clientId != null ? clientById[project!.clientId]?.name : null) ??
                                      l10n.commonClient;
                                  final projectName = project?.name ?? l10n.commonProject;
                                  return InkWell(
                                    onTap: () => _openEntryForm(context, entry: entry),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: colors.border),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 68,
                                            color: _statusColor(entry.status, entry.isPaid),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${fmt.date(entry.startAt, 'HH:mm')} - ${fmt.date(entry.endAt, 'HH:mm')}',
                                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                                  ),
                                                  Text(
                                                    '$clientName $projectName',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: colors.mutedText),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8, top: 6),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(_hours(entry.workedMinutes, l10n.commonHoursSuffix), style: const TextStyle(fontWeight: FontWeight.w700)),
                                                Text(fmt.money(entry.amount), style: const TextStyle(fontWeight: FontWeight.w700)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonError(e.toString()))),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 66,
          color: colors.surface3,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.share, color: colors.mutedText),
              const SizedBox(width: 18),
              Icon(_mode == _PeriodMode.month ? Icons.calendar_month : Icons.view_week, color: colors.mutedText),
              const SizedBox(width: 18),
              Icon(Icons.bar_chart, color: colors.mutedText),
              const SizedBox(width: 18),
              IconButton(onPressed: _openFilterSheet, icon: Icon(Icons.filter_list, color: colors.mutedText)),
              const Spacer(),
              SizedBox(
                width: 48,
                height: 48,
                child: FloatingActionButton(
                  heroTag: 'entries_add',
                  backgroundColor: const Color(0xFF355C96),
                  onPressed: () => _openEntryForm(context),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _periodMenu() {
    final l10n = AppLocalizations.of(context)!;
    final text = _mode == _PeriodMode.month ? l10n.timePeriodMonth : l10n.timePeriodWeek;
    return PopupMenuButton<_PeriodMode>(
      initialValue: _mode,
      onSelected: (value) => setState(() => _mode = value),
      itemBuilder: (_) => [
        PopupMenuItem(value: _PeriodMode.month, child: Text(l10n.timePeriodMonth)),
        PopupMenuItem(value: _PeriodMode.week, child: Text(l10n.timePeriodWeek)),
      ],
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _applySort(List<TimeEntry> entries, List<Project> projects, List<Client> clients) {
    switch (_sort) {
      case _SortMode.date:
        entries.sort((a, b) => b.startAt.compareTo(a.startAt));
        break;
      case _SortMode.amount:
        entries.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case _SortMode.project:
        final map = {for (final p in projects) p.id: p.name};
        entries.sort((a, b) => (map[a.projectId] ?? '').compareTo(map[b.projectId] ?? ''));
        break;
      case _SortMode.client:
        final map = {for (final c in clients) c.id: c.name};
        entries.sort((a, b) => (map[a.clientId] ?? '').compareTo(map[b.clientId] ?? ''));
        break;
    }
  }

  Future<void> _openSortSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<_SortMode>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sortTile(l10n.timeSortDate, _SortMode.date),
            _sortTile(l10n.timeSortAmount, _SortMode.amount),
            _sortTile(l10n.timeSortProject, _SortMode.project),
            _sortTile(l10n.timeSortClient, _SortMode.client),
          ],
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _sort = selected);
  }

  Widget _sortTile(String label, _SortMode value) {
    final active = _sort == value;
    return ListTile(
      leading: Icon(active ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).extension<AppColors>()!.mutedText),
      title: Text(label),
      onTap: () => Navigator.of(context).pop(value),
    );
  }

  Future<void> _openFilterSheet() async {
    final projects = ref.read(projectsProvider).valueOrNull ?? const <Project>[];
    final clients = ref.read(clientsProvider).valueOrNull ?? const <Client>[];
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModal) {
              final l10n = AppLocalizations.of(context)!;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.timeFilterTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _chip(l10n.timeFilterAll, _statusFilter == 'all', () => setModal(() => _statusFilter = 'all')),
                        _chip(l10n.timeFilterOpen, _statusFilter == 'open', () => setModal(() => _statusFilter = 'open')),
                        _chip(l10n.timeFilterPaid, _statusFilter == 'paid', () => setModal(() => _statusFilter = 'paid')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _pickerRow(
                      l10n.commonProject,
                      _projectFilterId == null ? l10n.timeFilterAll : (projects.where((p) => p.id == _projectFilterId).firstOrNull?.name ?? l10n.timeFilterAll),
                      () async {
                        final selected = await showModalBottomSheet<Project?>(
                          context: context,
                          builder: (_) => SafeArea(
                            child: ListView(
                              children: [
                                ListTile(title: Text(l10n.timeFilterAll), onTap: () => Navigator.of(context).pop(null)),
                                ...projects.map((p) => ListTile(title: Text(p.name), onTap: () => Navigator.of(context).pop(p))),
                              ],
                            ),
                          ),
                        );
                        setModal(() => _projectFilterId = selected?.id);
                      },
                    ),
                    _pickerRow(
                      l10n.commonClient,
                      _clientFilterId == null ? l10n.timeFilterAll : (clients.where((c) => c.id == _clientFilterId).firstOrNull?.name ?? l10n.timeFilterAll),
                      () async {
                        final selected = await showModalBottomSheet<Client?>(
                          context: context,
                          builder: (_) => SafeArea(
                            child: ListView(
                              children: [
                                ListTile(title: Text(l10n.timeFilterAll), onTap: () => Navigator.of(context).pop(null)),
                                ...clients.map((c) => ListTile(title: Text(c.name), onTap: () => Navigator.of(context).pop(c))),
                              ],
                            ),
                          ),
                        );
                        setModal(() => _clientFilterId = selected?.id);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.commonApply),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () {
                              setModal(() {
                                _statusFilter = 'all';
                                _projectFilterId = null;
                                _clientFilterId = null;
                              });
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.commonReset),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _chip(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF3A4764) : const Color(0xFF1F2738),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _pickerRow(String label, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _summaryHeader({
    required _PeriodRange period,
    required int entriesCount,
    required int totalMinutes,
    required double totalAmount,
    required AppFormatters fmt,
    required AppLocalizations l10n,
  }) {
      final periodText = _mode == _PeriodMode.month
        ? '${DateFormat('MM/dd').format(period.start)} - ${DateFormat('MM/dd/yyyy').format(period.endExclusive.subtract(const Duration(days: 1)))}'
        : '${DateFormat("w '·' d MMM").format(period.start)} - ${DateFormat('d MMM yyyy').format(period.endExclusive.subtract(const Duration(days: 1)))}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      color: Theme.of(context).extension<AppColors>()!.surface2,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(periodText, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText))),
              Text('#$entriesCount ${_hours(totalMinutes, l10n.commonHoursSuffix)}', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.calendarFilter(_filterLabel()),
                  style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText),
                ),
              ),
              Text(fmt.money(totalAmount), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  String _filterLabel() {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (_statusFilter == 'open') parts.add(l10n.timeFilterOpen);
    if (_statusFilter == 'paid') parts.add(l10n.timeFilterPaid);
    if (_projectFilterId != null) parts.add(l10n.commonProject);
    if (_clientFilterId != null) parts.add(l10n.commonClient);
    if (parts.isEmpty) return l10n.commonFilterNone;
    return parts.join(', ');
  }

  List<_DaySection> _groupByDay(List<TimeEntry> entries) {
    final map = <DateTime, List<TimeEntry>>{};
    for (final entry in entries) {
      final day = DateTime(entry.startAt.year, entry.startAt.month, entry.startAt.day);
      map.putIfAbsent(day, () => []).add(entry);
    }
    final result = map.entries
        .map(
          (e) => _DaySection(
            day: e.key,
            entries: e.value,
            totalMinutes: e.value.fold<int>(0, (sum, item) => sum + item.workedMinutes),
            totalAmount: e.value.fold<double>(0, (sum, item) => sum + item.amount),
          ),
        )
        .toList()
      ..sort((a, b) => b.day.compareTo(a.day));
    return result;
  }

  Future<void> _openEntryForm(BuildContext context, {TimeEntry? entry}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EntryFormPage(entry: entry),
      ),
    );
  }
}

class EntryFormPage extends ConsumerStatefulWidget {
  const EntryFormPage({super.key, this.entry, this.initialDay});

  final TimeEntry? entry;
  final DateTime? initialDay;

  @override
  ConsumerState<EntryFormPage> createState() => _EntryFormPageState();
}

class _EntryFormPageState extends ConsumerState<EntryFormPage> {
  Project? _selectedProject;
  Client? _selectedClient;
  late DateTime _startAt;
  late DateTime _endAt;
  late final TextEditingController _breakController;
  late final TextEditingController _taskController;
  late final TextEditingController _noteController;
  late final TextEditingController _tagController;
  bool _isBillable = true;
  String _status = 'open';
  bool _isSaving = false;
  bool _initialPrefillApplied = false;

  @override
  void initState() {
    super.initState();
    final seed = widget.initialDay ?? DateTime.now();
    final now = DateTime(seed.year, seed.month, seed.day);
    final baseStart = DateTime(now.year, now.month, now.day, 9);
    final baseEnd = DateTime(now.year, now.month, now.day, 17);
    final parsedDescription = _splitTaggedDescription(widget.entry?.taskDescription);
    _startAt = widget.entry?.startAt ?? baseStart;
    _endAt = widget.entry?.endAt ?? baseEnd;
    _breakController = TextEditingController(text: '${widget.entry?.breakMinutes ?? 0}');
    _taskController = TextEditingController(text: parsedDescription.$2);
    _noteController = TextEditingController();
    _tagController = TextEditingController(text: parsedDescription.$1);
    _isBillable = widget.entry?.isBillable ?? true;
    _status = widget.entry?.status == 'paid' || widget.entry?.isPaid == true ? 'paid' : 'open';
  }

  @override
  void dispose() {
    _breakController.dispose();
    _taskController.dispose();
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final l10n = AppLocalizations.of(context)!;

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.commonAddTime)),
            body: Center(child: Text(l10n.timeCreateProjectFirst)),
          );
        }
        final clients = clientsAsync.valueOrNull ?? const <Client>[];
        final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
        final workDescPresets = _readStringListSetting(settings['general_work_descriptions']);
        final tagPresets = _readStringListSetting(settings['general_tags']);
        final expensePresets = _readExpensePresets(settings['general_expenses']);
        final premiumPresets = _readPremiumPresets(settings['general_premium_hours']);
        final holidayManagementEnabled = settings['general_holiday_enabled'] == '1' || settings['general_holiday_enabled'] == 'true';
        final holidayDates = _readHolidayDates(settings['general_holidays']);
        final afterTimeEnabled = settings['general_after_time_enabled'] == '1' || settings['general_after_time_enabled'] == 'true';
        final afterTimeMinutes = int.tryParse(settings['general_after_time_minutes'] ?? '') ?? 480;
        final afterTimeMultiplier = double.tryParse((settings['general_after_time_multiplier'] ?? '').replaceAll(',', '.')) ?? 1.5;
        _ensureSelection(projects, clients);
        _applyInitialPrefill(workDescPresets);
        final colors = Theme.of(context).extension<AppColors>()!;

        final calc = _calculate(
          premiumPresets,
          holidayManagementEnabled: holidayManagementEnabled,
          holidayDates: holidayDates,
          afterTimeEnabled: afterTimeEnabled,
          afterTimeMinutes: afterTimeMinutes,
          afterTimeMultiplier: afterTimeMultiplier,
        );
        final workedHoursText = _hours(calc.workedMinutes, l10n.commonHoursSuffix);
        final rateText = calc.appliedRate.toStringAsFixed(0);
        final premiumMultiplier = _activePremiumMultiplier(premiumPresets);

        return Scaffold(
          backgroundColor: colors.bg,
          appBar: AppBar(
            backgroundColor: colors.surface1,
            title: Text(widget.entry == null ? l10n.commonAddTime : l10n.commonEditTime),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    _card([
                      _rowPicker(l10n.commonProject, _selectedProject?.name ?? '', () => _pickProject(projects)),
                      _rowPicker(l10n.commonClient, _selectedClient?.name ?? l10n.commonDefaultClient, () => _pickClient(clients)),
                      _rowPicker(l10n.commonStartTime, DateFormat('MM/dd HH:mm').format(_startAt), () => _pickDateTime(isStart: true)),
                      _rowPicker(l10n.commonEndTime, DateFormat('MM/dd HH:mm').format(_endAt), () => _pickDateTime(isStart: false)),
                      _rowEditor(l10n.commonBreak, _breakController, suffix: l10n.commonBreakMinutesSuffix, keyboardType: TextInputType.number),
                      _rowStatic(l10n.commonWorkHours, workedHoursText),
                      _rowStatic(l10n.commonHourlyRate, rateText),
                      _rowEditor(l10n.commonDescription, _taskController, hint: l10n.commonTaskHint, maxLines: 2),
                      _rowEditor(l10n.commonNote, _noteController, maxLines: 2),
                      _rowPicker(l10n.commonStatus, _status == 'paid' ? l10n.statusPaid : l10n.statusOpen, _pickStatus),
                      _rowPicker(
                        l10n.commonTag,
                        _tagController.text,
                        () => _pickTag(tagPresets),
                      ),
                      _rowStatic(
                        l10n.settingsPremiumTitle,
                        premiumMultiplier > 1 ? 'x${premiumMultiplier.toStringAsFixed(2)}' : l10n.commonFilterNone,
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Switch(
                          value: _isBillable,
                          onChanged: (value) => setState(() => _isBillable = value),
                        ),
                        const SizedBox(width: 6),
                        Text(l10n.commonBillable),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _actionRow(l10n.commonAddExpense, () => _addExpense(expensePresets)),
                    _actionRow(l10n.commonAddMileage, _addMileage),
                  ],
                ),
              ),
              Container(
                color: colors.surface1,
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3B54),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isSaving
                            ? null
                            : () => _save(
                                  stayOpen: true,
                                  premiumPresets: premiumPresets,
                                  holidayManagementEnabled: holidayManagementEnabled,
                                  holidayDates: holidayDates,
                                  afterTimeEnabled: afterTimeEnabled,
                                  afterTimeMinutes: afterTimeMinutes,
                                  afterTimeMultiplier: afterTimeMultiplier,
                                ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.commonSaveAndCreate, textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF9EB8EA),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: _isSaving
                            ? null
                            : () => _save(
                                  stayOpen: false,
                                  premiumPresets: premiumPresets,
                                  holidayManagementEnabled: holidayManagementEnabled,
                                  holidayDates: holidayDates,
                                  afterTimeEnabled: afterTimeEnabled,
                                  afterTimeMinutes: afterTimeMinutes,
                                  afterTimeMultiplier: afterTimeMultiplier,
                                ),
                        child: Text(l10n.commonSaveAndFinish, textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.commonError(e.toString())))),
    );
  }

  Widget _card(List<Widget> rows) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
      ),
      child: Column(children: rows),
    );
  }

  Widget _rowPicker(String label, String value, VoidCallback onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Container(
          width: 130,
          padding: const EdgeInsets.all(10),
          color: colors.surface3,
          child: Text(label),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: colors.surface4,
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowEditor(
    String label,
    TextEditingController controller, {
    String? hint,
    String? suffix,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Container(
          width: 130,
          padding: const EdgeInsets.all(10),
          color: colors.surface3,
          child: Text(label),
        ),
        Expanded(
          child: Container(
            color: colors.surface4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (suffix != null) Text(suffix, style: TextStyle(color: colors.mutedText)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowStatic(String label, String value) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Container(
          width: 130,
          padding: const EdgeInsets.all(10),
          color: colors.surface3,
          child: Text(label),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            color: colors.surface4,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _actionRow(String title, Future<void> Function() onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface3,
          border: Border(
            top: BorderSide(color: colors.border),
          ),
        ),
        child: Center(
          child: Text(title, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  void _ensureSelection(List<Project> projects, List<Client> clients) {
    if (_selectedProject == null) {
      final fromEntry = widget.entry == null ? null : projects.where((p) => p.id == widget.entry!.projectId).firstOrNull;
      _selectedProject = fromEntry ?? projects.first;
    }
    if (_selectedClient == null) {
      final projectClientId = _selectedProject?.clientId;
      final fromProject = projectClientId == null ? null : clients.where((c) => c.id == projectClientId).firstOrNull;
      final defaultClient = clients.where((c) => c.isDefaultClient).firstOrNull;
      _selectedClient = fromProject ?? defaultClient ?? clients.firstOrNull;
    }
    _isBillable = widget.entry?.isBillable ?? (_selectedProject?.isBillableDefault ?? true);
  }

  void _applyInitialPrefill(List<String> workDescPresets) {
    if (_initialPrefillApplied) return;
    _initialPrefillApplied = true;
    if (widget.entry != null) return;
    if (_taskController.text.trim().isNotEmpty) return;
    if (workDescPresets.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _taskController.text = workDescPresets.first);
    });
  }

  _CalculationPreview _calculate(
    List<_PremiumPresetModel> premiumPresets, {
    required bool holidayManagementEnabled,
    required List<DateTime> holidayDates,
    required bool afterTimeEnabled,
    required int afterTimeMinutes,
    required double afterTimeMultiplier,
  }) {
    final project = _selectedProject;
    if (project == null) {
      return const _CalculationPreview(workedMinutes: 0, appliedRate: 0, amount: 0);
    }
    final breakMinutes = int.tryParse(_breakController.text.trim()) ?? 0;
    final entryDay = DateTime(_startAt.year, _startAt.month, _startAt.day);
    final isHoliday = holidayDates.any((d) => d == entryDay);
    final calc = const RateCalculator().calculate(
      startAt: _startAt,
      endAt: _endAt,
      breakMinutes: breakMinutes,
      billingType: project.billingType,
      hourlyRate: project.hourlyRate,
      fixedRate: project.fixedRate,
      rules: RateRuleSet(
        overtimeEnabled: afterTimeEnabled || project.overtimeEnabled,
        overtimeAfterMinutes: afterTimeEnabled ? afterTimeMinutes : project.overtimeAfterMinutes,
        overtimeMultiplier: afterTimeEnabled ? afterTimeMultiplier : project.overtimeMultiplier,
        nightEnabled: project.nightEnabled,
        nightStartMinute: project.nightStartMinute,
        nightEndMinute: project.nightEndMinute,
        nightMultiplier: project.nightMultiplier,
        holidayEnabled: holidayManagementEnabled && project.holidayEnabled,
        holidayMultiplier: project.holidayMultiplier,
        isHoliday: isHoliday,
      ),
    );
    final premiumMultiplier = _activePremiumMultiplier(premiumPresets);
    final appliesPremium = project.billingType == 'hourly' && premiumMultiplier > 1;
    final appliedRate = _isBillable
        ? (appliesPremium ? calc.appliedRate * premiumMultiplier : calc.appliedRate)
        : 0.0;
    final amount = _isBillable
        ? (appliesPremium ? calc.amount * premiumMultiplier : calc.amount)
        : 0.0;
    return _CalculationPreview(
      workedMinutes: calc.workedMinutes,
      appliedRate: appliedRate,
      amount: amount,
    );
  }

  double _activePremiumMultiplier(List<_PremiumPresetModel> presets) {
    if (presets.isEmpty) return 1;
    final startMinute = _startAt.hour * 60 + _startAt.minute;
    final endMinute = _endAt.hour * 60 + _endAt.minute;
    var maxMultiplier = 1.0;
    for (final p in presets) {
      if (_intersectsPremiumWindow(startMinute, endMinute, p.startMinute, p.endMinute)) {
        maxMultiplier = math.max(maxMultiplier, p.multiplier);
      }
    }
    return maxMultiplier;
  }

  bool _intersectsPremiumWindow(int startM, int endM, int premiumStart, int premiumEnd) {
    if (premiumStart < premiumEnd) {
      return startM < premiumEnd && endM > premiumStart;
    }
    final inLate = startM >= premiumStart || endM >= premiumStart;
    final inEarly = startM < premiumEnd || endM <= premiumEnd;
    return inLate || inEarly;
  }

  Future<void> _pickProject(List<Project> projects) async {
    final selected = await showModalBottomSheet<Project>(
      context: context,
      builder: (_) {
        return ListView(
          children: projects
              .map(
                (p) => ListTile(
                  title: Text(p.name),
                  onTap: () => Navigator.of(context).pop(p),
                ),
              )
              .toList(),
        );
      },
    );
    if (selected == null) return;
    final clients = ref.read(clientsProvider).valueOrNull ?? const <Client>[];
    setState(() {
      _selectedProject = selected;
      final byProjectClient = selected.clientId == null ? null : clients.where((c) => c.id == selected.clientId).firstOrNull;
      if (byProjectClient != null) {
        _selectedClient = byProjectClient;
      }
      _breakController.text = '${selected.defaultBreakMinutes}';
      _isBillable = selected.isBillableDefault;
    });
  }

  Future<void> _pickClient(List<Client> clients) async {
    final selected = await showModalBottomSheet<Client>(
      context: context,
      builder: (_) {
        return ListView(
          children: clients
              .map(
                (c) => ListTile(
                  title: Text(c.name),
                  onTap: () => Navigator.of(context).pop(c),
                ),
              )
              .toList(),
        );
      },
    );
    if (selected == null) return;
    setState(() => _selectedClient = selected);
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final base = isStart ? _startAt : _endAt;
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: base,
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (pickedTime == null) return;
    final next = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isStart) {
        _startAt = next;
        if (!_endAt.isAfter(_startAt)) {
          _endAt = _startAt.add(const Duration(hours: 1));
        }
      } else {
        _endAt = next.isAfter(_startAt) ? next : _startAt.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickStatus() async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return ListView(
          children: [
            ListTile(
              leading: Icon(
                _status == 'open' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: const Color(0xFFE9D05D),
              ),
              title: Text(l10n.statusOpen),
              onTap: () => Navigator.of(context).pop('open'),
            ),
            ListTile(
              leading: Icon(
                _status == 'paid' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: const Color(0xFF65D68C),
              ),
              title: Text(l10n.statusPaid),
              onTap: () => Navigator.of(context).pop('paid'),
            ),
          ],
        );
      },
    );
    if (picked == null) return;
    setState(() => _status = picked);
  }

  Future<void> _pickTag(List<String> tags) async {
    if (tags.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      final controller = TextEditingController(text: _tagController.text);
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.commonTag),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.settingsTagHint),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
          ],
        ),
      );
      if (ok == true) {
        setState(() => _tagController.text = controller.text.trim());
      }
      return;
    }
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: tags
              .map((tag) => ListTile(title: Text(tag), onTap: () => Navigator.of(context).pop(tag)))
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _tagController.text = selected);
  }

  Future<void> _save({
    required bool stayOpen,
    required List<_PremiumPresetModel> premiumPresets,
    required bool holidayManagementEnabled,
    required List<DateTime> holidayDates,
    required bool afterTimeEnabled,
    required int afterTimeMinutes,
    required double afterTimeMultiplier,
  }) async {
    if (_isSaving) return;
    final project = _selectedProject;
    if (project == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      FormFeedback.showError(context, l10n.timeCreateProjectFirst);
      return;
    }
    if (!_endAt.isAfter(_startAt)) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      FormFeedback.showError(context, l10n.validationTimeRange);
      return;
    }
    final breakMinutes = int.tryParse(_breakController.text.trim()) ?? 0;
    final calc = _calculate(
      premiumPresets,
      holidayManagementEnabled: holidayManagementEnabled,
      holidayDates: holidayDates,
      afterTimeEnabled: afterTimeEnabled,
      afterTimeMinutes: afterTimeMinutes,
      afterTimeMultiplier: afterTimeMultiplier,
    );
    final repo = ref.read(entriesRepositoryProvider);

    setState(() => _isSaving = true);
    try {
      final patch = TimeEntriesCompanion(
        projectId: drift.Value(project.id),
        clientId: drift.Value(_selectedClient?.id ?? project.clientId),
        startAt: drift.Value(_startAt),
        endAt: drift.Value(_endAt),
        breakMinutes: drift.Value(breakMinutes),
        workedMinutes: drift.Value(calc.workedMinutes),
        appliedRate: drift.Value(calc.appliedRate),
        amount: drift.Value(calc.amount),
        status: drift.Value(_status),
        isBillable: drift.Value(_isBillable),
        isPaid: drift.Value(_status == 'paid'),
        taskDescription: drift.Value(_buildTaggedDescription(_tagController.text.trim(), _taskController.text.trim())),
      );

      if (widget.entry == null) {
        await repo.create(
          TimeEntriesCompanion.insert(
            projectId: project.id,
            clientId: drift.Value(_selectedClient?.id ?? project.clientId),
            startAt: _startAt,
            endAt: _endAt,
            breakMinutes: drift.Value(breakMinutes),
            workedMinutes: calc.workedMinutes,
            appliedRate: calc.appliedRate,
            amount: calc.amount,
            status: drift.Value(_status),
            isBillable: drift.Value(_isBillable),
            isPaid: drift.Value(_status == 'paid'),
            taskDescription: drift.Value(_buildTaggedDescription(_tagController.text.trim(), _taskController.text.trim())),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
      } else {
        await repo.update(widget.entry!, patch);
      }

      if (!mounted) return;
      if (!stayOpen) {
        Navigator.of(context).pop();
        return;
      }
        setState(() {
        _noteController.clear();
        _startAt = _endAt;
        _endAt = _startAt.add(const Duration(hours: 1));
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      FormFeedback.showError(context, l10n.commonError(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _addExpense(List<_ExpensePresetModel> presets) async {
    final l10n = AppLocalizations.of(context)!;
    if (presets.isEmpty) {
      await _addExpenseManual();
      return;
    }
    final selected = await showModalBottomSheet<_ExpensePresetModel?>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(l10n.commonAdd),
              subtitle: Text(l10n.expenseAddTitle),
              onTap: () => Navigator.of(context).pop(null),
            ),
            ...presets.map(
              (p) => ListTile(
                title: Text(p.name),
                subtitle: Text('${p.isDeduction ? '-' : '+'}${p.amount.toStringAsFixed(2)}'),
                onTap: () => Navigator.of(context).pop(p),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected == null) {
      await _addExpenseManual();
      return;
    }
    final signedAmount = selected.isDeduction ? -selected.amount : selected.amount;
    await ref.read(financeRepositoryProvider).addExpense(
          occurredAt: _startAt,
          amount: signedAmount,
          note: selected.name,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.expenseAdded)));
  }

  Future<void> _addExpenseManual() async {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.expenseAddTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.commonAmount),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: l10n.commonNote),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok != true) return;
    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    await ref.read(financeRepositoryProvider).addExpense(
          occurredAt: _startAt,
          amount: amount,
          note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.expenseAdded)));
  }

  Future<void> _addMileage() async {
    final l10n = AppLocalizations.of(context)!;
    final distanceController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.mileageAddTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: distanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.commonDistanceKm),
            ),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.commonAmount),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: l10n.commonNote),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok != true) return;
    final distance = double.tryParse(distanceController.text.replaceAll(',', '.')) ?? 0;
    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0;
    if (distance <= 0 && amount <= 0) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    await ref.read(financeRepositoryProvider).addMileage(
          occurredAt: _startAt,
          distance: distance,
          amount: amount,
          note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mileageAdded)));
  }
}

class _PeriodRange {
  const _PeriodRange({required this.start, required this.endExclusive});

  final DateTime start;
  final DateTime endExclusive;
}

class _DaySection {
  const _DaySection({
    required this.day,
    required this.entries,
    required this.totalMinutes,
    required this.totalAmount,
  });

  final DateTime day;
  final List<TimeEntry> entries;
  final int totalMinutes;
  final double totalAmount;
}

class _CalculationPreview {
  const _CalculationPreview({
    required this.workedMinutes,
    required this.appliedRate,
    required this.amount,
  });

  final int workedMinutes;
  final double appliedRate;
  final double amount;
}

_PeriodRange _buildPeriod(DateTime anchor, _PeriodMode mode) {
  if (mode == _PeriodMode.month) {
    final start = DateTime(anchor.year, anchor.month, 1);
    final endExclusive = DateTime(anchor.year, anchor.month + 1, 1);
    return _PeriodRange(start: start, endExclusive: endExclusive);
  }
  final day = DateTime(anchor.year, anchor.month, anchor.day);
  final start = day.subtract(Duration(days: day.weekday - DateTime.monday));
  final endExclusive = start.add(const Duration(days: 7));
  return _PeriodRange(start: start, endExclusive: endExclusive);
}

String _hours(int minutes, String suffix) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}$suffix';
}

Color _statusColor(String status, bool isPaid) {
  if (status == 'paid' || isPaid) return const Color(0xFF65D68C);
  return const Color(0xFFE9D05D);
}

(String, String) _splitTaggedDescription(String? raw) {
  final text = (raw ?? '').trim();
  if (text.isEmpty) return ('', '');
  if (!text.startsWith('#') || !text.contains(' ')) return ('', text);
  final space = text.indexOf(' ');
  final tag = text.substring(1, space).trim();
  final desc = text.substring(space + 1).trim();
  return (tag, desc);
}

String? _buildTaggedDescription(String tag, String description) {
  final cleanTag = tag.trim();
  final cleanDesc = description.trim();
  if (cleanTag.isEmpty && cleanDesc.isEmpty) return null;
  if (cleanTag.isNotEmpty && cleanDesc.isNotEmpty) return '#$cleanTag $cleanDesc';
  if (cleanTag.isNotEmpty) return '#$cleanTag';
  return cleanDesc;
}

List<String> _readStringListSetting(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  } catch (_) {
    return const [];
  }
}

List<_ExpensePresetModel> _readExpensePresets(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_ExpensePresetModel.fromJson)
        .where((e) => e.name.isNotEmpty && e.amount > 0)
        .toList();
  } catch (_) {
    return const [];
  }
}

List<_PremiumPresetModel> _readPremiumPresets(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_PremiumPresetModel.fromJson)
        .where((e) => e.name.isNotEmpty && e.multiplier > 1)
        .toList();
  } catch (_) {
    return const [];
  }
}

List<DateTime> _readHolidayDates(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<String>()
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList();
  } catch (_) {
    return const [];
  }
}

class _ExpensePresetModel {
  const _ExpensePresetModel({
    required this.name,
    required this.amount,
    required this.isDeduction,
  });

  final String name;
  final double amount;
  final bool isDeduction;

  factory _ExpensePresetModel.fromJson(Map<String, dynamic> json) {
    return _ExpensePresetModel(
      name: (json['name'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      isDeduction: json['isDeduction'] == true || json['isDeduction'] == 1,
    );
  }
}

class _PremiumPresetModel {
  const _PremiumPresetModel({
    required this.name,
    required this.startMinute,
    required this.endMinute,
    required this.multiplier,
  });

  final String name;
  final int startMinute;
  final int endMinute;
  final double multiplier;

  factory _PremiumPresetModel.fromJson(Map<String, dynamic> json) {
    return _PremiumPresetModel(
      name: (json['name'] ?? '').toString(),
      startMinute: (json['startMinute'] as num?)?.toInt() ?? 0,
      endMinute: (json['endMinute'] as num?)?.toInt() ?? 0,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1,
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
