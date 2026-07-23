import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../calendar/calendar_page.dart';
import '../clients/clients_page.dart';
import '../common/stub_page.dart';
import '../data/data_page.dart';
import '../entries/entries_page.dart';
import '../help/app_description_page.dart';
import '../help/contact_developer_page.dart';
import '../projects/projects_page.dart';
import '../settings/settings_page.dart';
import '../statistics/statistics_page.dart';
import '../../theme/app_theme.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.tooltipProjects,
            icon: const Icon(Icons.folder_open_outlined),
            onPressed: () => _open(context, const ProjectsPage()),
          ),
          IconButton(
            tooltip: l10n.tooltipClients,
            icon: const Icon(Icons.person_outline),
            onPressed: () => _open(context, const ClientsPage()),
          ),
          IconButton(
            tooltip: l10n.tooltipAppDescription,
            icon: const Icon(Icons.help_outline),
            onPressed: () => _open(context, const AppDescriptionPage()),
          ),
          IconButton(
            tooltip: l10n.tooltipContactDeveloper,
            icon: const Icon(Icons.mail_outline),
            onPressed: () => _open(context, const ContactDeveloperPage()),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _tile(context, Icons.table_chart_outlined, l10n.menuTime, const EntriesPage()),
                  _tile(context, Icons.calendar_month_outlined, l10n.menuCalendar, const CalendarPage()),
                  _tile(
                    context,
                    Icons.receipt_long_outlined,
                    l10n.menuInvoice,
                    StubPage(title: l10n.menuInvoiceDisabled),
                  ),
                  _tile(context, Icons.bar_chart_outlined, l10n.menuStatistics, const StatisticsPage()),
                  _tile(context, Icons.settings_outlined, l10n.menuSettings, const SettingsPage()),
                  _tile(context, Icons.storage_outlined, l10n.menuData, const DataPage()),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('02/25/2026', style: TextStyle(color: colors.mutedText)),
                    const SizedBox(height: 8),
                    const Center(child: Text('00:00', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700))),
                    Center(child: Text('00:00', style: TextStyle(fontSize: 24, color: colors.mutedText))),
                    const SizedBox(height: 8),
                    Text(l10n.startSampleProject, style: TextStyle(fontSize: 24, color: colors.mutedText)),
                    Text(l10n.startSampleClient, style: TextStyle(fontSize: 22, color: colors.mutedText)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ColoredBox(
                            color: Color(0xFF66CB8E),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(l10n.startStartWork, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ColoredBox(
                            color: Color(0xFF12C3C8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(l10n.startStartedAt, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ColoredBox(
                            color: colors.surface3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text('00:00${l10n.commonHoursSuffix}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                  Text(l10n.startDayLabel, style: TextStyle(color: colors.mutedText)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ColoredBox(
                            color: colors.surface3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text('00:00${l10n.commonHoursSuffix}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                  Text(l10n.startWeekLabel, style: TextStyle(color: colors.mutedText)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget page) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: () => _open(context, page),
      borderRadius: BorderRadius.circular(6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = (constraints.maxWidth * 0.34).clamp(24.0, 36.0);
          final titleSize = (constraints.maxWidth * 0.12).clamp(11.0, 16.0);
          return Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: iconSize, color: colors.mutedText),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
