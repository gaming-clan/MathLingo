import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../colors.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/cloud_account_deletion_service.dart';
import '../../../core/services/data_export_service.dart';
import '../../../core/services/family_profile_service.dart';
import '../../../core/services/firebase_init_service.dart';
import '../../../core/services/hive_consent_repository.dart';
import '../../../core/sync/sync_service.dart';
import '../../../features/achievements/presentation/badge_display_screen.dart';
import '../../../features/auth/presentation/parent_signin_screen.dart';
import '../../../features/auth/presentation/parent_signup_screen.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/family/presentation/parent_pin_dialog.dart';
import '../../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import 'consent_flow_screen.dart';
import 'delete_all_data_screen.dart';
import 'privacy_policy_screen.dart';

/// P-05 — Ekrani i Cilësimeve. E aksesueshme nga CosmicTopBar.
///
/// Seksionet:
///   1. Gamifikimi (arritjet, klasifikimi)
///   2. Privatësia & të Dhënat (P-01, P-02, P-03)
///   3. Preferencat (audio)
///   4. Rreth Aplikacionit (versioni, kontakti)
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _version = '';
  bool _isExporting = false;
  bool _audioEnabled = AudioService.isEnabled;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = '${info.version}+${info.buildNumber}');
    }
  }

  Future<void> _onExportPressed() async {
    setState(() => _isExporting = true);
    await DataExportService.export(context);
    if (mounted) setState(() => _isExporting = false);
  }

  Future<void> _onInitFirebase(BuildContext ctx, Widget destination) async {
    if (FamilyProfileService.hasParentPin) {
      final ok = await ParentPinDialog.verify(ctx);
      if (!ok || !ctx.mounted) return;
    } else {
      final pinSaved = await SetParentPinDialog.show(ctx);
      if (!pinSaved || !ctx.mounted) return;
    }

    final hasConsent = await HiveConsentRepository.hasValidConsent();
    if (!hasConsent) {
      if (!ctx.mounted) return;
      final granted = await ConsentFlowScreen.show(ctx);
      if (granted != true || !ctx.mounted) return;
    }

    final ok = await FirebaseInitService.initialize();
    if (!ok) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content:
              Text('Shërbimi cloud nuk është konfiguruar. Kontakto ekipin mbështetës.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
        ),
      );
      return;
    }
    if (!ctx.mounted) return;
    Navigator.of(ctx).push(
      MaterialPageRoute<void>(builder: (_) => destination),
    );
  }

  Future<void> _onDeletePressed() async {
    // Kërko PIN para hapjes së ekranit të fshirjes
    if (FamilyProfileService.hasParentPin) {
      final ok = await ParentPinDialog.verify(context);
      if (!ok || !mounted) return;
    }
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DeleteAllDataScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cilësimet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 24),

            // ── Seksioni: Sinkronizimi Cloud ──────────────────────────────────
            _CloudSyncSection(onInitFirebase: _onInitFirebase),
            const SizedBox(height: 24),

            // ── Seksioni: Gamifikimi ─────────────────────────────────────────
            _SectionHeader(label: 'Gamifikimi'),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.military_tech_outlined,
                    title: 'Arritjet',
                    subtitle: 'Shiko insignet kozmike të fituara',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BadgeDisplayScreen(),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: CosmicColors.outlineVariant,
                  ),
                  _SettingsTile(
                    icon: Icons.leaderboard_outlined,
                    title: 'Klasifikimi familjar',
                    subtitle: 'Kush ka mbledhur më shumë pikë?',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LeaderboardScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Seksioni: Preferencat ────────────────────────────────────────
            _SectionHeader(label: 'Preferencat'),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.volume_up_outlined,
                  color: CosmicColors.onSurface,
                  size: 22,
                ),
                title: const Text(
                  'Tingujt',
                  style: TextStyle(
                    color: CosmicColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: const Text(
                  'Feedback audio pas çdo përgjigje',
                  style: TextStyle(
                    color: CosmicColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                value: _audioEnabled,
                activeThumbColor: CosmicColors.secondaryContainer,
                onChanged: (v) {
                  setState(() => _audioEnabled = v);
                  AudioService.setEnabled(v);
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Seksioni: Privatësia & të Dhënat ────────────────────────────
            _SectionHeader(label: 'Privatësia & të Dhënat'),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politika e privatësisë',
                    subtitle: 'Lexo si i trajtojmë të dhënat tuaja',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: CosmicColors.outlineVariant,
                  ),
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    title: 'Shkarko të dhënat',
                    subtitle: 'Eksporto progresin si skedar JSON',
                    trailing: _isExporting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: _isExporting ? null : _onExportPressed,
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: CosmicColors.outlineVariant,
                  ),
                  _SettingsTile(
                    icon: Icons.delete_forever_outlined,
                    title: 'Fshi të gjitha të dhënat',
                    subtitle: 'Fshin çdo profil, progres dhe PIN',
                    iconColor: CosmicColors.error,
                    titleColor: CosmicColors.error,
                    onTap: _onDeletePressed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Seksioni: Rreth Aplikacionit ─────────────────────────────────
            _SectionHeader(label: 'Rreth Aplikacionit'),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'Versioni',
                    subtitle: _version.isEmpty ? '...' : _version,
                    showChevron: false,
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: CosmicColors.outlineVariant,
                  ),
                  _SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Kontakt',
                    subtitle: 'support@mathlingo.app',
                    showChevron: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets ndihmëse
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: CosmicColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor ?? CosmicColors.onSurface,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? CosmicColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: CosmicColors.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing: trailing ??
          (showChevron
              ? const Icon(
                  Icons.chevron_right,
                  color: CosmicColors.onSurfaceVariant,
                )
              : null),
    );
  }
}

