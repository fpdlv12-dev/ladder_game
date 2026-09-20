import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../services/settings.dart';
import '../widgets/banner_ad_widget.dart';

const kPrivacyPolicyUrl =
    'https://fpdlv12-dev.github.io/ladder_game/privacy-policy.html';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final cs = Theme.of(context).colorScheme;
    final settings = AppScope.of(context).settings;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      bottomNavigationBar: const BannerAdWidget(),
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _section(context, t.settingsGame),
            Text(t.settingsAnimSpeed, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            SegmentedButton<AnimSpeed>(
              segments: [
                ButtonSegment(value: AnimSpeed.slow, label: Text(t.speedSlow)),
                ButtonSegment(
                  value: AnimSpeed.normal,
                  label: Text(t.speedNormal),
                ),
                ButtonSegment(value: AnimSpeed.fast, label: Text(t.speedFast)),
              ],
              selected: {settings.speed},
              onSelectionChanged: (s) => settings.speed = s.first,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.settingsRevealResults),
              subtitle: Text(t.settingsRevealResultsSubtitle),
              value: settings.revealResults,
              onChanged: (v) => settings.revealResults = v,
            ),
            const Divider(height: 32),
            _section(context, t.settingsAbout),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snap) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline),
                title: Text(t.appTitle),
                subtitle: Text(
                  t.settingsVersion(
                    snap.hasData
                        ? '${snap.data!.version} (${snap.data!.buildNumber})'
                        : '…',
                  ),
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(t.settingsPrivacy),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => launchUrl(
                Uri.parse(kPrivacyPolicyUrl),
                mode: LaunchMode.externalApplication,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description_outlined),
              title: Text(t.settingsLicenses),
              onTap: () => showLicensePage(
                context: context,
                applicationName: t.appTitle,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t.settingsDataNote,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
