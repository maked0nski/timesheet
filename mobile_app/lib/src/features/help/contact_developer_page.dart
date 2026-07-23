import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ContactDeveloperPage extends StatelessWidget {
  const ContactDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contactTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.contactHeader, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('${l10n.contactEmailLabel}: developer@timesheet.local'),
            const SizedBox(height: 8),
            Text('${l10n.contactTelegramLabel}: @timesheet_support'),
            const SizedBox(height: 8),
            Text(l10n.contactBody),
          ],
        ),
      ),
    );
  }
}
