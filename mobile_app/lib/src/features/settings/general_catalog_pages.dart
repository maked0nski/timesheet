import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/database_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/form_feedback.dart';

class WorkDescriptionsPage extends ConsumerWidget {
  const WorkDescriptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TextCatalogPage(
      title: AppLocalizations.of(context)!.settingsWorkDescTitle,
      settingKey: 'general_work_descriptions',
      inputHint: AppLocalizations.of(context)!.settingsWorkDescHint,
    );
  }
}

class TagsPage extends ConsumerWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TextCatalogPage(
      title: AppLocalizations.of(context)!.settingsTagTitle,
      settingKey: 'general_tags',
      inputHint: AppLocalizations.of(context)!.settingsTagHint,
    );
  }
}

class HolidayManagementPage extends ConsumerStatefulWidget {
  const HolidayManagementPage({super.key});

  @override
  ConsumerState<HolidayManagementPage> createState() => _HolidayManagementPageState();
}

class _HolidayManagementPageState extends ConsumerState<HolidayManagementPage> {
  bool _enabled = false;
  bool _initialized = false;
  final List<DateTime> _holidays = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    if (!_initialized) {
      _enabled = settings['general_holiday_enabled'] == '1' || settings['general_holiday_enabled'] == 'true';
      _holidays
        ..clear()
        ..addAll(_readDateList(settings['general_holidays']));
      _initialized = true;
    }
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l10n.settingsHolidayTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.commonEnabled),
            subtitle: Text(l10n.settingsHolidaySubtitle),
            value: _enabled,
            onChanged: (v) async {
              setState(() => _enabled = v);
              await ref.read(settingsRepositoryProvider).setBool('general_holiday_enabled', v);
            },
          ),
          Divider(height: 1, color: colors.border),
          if (_holidays.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.settingsEmpty, style: TextStyle(color: colors.mutedText)),
            ),
          ..._holidays.map(
            (d) => ListTile(
              title: Text('${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: colors.mutedText),
                onPressed: () async {
                  setState(() => _holidays.remove(d));
                  await _persistHolidays();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDate,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked == null) return;
    final normalized = DateTime(picked.year, picked.month, picked.day);
    if (!_holidays.any((d) => d == normalized)) {
      setState(() => _holidays.add(normalized));
      await _persistHolidays();
    }
  }

  Future<void> _persistHolidays() {
    final data = _holidays
        .map((d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
        .toList();
    return ref.read(settingsRepositoryProvider).set('general_holidays', jsonEncode(data));
  }
}

class AfterSomeTimePage extends ConsumerStatefulWidget {
  const AfterSomeTimePage({super.key});

  @override
  ConsumerState<AfterSomeTimePage> createState() => _AfterSomeTimePageState();
}

class _AfterSomeTimePageState extends ConsumerState<AfterSomeTimePage> {
  bool _initialized = false;
  bool _enabled = false;
  late TextEditingController _minutesController;
  late TextEditingController _multiplierController;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController(text: '480');
    _multiplierController = TextEditingController(text: '1.50');
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _multiplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    if (!_initialized) {
      _enabled = settings['general_after_time_enabled'] == '1' || settings['general_after_time_enabled'] == 'true';
      _minutesController.text = settings['general_after_time_minutes']?.trim().isNotEmpty == true ? settings['general_after_time_minutes']! : '480';
      _multiplierController.text = settings['general_after_time_multiplier']?.trim().isNotEmpty == true ? settings['general_after_time_multiplier']! : '1.50';
      _initialized = true;
    }
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l10n.settingsAfterTimeTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.commonEnabled),
            subtitle: Text(l10n.settingsAfterTimeSubtitle),
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(l10n.settingsAfterMinutesLabel),
            subtitle: TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ListTile(
            title: Text(l10n.settingsMultiplierLabel),
            subtitle: TextField(
              controller: _multiplierController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _save,
              child: Text(l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final minutes = int.tryParse(_minutesController.text.trim());
    final multiplier = double.tryParse(_multiplierController.text.trim().replaceAll(',', '.'));
    if (minutes == null || minutes <= 0 || multiplier == null || multiplier <= 0) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setBool('general_after_time_enabled', _enabled);
    await repo.set('general_after_time_minutes', '$minutes');
    await repo.set('general_after_time_multiplier', multiplier.toStringAsFixed(2));
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class _TextCatalogPage extends ConsumerStatefulWidget {
  const _TextCatalogPage({
    required this.title,
    required this.settingKey,
    required this.inputHint,
  });

  final String title;
  final String settingKey;
  final String inputHint;

  @override
  ConsumerState<_TextCatalogPage> createState() => _TextCatalogPageState();
}

class _TextCatalogPageState extends ConsumerState<_TextCatalogPage> {
  bool _initialized = false;
  final List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    if (!_initialized) {
      _items
        ..clear()
        ..addAll(_readStringList(settings[widget.settingKey]));
      _initialized = true;
    }
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(widget.title)),
      body: _items.isEmpty
          ? Center(
              child: Text(
                l10n.settingsEmpty,
                style: TextStyle(color: colors.mutedText),
              ),
            )
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: colors.border),
              itemBuilder: (_, index) {
                final value = _items[index];
                return ListTile(
                  title: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _edit(index),
                        icon: Icon(Icons.edit_outlined, color: colors.mutedText),
                      ),
                      IconButton(
                        onPressed: () => _remove(index),
                        icon: Icon(Icons.delete_outline, color: colors.mutedText),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _edit(int? index) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: index == null ? '' : _items[index]);
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? l10n.settingsAddPreset : l10n.settingsEditPreset),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: widget.inputHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (saved != true) return;
    final value = controller.text.trim();
    if (value.isEmpty) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationRequired(widget.inputHint));
      return;
    }
    setState(() {
      if (index == null) {
        _items.add(value);
      } else {
        _items[index] = value;
      }
    });
    await _persist();
  }

  Future<void> _remove(int index) async {
    setState(() => _items.removeAt(index));
    await _persist();
  }

  Future<void> _persist() {
    return ref.read(settingsRepositoryProvider).set(widget.settingKey, jsonEncode(_items));
  }
}

class ExpensesCatalogPage extends ConsumerStatefulWidget {
  const ExpensesCatalogPage({super.key});

  @override
  ConsumerState<ExpensesCatalogPage> createState() => _ExpensesCatalogPageState();
}

class _ExpensesCatalogPageState extends ConsumerState<ExpensesCatalogPage> {
  bool _initialized = false;
  final List<_ExpensePreset> _items = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    if (!_initialized) {
      _items
        ..clear()
        ..addAll(_readExpenseList(settings['general_expenses']));
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l10n.settingsExpensesTitle)),
      body: _items.isEmpty
          ? Center(child: Text(l10n.settingsEmpty, style: TextStyle(color: colors.mutedText)))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: colors.border),
              itemBuilder: (_, index) {
                final value = _items[index];
                final sign = value.isDeduction ? '-' : '+';
                return ListTile(
                  title: Text(value.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(value.isDeduction ? l10n.settingsIsDeduction : l10n.commonAdd),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$sign${value.amount.toStringAsFixed(2)}'),
                      IconButton(
                        onPressed: () => _edit(index),
                        icon: Icon(Icons.edit_outlined, color: colors.mutedText),
                      ),
                      IconButton(
                        onPressed: () => _remove(index),
                        icon: Icon(Icons.delete_outline, color: colors.mutedText),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _edit(int? index) async {
    final l10n = AppLocalizations.of(context)!;
    final current = index == null ? const _ExpensePreset.empty() : _items[index];
    final nameController = TextEditingController(text: current.name);
    final amountController = TextEditingController(
      text: current.amount == 0 ? '' : current.amount.toStringAsFixed(2),
    );
    var isDeduction = current.isDeduction;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(index == null ? l10n.settingsAddPreset : l10n.settingsEditPreset),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.settingsNameLabel),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.commonAmount),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.settingsIsDeduction),
                  value: isDeduction,
                  onChanged: (v) => setDialogState(() => isDeduction = v),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
              FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
            ],
          );
        },
      ),
    );

    if (saved != true) return;
    final name = nameController.text.trim();
    final amount = double.tryParse(amountController.text.trim().replaceAll(',', '.'));
    if (name.isEmpty || amount == null) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    final next = _ExpensePreset(name: name, amount: amount, isDeduction: isDeduction);
    setState(() {
      if (index == null) {
        _items.add(next);
      } else {
        _items[index] = next;
      }
    });
    await _persist();
  }

  Future<void> _remove(int index) async {
    setState(() => _items.removeAt(index));
    await _persist();
  }

  Future<void> _persist() {
    final data = _items.map((e) => e.toJson()).toList();
    return ref.read(settingsRepositoryProvider).set('general_expenses', jsonEncode(data));
  }
}

