import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../utils/form_feedback.dart';
import '../../utils/formatters.dart';
import '../../theme/app_theme.dart';

class ClientsPage extends ConsumerWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(AppLocalizations.of(context)!.clientTitle),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 14),
          Icon(Icons.filter_list),
          SizedBox(width: 14),
          Icon(Icons.image_outlined),
          SizedBox(width: 10),
        ],
      ),
      body: clientsAsync.when(
        data: (clients) {
          if (clients.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.clientNoClients));
          }
          final sorted = [...clients]
            ..sort((a, b) {
              if (a.isDefaultClient != b.isDefaultClient) {
                return a.isDefaultClient ? -1 : 1;
              }
              return a.name.toLowerCase().compareTo(b.name.toLowerCase());
            });

          return ListView.separated(
            itemCount: sorted.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: colors.border),
            itemBuilder: (_, index) {
              final client = sorted[index];
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ClientQuickInfoPage(clientId: client.id)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.name, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w600)),
                      if ((client.description ?? '').trim().isNotEmpty)
                        Text(client.description!.trim(), style: TextStyle(color: colors.mutedText)),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4D6FA2),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ClientFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientFormPage extends ConsumerStatefulWidget {
  const ClientFormPage({super.key, this.client});

  final Client? client;

  @override
  ConsumerState<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends ConsumerState<ClientFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _geolocationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _nameController = TextEditingController(text: c?.name ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _geolocationController = TextEditingController(text: c?.geolocation ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _geolocationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.client != null;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(isEdit ? AppLocalizations.of(context)!.clientUpdateTitle : AppLocalizations.of(context)!.clientAddTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _card([
                  _rowEditor(AppLocalizations.of(context)!.clientName, _nameController, hint: AppLocalizations.of(context)!.clientNameHint),
                  _rowEditor(AppLocalizations.of(context)!.clientAddress, _addressController),
                  _rowEditor(AppLocalizations.of(context)!.clientGeo, _geolocationController),
                  _rowEditor(AppLocalizations.of(context)!.clientPhone, _phoneController, keyboardType: TextInputType.phone),
                  _rowEditor(AppLocalizations.of(context)!.clientEmail, _emailController, keyboardType: TextInputType.emailAddress),
                  _rowEditor(AppLocalizations.of(context)!.clientDesc, _descriptionController, maxLines: 2),
                ]),
              ],
            ),
          ),
          Container(
            color: colors.surface1,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
            child: Row(
              children: [
                if (isEdit) ...[
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3B54),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _delete,
                      child: Text(AppLocalizations.of(context)!.commonDelete),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9EB8EA),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _save,
                    child: Text(AppLocalizations.of(context)!.commonSave),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _rowEditor(
    String label,
    TextEditingController controller, {
    String? hint,
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: colors.surface4),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: colors.mutedText),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final repo = ref.read(clientsRepositoryProvider);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      FormFeedback.showError(context, AppLocalizations.of(context)!.validationRequired(AppLocalizations.of(context)!.clientName));
      return;
    }
    final normalizedName = name.length > 30 ? name.substring(0, 30) : name;
    final address = _toNullable(_addressController.text);
    final geolocation = _toNullable(_geolocationController.text);
    final phone = _toNullable(_phoneController.text);
    final email = _toNullable(_emailController.text);
    final description = _toNullable(_descriptionController.text);

    if (widget.client == null) {
      await repo.create(
        name: normalizedName,
        address: address,
        geolocation: geolocation,
        phone: phone,
        email: email,
        description: description,
      );
    } else {
      await repo.update(
        widget.client!,
        name: normalizedName,
        address: address,
        geolocation: geolocation,
        phone: phone,
        email: email,
        description: description,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.commonSave)));
      Navigator.of(context).pop();
    }
  }

  Future<void> _delete() async {
    final client = widget.client;
    if (client == null) return;
    await ref.read(clientsRepositoryProvider).delete(client.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.commonDelete)));
      Navigator.of(context).pop();
    }
  }

  String? _toNullable(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}