// ---------------------------------------------------------------------------
// Seksioni i sinkronizimit cloud
// ---------------------------------------------------------------------------

class _CloudSyncSection extends ConsumerStatefulWidget {
  const _CloudSyncSection({required this.onInitFirebase});

  final Future<void> Function(BuildContext ctx, Widget destination)
      onInitFirebase;

  @override
  ConsumerState<_CloudSyncSection> createState() => _CloudSyncSectionState();
}

class _CloudSyncSectionState extends ConsumerState<_CloudSyncSection> {
  static const _cloudAccountDeletionService = CloudAccountDeletionService();

  bool _hasConsent = false;
  bool _isLoadingConsent = true;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final hasConsent = await HiveConsentRepository.hasValidConsent();
    if (mounted) {
      setState(() {
        _hasConsent = hasConsent;
        _isLoadingConsent = false;
      });
    }
  }

  Future<void> _onSignOut() async {
    await ref.read(authProvider.notifier).signOut();
  }

  Future<void> _onRevokeConsent(BuildContext ctx) async {
    final messenger = ScaffoldMessenger.of(ctx);
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: CosmicColors.surface,
        title: const Text(
          'Çaktivizo sinkronizimin cloud',
          style: TextStyle(color: CosmicColors.onSurface),
        ),
        content: const Text(
          'Kjo do të ndalojë sinkronizimin cloud në këtë pajisje. '
          'Të dhënat lokale mbeten të paprekura.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anulo'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Çaktivizo'),
          ),
        ],
      ),
    );

    if (confirmed != true || !ctx.mounted) return;

    await HiveConsentRepository.revokeConsent();
    if (ref.read(authProvider) is AuthStateAuthenticated) {
      await ref.read(authProvider.notifier).signOut();
    }

    if (!mounted) return;
    setState(() => _hasConsent = false);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Sinkronizimi cloud u çaktivizua për këtë pajisje.'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }

  Future<void> _onDeleteCloudAccount(BuildContext ctx) async {
    final messenger = ScaffoldMessenger.of(ctx);
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: CosmicColors.surface,
        title: const Text(
          'Fshi Llogarinë Cloud',
          style: TextStyle(color: CosmicColors.onSurface),
        ),
        content: const Text(
          'Kjo do të fshijë llogarinë tuaj dhe të gjitha të dhënat nga cloud. Veprimi nuk mund të zhbëhet.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anulo'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
                foregroundColor: CosmicColors.error),
            child: const Text('Fshi'),
          ),
        ],
      ),
    );
    if (confirmed != true || !ctx.mounted) return;

    final authState = ref.read(authProvider);
    if (authState is! AuthStateAuthenticated) return;

    final result = await _cloudAccountDeletionService.deleteAccount(
      uid: authState.account.uid,
      deleteCloudData: (uid) =>
          ref.read(syncServiceProvider).deleteAllUserData(uid),
      deleteAuthAccount: () => ref.read(authProvider.notifier).deleteAccount(),
      revokeConsent: HiveConsentRepository.revokeConsent,
    );
    if (!ctx.mounted) return;

    if (result == CloudAccountDeletionResult.success) {
      if (mounted) {
        setState(() => _hasConsent = false);
      }
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Llogaria cloud dhe të dhënat e saj u fshinë me sukses.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
        ),
      );
      return;
    }

    if (result == CloudAccountDeletionResult.cloudCleanupFailed) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Të dhënat cloud nuk u fshinë ende. Llogaria nuk u prek. Provoni sërish.',
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Fshirja e llogarisë cloud nuk përfundoi. Ju lutem provoni sërish.',
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }

  /// Formatimi shqip i kohës së sinkronizimit.
  static String _formatSyncTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Tani';
    if (diff.inMinutes < 60) return 'Para ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Para ${diff.inHours} orë';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month} $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'Sinkronizimi Cloud'),
        GlassPanel(
          padding: EdgeInsets.zero,
          child: _isLoadingConsent
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : switch (authState) {
            AuthStateAuthenticated(:final account) => Column(
                children: [
                  _SettingsTile(
                    icon: Icons.cloud_done_outlined,
                    title: 'Llogaria Aktive',
                    subtitle: account.email,
                    showChevron: false,
                  ),
                  // B-02: Tregon kohën e sinkronizimit të fundit.
                  if (account.lastSyncAt != null) ...[
                    const Divider(
                        height: 1,
                        indent: 56,
                        color: CosmicColors.outlineVariant),
                    _SettingsTile(
                      icon: Icons.sync_outlined,
                      title: 'Sinkronizuar',
                      subtitle: _formatSyncTime(account.lastSyncAt!),
                      showChevron: false,
                    ),
                  ],
                  const Divider(
                      height: 1,
                      indent: 56,
                      color: CosmicColors.outlineVariant),
                  _SettingsTile(
                    icon: Icons.logout_outlined,
                    title: 'Dil nga llogaria',
                    subtitle: 'Të dhënat lokale mbeten',
                    onTap: _onSignOut,
                  ),
                  const Divider(
                      height: 1,
                      indent: 56,
                      color: CosmicColors.outlineVariant),
                  _SettingsTile(
                    icon: Icons.sync_disabled_outlined,
                    title: 'Çaktivizo sinkronizimin cloud',
                    subtitle: 'Ndalon sinkronizimin pa fshirë të dhënat lokale',
                    onTap: () => _onRevokeConsent(context),
                  ),
                  const Divider(
                      height: 1,
                      indent: 56,
                      color: CosmicColors.outlineVariant),
                  _SettingsTile(
                    icon: Icons.cloud_off_outlined,
                    title: 'Fshi llogarinë në cloud',
                    subtitle: 'Fshin llogarinë dhe të dhënat cloud',
                    iconColor: CosmicColors.error,
                    titleColor: CosmicColors.error,
                    onTap: () => _onDeleteCloudAccount(context),
                  ),
                ],
              ),
            _ => Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_add_outlined,
                    title: 'Krijo llogari prindi',
                    subtitle: 'Rezervo progresin në cloud',
                    onTap: () => widget.onInitFirebase(
                        context, const ParentSignUpScreen()),
                  ),
                  const Divider(
                      height: 1,
                      indent: 56,
                      color: CosmicColors.outlineVariant),
                  _SettingsTile(
                    icon: Icons.login_outlined,
                    title: 'Hyr në llogari',
                    subtitle: 'Sinkronizo midis pajisjeve',
                    onTap: () => widget.onInitFirebase(
                        context, const ParentSignInScreen()),
                  ),
                  if (_hasConsent) ...[
                    const Divider(
                        height: 1,
                        indent: 56,
                        color: CosmicColors.outlineVariant),
                    _SettingsTile(
                      icon: Icons.sync_disabled_outlined,
                      title: 'Hiq pëlqimin për cloud',
                      subtitle: 'Ndalon sinkronizimin derisa të jepet sërish pëlqimi',
                      onTap: () => _onRevokeConsent(context),
                    ),
                  ],
                ],
              ),
          },
        ),
      ],
    );
  }
}
