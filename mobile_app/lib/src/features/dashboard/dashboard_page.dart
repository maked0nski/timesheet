import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/database_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/filters_bar.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardProvider);
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    final fmt = AppFormatters(
      locale: AppFormatters.localeFromSettings(settings),
      currencyCode: AppFormatters.currencyFromSettings(settings),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: summaryAsync.when(
        data: (summary) {
          return Column(
            children: [
              const FiltersBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _card(
                      title: 'Hours',
                      items: [
                        'Total: ${summary.totalHoursLabel}',
                        'Paid: ${summary.paidHoursLabel}',
                        'Unpaid: ${summary.unpaidHoursLabel}',
                      ],
                    ),
                    _card(
                      title: 'Amount',
                      items: [
                        'Total: ${fmt.money(summary.totalAmount)}',
                        'Paid: ${fmt.money(summary.paidAmount)}',
                        'Unpaid: ${fmt.money(summary.unpaidAmount)}',
                        'Pending: ${fmt.money(summary.uninvoicedAmount)}',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(AppLocalizations.of(context)!.commonError(e.toString()))),
      ),
    );
  }

  Widget _card({required String title, required List<String> items}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(item),
                )),
          ],
        ),
      ),
    );
  }
}
