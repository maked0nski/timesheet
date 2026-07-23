import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class AppDescriptionPage extends StatelessWidget {
  const AppDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          l10n.helpContent,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
      ),
    );
  }
}
