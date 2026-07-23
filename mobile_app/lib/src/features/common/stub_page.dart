import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class StubPage extends StatelessWidget {
  const StubPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          l10n.stubInProgress(title),
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
