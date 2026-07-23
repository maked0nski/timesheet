import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../utils/form_feedback.dart';
import '../../utils/formatters.dart';
import '../../theme/app_theme.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
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
        title: Text(AppLocalizations.of(context)!.projectTitle),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 14),
          Icon(Icons.filter_list),
          SizedBox(width: 14),
          Icon(Icons.more_vert),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: colors.surface2,
            child: Text(
              AppLocalizations.of(context)!.calendarFilter(AppLocalizations.of(context)!.commonFilterNone),
              style: TextStyle(color: colors.mutedText),
            ),
          ),
          Expanded(
            child: projectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.projectNoProjects));
                }
                return ListView.separated(
                  itemCount: projects.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: colors.border),
                  itemBuilder: (_, index) {
                    final project = projects[index];
                    final title = project.name.isEmpty ? AppLocalizations.of(context)!.projectNoName : project.name;
                    final rate = project.billingType == 'fixed'
                        ? '${fmt.money(project.fixedRate)}/${AppLocalizations.of(context)!.projectTypeFixed}'
                        : '${fmt.money(project.hourlyRate)}/${AppLocalizations.of(context)!.projectTypeHourly}';
                    final subtitle = project.billingType == 'fixed' ? AppLocalizations.of(context)!.projectTypeFixed : AppLocalizations.of(context)!.projectTypeHourly;

                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProjectFormPage(project: project)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(subtitle, style: TextStyle(color: colors.mutedText)),
                                ],
                              ),
                            ),
                            Text(rate, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(AppLocalizations.of(context)!.commonError(e.toString()))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4D6FA2),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProjectFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectFormPage extends ConsumerStatefulWidget {
  const ProjectFormPage({super.key, this.project});

  final Project? project;

  @override
  ConsumerState<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends ConsumerState<ProjectFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _breakController;
  late final TextEditingController _tagController;
  late final TextEditingController _descController;
  late final TextEditingController _rateController;

  int? _selectedClientId;
  String _billingType = 'hourly';
  bool _isBillable = true;
  String _budgetMode = 'none';

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _nameController = TextEditingController(text: p?.name ?? '');
    _startController = TextEditingController(text: '09:00');
    _endController = TextEditingController(text: '17:00');
    _breakController = TextEditingController(text: '${p?.defaultBreakMinutes ?? 0}');
    _tagController = TextEditingController();
    _descController = TextEditingController();
    _rateController = TextEditingController(
      text: (p?.billingType == 'fixed' ? p?.fixedRate : p?.hourlyRate)?.toStringAsFixed(2) ?? '15.00',
    );
    _selectedClientId = p?.clientId;
    _billingType = p?.billingType ?? 'hourly';
    _isBillable = p?.isBillableDefault ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    _breakController.dispose();
    _tagController.dispose();
    _descController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(isEdit ? l10n.projectUpdateTitle : l10n.projectAddTitle),
      ),
      body: FutureBuilder<List<Client>>(
        future: ref.read(clientsRepositoryProvider).activeList(),
        builder: (context, snapshot) {
          final clients = snapshot.data ?? const <Client>[];
          final selectedClientName = _selectedClientId == null
              ? l10n.projectClientAll
              : clients.where((c) => c.id == _selectedClientId).map((c) => c.name).firstOrNull ?? l10n.commonClient;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    _card([
                      _rowEditor(l10n.projectName, _nameController),
                      _rowPicker(l10n.commonClient, selectedClientName, () => _pickClient(clients)),
                      _rowEditor(l10n.commonStartTime, _startController),
                      _rowEditor(l10n.commonEndTime, _endController),
                      _rowEditor(l10n.commonBreak, _breakController, suffix: l10n.commonBreakMinutesSuffix),
                      _rowStatic(l10n.projectRoundHour, l10n.commonFilterNone),
                      _rowEditor(l10n.commonTag, _tagController),
                      _rowEditor(l10n.commonDescription, _descController, maxLines: 2),
                    ]),
                    const SizedBox(height: 10),
                    _typeSection(),
                    const SizedBox(height: 10),
                    _budgetSection(),
                  ],
                ),
              ),
              Container(
                color: colors.surface1,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
                child: SizedBox(
                  width: double.infinity,
                    child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9EB8EA),
                      foregroundColor: Colors.black,
                    ),
                      onPressed: () => _save(isEdit),
                      child: Text(l10n.commonSave),
                    ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _typeSection() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.projectTypeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              _pill(l10n.projectTypeHourly, _billingType == 'hourly', () => setState(() => _billingType = 'hourly')),
              const SizedBox(width: 8),
              _pill(l10n.projectTypeFixed, _billingType == 'fixed', () => setState(() => _billingType = 'fixed')),
            ],
          ),
          const SizedBox(height: 10),
          _pill(l10n.projectNotBillable, !_isBillable, () => setState(() => _isBillable = !_isBillable)),
          const SizedBox(height: 10),
          Text(
            _billingType == 'fixed'
                ? l10n.projectTypeFixedDesc
                : l10n.projectTypeHourlyDesc,
            style: TextStyle(color: colors.mutedText),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(border: Border.all(color: colors.border)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: colors.surface3,
                    padding: const EdgeInsets.all(10),
                    child: Text(_billingType == 'fixed' ? l10n.projectTypeFixed : l10n.projectTypeHourly),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: colors.surface4,
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(border: InputBorder.none, hintText: l10n.projectAmountHint),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_billingType == 'hourly') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: colors.border)),
              child: Text(l10n.projectPremiumStub)
            ),
          ],
        ],
      ),
    );
  }

  Widget _budgetSection() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.projectBudget, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              _pill(l10n.projectNoBudget, _budgetMode == 'none', () => setState(() => _budgetMode = 'none')),
              const SizedBox(width: 8),
              _pill(l10n.projectBudgetHours, _budgetMode == 'hours', () => setState(() => _budgetMode = 'hours')),
            ],
          ),
          const SizedBox(height: 8),
          _pill(l10n.projectBudgetFees, _budgetMode == 'fees', () => setState(() => _budgetMode = 'fees')),
        ],
      ),
    );
  }

  Widget _pill(String text, bool active, VoidCallback onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF5F7192) : colors.surface4,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: colors.border),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.surface2,
        border: Border.all(color: Theme.of(context).extension<AppColors>()!.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _rowEditor(String label, TextEditingController controller, {String? suffix, int maxLines = 1}) {
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: colors.surface4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    decoration: const InputDecoration(border: InputBorder.none),
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
              child: Text(value, style: TextStyle(color: colors.mutedText)),
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

  Future<void> _pickClient(List<Client> clients) async {
    final selected = await showModalBottomSheet<int?>(
      context: context,
      builder: (_) {
        return ListView(
          children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.projectClientAll),
                onTap: () => Navigator.of(context).pop(null),
              ),
            ...clients.map((c) => ListTile(
                  title: Text(c.name),
                  onTap: () => Navigator.of(context).pop(c.id),
                )),
          ],
        );
      },
    );
    if (selected != null || _selectedClientId != selected) {
      setState(() => _selectedClientId = selected);
    }
  }

  Future<void> _save(bool isEdit) async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      FormFeedback.showError(context, l10n.validationRequired(l10n.projectName));
      return;
    }

    final rate = double.tryParse(_rateController.text.trim().replaceAll(',', '.')) ?? 0;
    final breakMinutes = int.tryParse(_breakController.text.trim()) ?? 0;
    if (rate < 0 || breakMinutes < 0) {
      FormFeedback.showError(context, l10n.validationInvalidNumber);
      return;
    }
    final repo = ref.read(projectsRepositoryProvider);

    if (isEdit) {
      final project = widget.project!;
      await repo.update(
        project,
        name: name,
        clientId: _selectedClientId,
        billingType: _billingType,
        hourlyRate: _billingType == 'hourly' ? rate : 0,
        fixedRate: _billingType == 'fixed' ? rate : 0,
        defaultBreakMinutes: breakMinutes,
        isBillableDefault: _isBillable,
        overtimeEnabled: project.overtimeEnabled,
        overtimeAfterMinutes: project.overtimeAfterMinutes,
        overtimeMultiplier: project.overtimeMultiplier,
        nightEnabled: project.nightEnabled,
        nightStartMinute: project.nightStartMinute,
        nightEndMinute: project.nightEndMinute,
        nightMultiplier: project.nightMultiplier,
        holidayEnabled: project.holidayEnabled,
        holidayMultiplier: project.holidayMultiplier,
      );
    } else {
      await repo.create(
        name: name,
        clientId: _selectedClientId,
        billingType: _billingType,
        hourlyRate: _billingType == 'hourly' ? rate : 0,
        fixedRate: _billingType == 'fixed' ? rate : 0,
        defaultBreakMinutes: breakMinutes,
        isBillableDefault: _isBillable,
        overtimeEnabled: false,
        overtimeAfterMinutes: 480,
        overtimeMultiplier: 1.5,
        nightEnabled: false,
        nightStartMinute: 1320,
        nightEndMinute: 360,
        nightMultiplier: 1.25,
        holidayEnabled: false,
        holidayMultiplier: 2.0,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonSave)));
      Navigator.of(context).pop();
    }
  }
}

extension _FirstWhereOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
