import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database_provider.dart';
import '../clients/clients_page.dart';
import '../projects/projects_page.dart';
import 'general_catalog_pages.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';

enum _SettingsTab { general, time, preferences, more }

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  _SettingsTab _tab = _SettingsTab.general;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const <String, String>{};
    final colors = Theme.of(context).extension<AppColors>()!;

    bool getBool(String key, bool fallback) {
      final raw = settings[key];
      if (raw == null) return fallback;
      return raw == '1' || raw.toLowerCase() == 'true';
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(_titleFor(_tab)),
      ),
      body: Column(
        children: [
          Container(
            color: colors.surface4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _topTab(icon: Icons.settings_outlined, tab: _SettingsTab.general),
                _topTab(icon: Icons.timer_outlined, tab: _SettingsTab.time),
                _topTab(icon: Icons.tune, tab: _SettingsTab.preferences),
                _topTab(icon: Icons.grid_view, tab: _SettingsTab.more),
              ],
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: colors.surface1,
              child: ListView(
                children: _itemsFor(
                  context: context,
                  tab: _tab,
                  settings: settings,
                  getBool: getBool,
                  onSetBool: _setBool,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topTab({required IconData icon, required _SettingsTab tab}) {
    final active = _tab == tab;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = tab),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: active ? const Color(0xFF9DB8ED) : Colors.transparent, width: 2),
            ),
          ),
          child: Icon(icon, color: active ? const Color(0xFFB7C8ED) : Theme.of(context).extension<AppColors>()!.mutedText),
        ),
      ),
    );
  }

  List<Widget> _itemsFor({
    required BuildContext context,
    required _SettingsTab tab,
    required Map<String, String> settings,
    required bool Function(String key, bool fallback) getBool,
    required Future<void> Function(String key, bool value) onSetBool,
  }) {
    final l10n = AppLocalizations.of(context)!;
    switch (tab) {
      case _SettingsTab.general:
        return [
          _navItem(
            context,
            l10n.settingsClientTitle,
            l10n.settingsClientSubtitle,
            const ClientsPage(),
          ),
          _navItem(
            context,
            l10n.settingsProjectTitle,
            l10n.settingsProjectSubtitle,
            const ProjectsPage(),
          ),
          _navItem(
            context,
            l10n.settingsWorkDescTitle,
            l10n.settingsWorkDescSubtitle,
            const WorkDescriptionsPage(),
          ),
          _navItem(
            context,
            l10n.settingsExpensesTitle,
            l10n.settingsExpensesSubtitle,
            const ExpensesCatalogPage(),
          ),
          _navItem(
            context,
            l10n.settingsHolidayTitle,
            l10n.settingsHolidaySubtitle,
            const HolidayManagementPage(),
          ),
          _navItem(
            context,
            l10n.settingsPremiumTitle,
            l10n.settingsPremiumSubtitle,
            const PremiumHoursCatalogPage(),
          ),
          _navItem(
            context,
            l10n.settingsAfterTimeTitle,
            l10n.settingsAfterTimeSubtitle,
            const AfterSomeTimePage(),
          ),
          _navItem(
            context,
            l10n.settingsTagTitle,
            l10n.settingsTagSubtitle,
            const TagsPage(),
          ),
        ];
      case _SettingsTab.time:
        return [
          _sectionHeader(l10n.settingsTimeSection),
          _switchItem(
            l10n.settingsConfirmStopTitle,
            l10n.settingsConfirmStopSubtitle,
            value: getBool('time_confirm_stop', true),
            onChanged: (v) => onSetBool('time_confirm_stop', v),
          ),
          _switchItem(
            l10n.settingsEditAfterStopTitle,
            l10n.settingsEditAfterStopSubtitle,
            value: getBool('time_edit_after_stop', true),
            onChanged: (v) => onSetBool('time_edit_after_stop', v),
          ),
          _switchItem(
            l10n.settingsSwitchTimerTitle,
            l10n.settingsSwitchTimerSubtitle,
            value: getBool('time_switch_timer', false),
            onChanged: (v) => onSetBool('time_switch_timer', v),
          ),
          _switchItem(
            l10n.settingsCheckinLocationTitle,
            l10n.settingsCheckinLocationSubtitle,
            value: getBool('time_checkin_location', false),
            onChanged: (v) => onSetBool('time_checkin_location', v),
          ),
        ];
      case _SettingsTab.preferences:
        final fmt = AppFormatters(
          locale: AppFormatters.localeFromSettings(settings),
          currencyCode: AppFormatters.currencyFromSettings(settings),
        );
        return [
          _sectionHeader(l10n.prefsDefaultsTitle),
          _switchItem(
            l10n.prefsUseLastTitle,
            l10n.prefsUseLastSubtitle,
            value: getBool('prefs_use_last', true),
            onChanged: (v) => onSetBool('prefs_use_last', v),
          ),
          _switchItem(
            l10n.prefsMonthlyCalendarTitle,
            l10n.prefsMonthlyCalendarSubtitle,
            value: getBool('prefs_month_calendar', true),
            onChanged: (v) => onSetBool('prefs_month_calendar', v),
          ),
          _pickerItem(
            context,
            title: l10n.prefsCurrencyFormatTitle,
            value: fmt.money(1234.56),
            onTap: () => _pickCurrency(context),
          ),
          _pickerItem(
            context,
            title: l10n.prefsDateFormatTitle,
            value: _dateFormatPreview(settings['prefs_date_format'], fmt.locale),
            onTap: () => _pickDateFormat(context),
          ),
          _pickerItem(
            context,
            title: l10n.prefsHoursFormatTitle,
            value: _hoursFormatPreview(settings['prefs_hours_format'], l10n.commonHoursSuffix),
            onTap: () => _pickHoursFormat(context),
          ),
          _switchItem(
            l10n.prefsTimeFormatTitle,
            l10n.prefsTimeFormatSubtitle,
            value: getBool('prefs_24h', true),
            onChanged: (v) => onSetBool('prefs_24h', v),
          ),
          _switchItem(
            l10n.prefsTimePickerStyleTitle,
            l10n.prefsTimePickerStyleSubtitle,
            value: getBool('prefs_time_picker_dial', false),
            onChanged: (v) => onSetBool('prefs_time_picker_dial', v),
          ),
        ];
      case _SettingsTab.more:
        return [
          _sectionHeader(AppLocalizations.of(context)!.localizationSection),
          _pickerItem(
            context,
            title: AppLocalizations.of(context)!.languageLabel,
            value: _localeLabel(settings['app_locale']),
            onTap: () => _pickLocale(context),
          ),
          _pickerItem(
            context,
            title: AppLocalizations.of(context)!.themeLabel,
            value: _themeLabel(settings['app_theme']),
            onTap: () => _pickTheme(context),
          ),
          _sectionHeader(AppLocalizations.of(context)!.moreTabTitle),
          _sectionItem(AppLocalizations.of(context)!.shareLabel, AppLocalizations.of(context)!.shareDescription),
          _sectionItem(AppLocalizations.of(context)!.privacyLabel, ''),
        ];
    }
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionItem(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle.isEmpty ? null : Text(subtitle, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
    );
  }

  Widget _navItem(BuildContext context, String title, String subtitle, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle.isEmpty ? null : Text(subtitle, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).extension<AppColors>()!.mutedText),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)),
    );
  }

  Widget _switchItem(
    String title,
    String subtitle, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
      trailing: Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
      onTap: () => onChanged(!value),
    );
  }

  Future<void> _setBool(String key, bool value) async {
    await ref.read(settingsRepositoryProvider).setBool(key, value);
  }

  String _titleFor(_SettingsTab tab) {
    final l10n = AppLocalizations.of(context)!;
    switch (tab) {
      case _SettingsTab.general:
        return l10n.settingsTabGeneral;
      case _SettingsTab.time:
        return l10n.settingsTabTime;
      case _SettingsTab.preferences:
        return l10n.settingsTabPreferences;
      case _SettingsTab.more:
        return AppLocalizations.of(context)!.moreTabTitle;
    }
  }

  Widget _pickerItem(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right, color: Theme.of(context).extension<AppColors>()!.mutedText),
        ],
      ),
      onTap: onTap,
    );
  }

  String _localeLabel(String? code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'en_US':
        return l10n.languageNameEng;
      case 'pl_PL':
        return l10n.languageNamePl;
      case 'uk_UA':
      default:
        return l10n.languageNameUkr;
    }
  }

  String _dateFormatPreview(String? pattern, Locale locale) {
    final fmt = DateFormat(pattern ?? 'MM/dd/yyyy', locale.toLanguageTag());
    return fmt.format(DateTime(2026, 1, 31));
  }

  String _hoursFormatPreview(String? pattern, String suffix) {
    final fmt = DateFormat(pattern ?? 'HH:mm');
    return '${fmt.format(DateTime(2000, 1, 1, 3, 45))}$suffix';
  }

  String _themeLabel(String? code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'light':
        return l10n.themeLight;
      case 'dark':
        return l10n.themeDark;
      default:
        return l10n.themeSystem;
    }
  }

  Future<void> _pickLocale(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _localeTile(l10n.languageNameUkr, 'uk_UA'),
            _localeTile(l10n.languageNameEng, 'en_US'),
            _localeTile(l10n.languageNamePl, 'pl_PL'),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(settingsRepositoryProvider).set('app_locale', selected);
  }

  Widget _localeTile(String label, String code) {
    return ListTile(
      title: Text(label),
      onTap: () => Navigator.of(context).pop(code),
    );
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _currencyTile(l10n.currencyGbp, 'GBP'),
            _currencyTile(l10n.currencyEur, 'EUR'),
            _currencyTile(l10n.currencyUsd, 'USD'),
            _currencyTile(l10n.currencyUah, 'UAH'),
            _currencyTile(l10n.currencyPln, 'PLN'),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(settingsRepositoryProvider).set('app_currency', selected);
  }

  Future<void> _pickDateFormat(BuildContext context) async {
    final locale = AppFormatters.localeFromSettings(ref.read(settingsProvider).valueOrNull ?? const <String, String>{});
    final options = [
      'MM/dd/yyyy',
      'dd.MM.yyyy',
      'yyyy-MM-dd',
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map(
                (pattern) => ListTile(
                  title: Text(DateFormat(pattern, locale.toLanguageTag()).format(DateTime(2026, 1, 31))),
                  onTap: () => Navigator.of(context).pop(pattern),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(settingsRepositoryProvider).set('prefs_date_format', selected);
  }

  Future<void> _pickHoursFormat(BuildContext context) async {
    final options = [
      'HH:mm',
      'H:mm',
    ];
    final suffix = AppLocalizations.of(context)!.commonHoursSuffix;
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map(
                (pattern) => ListTile(
                  title: Text('${DateFormat(pattern).format(DateTime(2000, 1, 1, 3, 45))}$suffix'),
                  onTap: () => Navigator.of(context).pop(pattern),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(settingsRepositoryProvider).set('prefs_hours_format', selected);
  }

  Future<void> _pickTheme(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeTile(l10n.themeSystem, 'system'),
            _themeTile(l10n.themeDark, 'dark'),
            _themeTile(l10n.themeLight, 'light'),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await ref.read(settingsRepositoryProvider).set('app_theme', selected);
  }

  Widget _themeTile(String label, String code) {
    return ListTile(
      title: Text(label),
      onTap: () => Navigator.of(context).pop(code),
    );
  }

  Widget _currencyTile(String label, String code) {
    return ListTile(
      title: Text(label),
      onTap: () => Navigator.of(context).pop(code),
    );
  }
}