class PremiumHoursCatalogPage extends ConsumerStatefulWidget {
  const PremiumHoursCatalogPage({super.key});

  @override
  ConsumerState<PremiumHoursCatalogPage> createState() => _PremiumHoursCatalogPageState();
}

class _PremiumHoursCatalogPageState extends ConsumerState<PremiumHoursCatalogPage> {
  bool _initialized = false;
  final List<_PremiumPreset> _items = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    if (!_initialized) {
      _items
        ..clear()
        ..addAll(_readPremiumList(settings['general_premium_hours']));
      _initialized = true;
    }
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l10n.settingsPremiumTitle)),
      body: _items.isEmpty
          ? Center(child: Text(l10n.settingsEmpty, style: TextStyle(color: colors.mutedText)))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: colors.border),
              itemBuilder: (_, index) {
                final value = _items[index];
                return ListTile(
                  title: Text(value.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${_formatMinute(value.startMinute)} - ${_formatMinute(value.endMinute)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('x${value.multiplier.toStringAsFixed(2)}'),
                      IconButton(
                        onPressed: () => _edit(index),
                        icon: Icon(Icons.edit_outlined, color: colors.mutedText),
                      ),
                      IconButton(
                        onPressed: () => _remove(index),
                        icon: Icon(Icons.delete_outline, color: colors.mutedText),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _edit(int? index) async {
    final l10n = AppLocalizations.of(context)!;
    final current = index == null ? const _PremiumPreset.empty() : _items[index];
    final nameController = TextEditingController(text: current.name);
    final multiplierController = TextEditingController(
      text: current.multiplier == 0 ? '1.50' : current.multiplier.toStringAsFixed(2),
    );
    var startMinute = current.startMinute;
    var endMinute = current.endMinute;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(index == null ? l10n.settingsAddPreset : l10n.settingsEditPreset),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.settingsNameLabel),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.commonStartTime),
                        subtitle: Text(_formatMinute(startMinute)),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: startMinute ~/ 60, minute: startMinute % 60),
                          );
                          if (picked == null) return;
                          setDialogState(() => startMinute = picked.hour * 60 + picked.minute);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.commonEndTime),
                        subtitle: Text(_formatMinute(endMinute)),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: endMinute ~/ 60, minute: endMinute % 60),
                          );
                          if (picked == null) return;
                          setDialogState(() => endMinute = picked.hour * 60 + picked.minute);
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: multiplierController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.settingsMultiplierLabel),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
              FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
            ],
          );
        },
      ),
    );
    if (saved != true) return;
    final name = nameController.text.trim();
    final multiplier = double.tryParse(multiplierController.text.trim().replaceAll(',', '.'));
    if (name.isEmpty || multiplier == null) {
      if (!mounted) return;
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    final next = _PremiumPreset(
      name: name,
      startMinute: startMinute,
      endMinute: endMinute,
      multiplier: multiplier,
    );
    setState(() {
      if (index == null) {
        _items.add(next);
      } else {
        _items[index] = next;
      }
    });
    await _persist();
  }

  Future<void> _remove(int index) async {
    setState(() => _items.removeAt(index));
    await _persist();
  }

  Future<void> _persist() {
    final data = _items.map((e) => e.toJson()).toList();
    return ref.read(settingsRepositoryProvider).set('general_premium_hours', jsonEncode(data));
  }
}

