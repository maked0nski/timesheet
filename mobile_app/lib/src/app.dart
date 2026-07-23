import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import 'data/db/database_provider.dart';
import 'features/home/start_page.dart';
import 'theme/app_theme.dart';
import 'utils/formatters.dart';

class TimesheetApp extends ConsumerWidget {
  const TimesheetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull ?? const <String, String>{};
    final locale = AppFormatters.localeFromSettings(settings);
    final themeMode = _themeModeFromSettings(settings['app_theme']);
    Intl.defaultLocale = locale.toLanguageTag();
    return MaterialApp(
      title: 'Timesheet',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      themeMode: themeMode,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const StartPage(),
    );
  }
}

ThemeMode _themeModeFromSettings(String? raw) {
  switch (raw) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