class ClientQuickInfoPage extends ConsumerWidget {
  const ClientQuickInfoPage({super.key, required this.clientId});

  final int clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final entriesAsync = ref.watch(entriesProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    final fmt = AppFormatters(
      locale: AppFormatters.localeFromSettings(settings),
      currencyCode: AppFormatters.currencyFromSettings(settings),
    );

    return clientsAsync.when(
      data: (clients) {
        final l10n = AppLocalizations.of(context)!;
        final client = clients.where((c) => c.id == clientId).firstOrNull;
        if (client == null) {
          return Scaffold(
            body: Center(child: Text(l10n.clientNotFound)),
          );
        }

        return entriesAsync.when(
          data: (entries) {
            final filtered = entries.where((e) => e.clientId == client.id).toList();
            final projects = projectsAsync.valueOrNull ?? const <Project>[];
            final metrics = _ClientMetrics.build(
              client: client,
              entries: filtered,
              projects: projects,
              money: fmt.money,
              projectFallback: (id) => l10n.clientProjectFallback(id.toString()),
              hoursSuffix: l10n.commonHoursSuffix,
            );

            return Scaffold(
              backgroundColor: colors.bg,
              appBar: AppBar(
                backgroundColor: colors.surface1,
                title: Text(l10n.clientQuickInfoTitle),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ClientFormPage(client: client)),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  const Icon(Icons.copy_outlined),
                  const SizedBox(width: 10),
                  const Icon(Icons.more_vert),
                  const SizedBox(width: 6),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  _titleCard(context, client, colors),
                  const SizedBox(height: 10),
                  _tripleCard(
                    l10n.clientHoursTitle,
                    metrics.totalHours,
                    metrics.paidHours,
                    metrics.unpaidHours,
                    l10n.clientTotalLabel,
                    l10n.clientPaidLabel,
                    l10n.clientUnpaidLabel,
                    colors,
                  ),
                  const SizedBox(height: 10),
                  _tripleCard(
                    l10n.commonAmount,
                    metrics.totalAmount,
                    metrics.paidAmount,
                    metrics.unpaidAmount,
                    l10n.clientTotalLabel,
                    l10n.clientPaidLabel,
                    l10n.clientUnpaidLabel,
                    colors,
                  ),
                  const SizedBox(height: 10),
                  _tripleCard(
                    l10n.clientIncomeTitle,
                    metrics.workIncome,
                    metrics.expenses,
                    metrics.distance,
                    l10n.clientWorkLabel,
                    l10n.clientExpensesLabel,
                    l10n.clientMileageLabel,
                    colors,
                  ),
                  const SizedBox(height: 10),
                  _tripleCard(
                    l10n.clientInvoiceTitle,
                    metrics.invoicedPaid,
                    metrics.invoicedUnpaid,
                    metrics.uninvoiced,
                    l10n.clientPaidLabel,
                    l10n.clientUnpaidLabel,
                    l10n.clientExpectedLabel,
                    colors,
                  ),
                  const SizedBox(height: 10),
                  _tripleCard(
                    l10n.clientEffectiveRateTitle,
                    metrics.workIncome,
                    metrics.totalHours,
                    metrics.effectiveRate,
                    l10n.clientWorkLabel,
                    l10n.clientTotalHoursLabel,
                    l10n.clientPerHourLabel,
                    colors,
                  ),
                  if (metrics.projects.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: colors.surface2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.commonProject, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          ...metrics.projects.map(
                            (row) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${row.projectName}  ${fmt.money(row.amount)}/${_hours(row.minutes, l10n.commonHoursSuffix)}',
                                style: TextStyle(color: colors.mutedText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.commonError(e.toString())))),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.commonError(e.toString())))),
    );
  }

  Widget _titleCard(BuildContext context, Client client, AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: colors.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(client.name, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(AppLocalizations.of(context)!.clientStatusLabel, style: TextStyle(color: colors.mutedText)),
              const Spacer(),
              Text(AppLocalizations.of(context)!.clientStatusActive, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          if ((client.description ?? '').trim().isNotEmpty)
            Text(client.description!.trim(), style: TextStyle(color: colors.mutedText)),
        ],
      ),
    );
  }