List<String> _readStringList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  } catch (_) {
    return const [];
  }
}

List<_ExpensePreset> _readExpenseList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_ExpensePreset.fromJson)
        .where((e) => e.name.isNotEmpty)
        .toList();
  } catch (_) {
    return const [];
  }
}

List<_PremiumPreset> _readPremiumList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_PremiumPreset.fromJson)
        .where((e) => e.name.isNotEmpty)
        .toList();
  } catch (_) {
    return const [];
  }
}

List<DateTime> _readDateList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<String>()
        .map((e) => DateTime.tryParse(e))
        .whereType<DateTime>()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList();
  } catch (_) {
    return const [];
  }
}

String _formatMinute(int minuteOfDay) {
  final h = (minuteOfDay ~/ 60).toString().padLeft(2, '0');
  final m = (minuteOfDay % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

class _ExpensePreset {
  const _ExpensePreset({
    required this.name,
    required this.amount,
    required this.isDeduction,
  });

  const _ExpensePreset.empty()
      : name = '',
        amount = 0,
        isDeduction = false;

  final String name;
  final double amount;
  final bool isDeduction;

  factory _ExpensePreset.fromJson(Map<String, dynamic> json) {
    return _ExpensePreset(
      name: (json['name'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      isDeduction: json['isDeduction'] == true || json['isDeduction'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'isDeduction': isDeduction,
      };
}

class _PremiumPreset {
  const _PremiumPreset({
    required this.name,
    required this.startMinute,
    required this.endMinute,
    required this.multiplier,
  });

  const _PremiumPreset.empty()
      : name = '',
        startMinute = 9 * 60,
        endMinute = 17 * 60,
        multiplier = 1.5;

  final String name;
  final int startMinute;
  final int endMinute;
  final double multiplier;

  factory _PremiumPreset.fromJson(Map<String, dynamic> json) {
    return _PremiumPreset(
      name: (json['name'] ?? '').toString(),
      startMinute: (json['startMinute'] as num?)?.toInt() ?? 540,
      endMinute: (json['endMinute'] as num?)?.toInt() ?? 1020,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.5,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'startMinute': startMinute,
        'endMinute': endMinute,
        'multiplier': multiplier,
      };
}
