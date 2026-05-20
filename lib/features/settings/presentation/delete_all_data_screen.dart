import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../core/services/achievement_service.dart';
import '../../../core/services/family_profile_service.dart';
import '../../../core/services/firebase_init_service.dart';
import '../../../core/services/hive_consent_repository.dart';
import '../../../core/sync/sync_service.dart';
import '../../../responsive.dart';
import '../../../shared/utils/user_progress_storage.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../auth/providers/auth_provider.dart';
import '../../family/presentation/parent_pin_dialog.dart';
import '../../family/presentation/family_setup_screen.dart';

/// P-02 — Fshirja e plotë e të dhënave (GDPR Neni 17).
class DeleteAllDataScreen extends ConsumerStatefulWidget {
  const DeleteAllDataScreen({super.key});

  @override
  ConsumerState<DeleteAllDataScreen> createState() =>
      _DeleteAllDataScreenState();
}

class _DeleteAllDataScreenState extends ConsumerState<DeleteAllDataScreen> {
  bool _isDeleting = false;

  Future<void> _onDeletePressed() async {
    // Nëse ka PIN, kërko verifikim para fshirjes
    if (FamilyProfileService.hasParentPin) {
      final pinOk = await ParentPinDialog.verify(context);
      if (!pinOk || !mounted) return;
    }

    // Dialog konfirmimi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CosmicColors.surface,
        title: const Text(
          'Konfirmo fshirjen',
          style: TextStyle(color: CosmicColors.onSurface),
        ),
        content: const Text(
          'Të gjitha profilet, progresi dhe PIN-i do të fshihen '
          'përgjithmonë.\n\nKy veprim NUK mund të kthehet.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anulo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Fshi Gjithçka',
              style: TextStyle(color: CosmicColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    final messenger = ScaffoldMessenger.of(context);

    // Mblidh child IDs para se të fshihet familja
    final family = FamilyProfileService.loadFamily();
    final childIds = family?.children.map((c) => c.id).toList() ?? [];

    // Fshi të dhënat cloud nëse prindi është i kyçur (GDPR Neni 17)
    if (FirebaseInitService.isInitialized) {
      final authState = ref.read(authProvider);
      if (authState is AuthStateAuthenticated) {
        final deletedCloudData = await ref
            .read(syncServiceProvider)
            .deleteAllUserData(authState.account.uid);
        if (!deletedCloudData) {
          if (mounted) {
            setState(() => _isDeleting = false);
          }
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Të dhënat cloud nuk u fshinë. Fshirja totale u ndal për të shmangur gjendje të pjesshme.',
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
            ),
          );
          return;
        }
        await ref.read(authProvider.notifier).signOut();
      }
    }

    // Fshi progresin per cdo femije
    await UserProgressStorage.deleteAllData(childIds: childIds);
    await AchievementService.deleteAllData(childIds: childIds);

    // Fshi edhe consent-in e ruajtur lokalisht.
    await HiveConsentRepository.revokeConsent();

    // Fshi të dhënat familjare (profil + PIN)
    await FamilyProfileService.deleteAllData();

    // Rifreskо providerin
    if (mounted) {
      ref.invalidate(familyProvider);
    }

    if (!mounted) return;

    // Navigo tek setup-i i parë, duke hequr gjithë stack-un
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => FamilySetupScreen(
          onComplete: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (_) => false,
          ),
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fshi të Gjitha të Dhënat',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.error,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ky veprim fshin çdo gjë nga pajisja juaj dhe nuk mund të kthehet.',
              style: TextStyle(color: CosmicColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _WipeItem(
                    icon: Icons.people,
                    label: 'Të gjitha profilet e fëmijëve',
                  ),
                  _WipeItem(
                    icon: Icons.trending_up,
                    label: 'I gjithë progresi dhe pikët',
                  ),
                  _WipeItem(
                    icon: Icons.lock,
                    label: 'PIN-i prindëror',
                  ),
                  _WipeItem(
                    icon: Icons.history,
                    label: 'Historia e sesioneve',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CosmicColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                ),
                onPressed: _isDeleting ? null : _onDeletePressed,
                child: Text(
                  _isDeleting ? 'Duke fshirë...' : 'Fshi Gjithçka',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WipeItem extends StatelessWidget {
  const _WipeItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: CosmicColors.error),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.onSurface,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