  Widget _tripleCard(
    String title,
    String value1,
    String value2,
    String value3,
    String label1,
    String label2,
    String label3,
    AppColors colors,
  ) {
    Widget cell(String value, String label) {
      return Expanded(
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: colors.mutedText)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      color: colors.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              cell(value1, label1),
              cell(value2, label2),
              cell(value3, label3),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClientMetrics {
  const _ClientMetrics({
    required this.totalHours,
    required this.paidHours,
    required this.unpaidHours,
    required this.totalAmount,
    required this.paidAmount,
    required this.unpaidAmount,
    required this.workIncome,
    required this.expenses,
    required this.distance,
    required this.invoicedPaid,
    required this.invoicedUnpaid,
    required this.uninvoiced,
    required this.effectiveRate,
    required this.projects,
  });

  final String totalHours;
  final String paidHours;
  final String unpaidHours;
  final String totalAmount;
  final String paidAmount;
  final String unpaidAmount;
  final String workIncome;
  final String expenses;
  final String distance;
  final String invoicedPaid;
  final String invoicedUnpaid;
  final String uninvoiced;
  final String effectiveRate;
  final List<_ClientProjectRow> projects;

  static _ClientMetrics build({
    required Client client,
    required List<TimeEntry> entries,
    required List<Project> projects,
    required String Function(num) money,
    required String Function(int id) projectFallback,
    required String hoursSuffix,
  }) {
    var totalMinutes = 0;
    var paidMinutes = 0;
    var unpaidMinutes = 0;
    var totalAmount = 0.0;
    var paidAmount = 0.0;
    var unpaidAmount = 0.0;
    var uninvoicedAmount = 0.0;
    final byProject = <int, _ProjectAcc>{};

    for (final e in entries) {
      totalMinutes += e.workedMinutes;
      totalAmount += e.amount;
      final acc = byProject.putIfAbsent(e.projectId, () => _ProjectAcc());
      acc.amount += e.amount;
      acc.minutes += e.workedMinutes;
      if (e.isPaid) {
        paidMinutes += e.workedMinutes;
        paidAmount += e.amount;
      } else if (e.isBillable) {
        unpaidMinutes += e.workedMinutes;
        unpaidAmount += e.amount;
      }
      if (e.isBillable && !e.isPaid) {
        uninvoicedAmount += e.amount;
      }
    }
    final invoicedPaid = paidAmount;
    final invoicedUnpaid = unpaidAmount;

    final namesById = {for (final p in projects) p.id: p.name};
    final projectRows = byProject.entries
        .map(
          (e) => _ClientProjectRow(
            projectName: namesById[e.key] ?? projectFallback(e.key),
            amount: e.value.amount,
            minutes: e.value.minutes,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final effectiveRate = totalMinutes == 0 ? 0 : totalAmount / (totalMinutes / 60);

    return _ClientMetrics(
      totalHours: _hours(totalMinutes, hoursSuffix),
      paidHours: _hours(paidMinutes, hoursSuffix),
      unpaidHours: _hours(unpaidMinutes, hoursSuffix),
      totalAmount: money(totalAmount),
      paidAmount: money(paidAmount),
      unpaidAmount: money(unpaidAmount),
      workIncome: money(totalAmount),
      expenses: money(0),
      distance: money(0),
      invoicedPaid: money(invoicedPaid),
      invoicedUnpaid: money(invoicedUnpaid),
      uninvoiced: money(uninvoicedAmount),
      effectiveRate: money(effectiveRate),
      projects: projectRows,
    );
  }
}

class _ClientProjectRow {
  const _ClientProjectRow({
    required this.projectName,
    required this.amount,
    required this.minutes,
  });

  final String projectName;
  final double amount;
  final int minutes;
}

class _ProjectAcc {
  double amount = 0;
  int minutes = 0;
}

String _hours(int minutes, String suffix) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}$suffix';
}

extension _FirstWhereOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
