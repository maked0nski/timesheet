import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/db/database_provider.dart';

class FiltersBar extends ConsumerWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final clientId = ref.watch(selectedClientFilterProvider);
    final projectId = ref.watch(selectedProjectFilterProvider);
    final from = ref.watch(selectedFromDateProvider);
    final to = ref.watch(selectedToDateProvider);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: clientsAsync.when(
                    data: (clients) => DropdownButtonFormField<int?>(
                      initialValue: clientId,
                      decoration: const InputDecoration(labelText: 'Client'),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('All clients')),
                        ...clients.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name))),
                      ],
                      onChanged: (value) => ref.read(selectedClientFilterProvider.notifier).state = value,
                    ),
                    loading: () => const SizedBox(height: 56),
                    error: (_, _) => const SizedBox(height: 56),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: projectsAsync.when(
                    data: (projects) => DropdownButtonFormField<int?>(
                      initialValue: projectId,
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('All projects')),
                        ...projects.map((p) => DropdownMenuItem<int?>(value: p.id, child: Text(p.name))),
                      ],
                      onChanged: (value) => ref.read(selectedProjectFilterProvider.notifier).state = value,
                    ),
                    loading: () => const SizedBox(height: 56),
                    error: (_, _) => const SizedBox(height: 56),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: from ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        ref.read(selectedFromDateProvider.notifier).state = DateTime(picked.year, picked.month, picked.day);
                      }
                    },
                    icon: const Icon(Icons.date_range),
                    label: Text(from == null ? 'From' : DateFormat('dd.MM.yyyy').format(from)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: to ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        ref.read(selectedToDateProvider.notifier).state = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
                      }
                    },
                    icon: const Icon(Icons.date_range),
                    label: Text(to == null ? 'To' : DateFormat('dd.MM.yyyy').format(to)),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    ref.read(selectedClientFilterProvider.notifier).state = null;
                    ref.read(selectedProjectFilterProvider.notifier).state = null;
                    ref.read(selectedFromDateProvider.notifier).state = null;
                    ref.read(selectedToDateProvider.notifier).state = null;
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
