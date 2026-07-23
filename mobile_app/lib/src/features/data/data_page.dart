import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../data/db/database_provider.dart';
import '../../theme/app_theme.dart';

class DataPage extends ConsumerStatefulWidget {
  const DataPage({super.key});

  @override
  ConsumerState<DataPage> createState() => _DataPageState();
}

class _DataPageState extends ConsumerState<DataPage> {
  bool _autoBackup = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.surface1,
        title: Text(AppLocalizations.of(context)!.dataTitle),
      ),
      body: ListView(
        children: [
          _SectionHeader(AppLocalizations.of(context)!.dataAutoBackupTitle),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.dataAutoBackupTitle),
            subtitle: Text(
              AppLocalizations.of(context)!.dataAutoBackupSubtitle,
              style: TextStyle(color: colors.mutedText),
            ),
            value: _autoBackup,
            onChanged: (v) => setState(() => _autoBackup = v),
          ),
          _actionTile(
            AppLocalizations.of(context)!.dataCreateBackup,
            AppLocalizations.of(context)!.dataCreateBackupSubtitle,
            _backup,
          ),
          _actionTile(
            AppLocalizations.of(context)!.dataRestoreBackup,
            AppLocalizations.of(context)!.dataRestoreBackupSubtitle,
            _restore,
          ),
          _actionTile(
            AppLocalizations.of(context)!.dataEmailBackup,
            AppLocalizations.of(context)!.dataEmailBackupSubtitle,
            _showBackupDir,
          ),
          _actionTile(
            AppLocalizations.of(context)!.dataDeleteAll,
            AppLocalizations.of(context)!.dataDeleteAllSubtitle,
            _clearAll,
          ),
          _SectionHeader(AppLocalizations.of(context)!.dataRecentBackups),
          FutureBuilder(
            future: ref.read(dataRepositoryProvider).backupsDirectory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: LinearProgressIndicator(minHeight: 2),
                );
              }
              final dir = snapshot.data!;
              final files = dir
                  .listSync()
                  .whereType<File>()
                  .where((f) => f.path.endsWith('.sqlite'))
                  .toList()
                ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
              if (files.isEmpty) {
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.dataNoBackupsTitle),
                  subtitle: Text(AppLocalizations.of(context)!.dataNoBackupsSubtitle),
                );
              }
              return Column(
                children: files.take(8).map((f) {
                  final stat = f.statSync();
                  return ListTile(
                    title: Text(f.path.split('\\').last),
                    subtitle: Text(stat.modified.toString()),
                    trailing: const Icon(Icons.restore),
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.dataRestoreConfirmTitle),
                          content: Text(AppLocalizations.of(context)!.dataRestoreConfirmBody),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocalizations.of(context)!.commonCancel)),
                            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocalizations.of(context)!.dataRestoreConfirmTitle)),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      await ref.read(dataRepositoryProvider).restoreBackup(f);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.dataRestored)));
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionTile(String title, String subtitle, Future<void> Function() onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).extension<AppColors>()!.mutedText)),
      onTap: onTap,
    );
  }

  Future<void> _backup() async {
    final file = await ref.read(dataRepositoryProvider).createBackup();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppLocalizations.of(context)!.dataBackupCreated}: ${file.path}')),
    );
  }

  Future<void> _restore() async {
    final file = await ref.read(dataRepositoryProvider).restoreLatestBackup();
    if (!mounted) return;
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.dataBackupNotFound)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.dataRestoredRestart)),
    );
  }

  Future<void> _showBackupDir() async {
    final dir = await ref.read(dataRepositoryProvider).backupsDirectory();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppLocalizations.of(context)!.dataBackupFolderLabel}: ${dir.path}')),
    );
  }

  Future<void> _clearAll() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.dataConfirmTitle),
        content: Text(AppLocalizations.of(context)!.dataConfirmDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocalizations.of(context)!.commonNo)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocalizations.of(context)!.commonYes)),
        ],
      ),
    );
    if (yes != true) return;
    await ref.read(dataRepositoryProvider).clearAllData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.dataCleared)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(text, style: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w700)),
    );
  }
}
