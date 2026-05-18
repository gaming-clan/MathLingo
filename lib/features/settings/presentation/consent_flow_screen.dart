import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';

/// P-04 — Ekrani i Pelqimit Prindëror për aktivizimin e Cloud Sync.
///
/// Shfaqet para aktivizimit të çdo shërbimi cloud (Sprint 10B).
/// Kthen `true` nëse prindi ka dhënë pelqimin e plotë.
class ConsentFlowScreen extends StatefulWidget {
  const ConsentFlowScreen({super.key});

  /// Hap [ConsentFlowScreen] si dialog të plotë.
  /// Kthen `true` nëse pelqimi u dha, `false` nëse u anulua.
  static Future<bool> show(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (_) => const ConsentFlowScreen(),
      ),
    );
    return result ?? false;
  }

  @override
  State<ConsentFlowScreen> createState() => _ConsentFlowScreenState();
}

class _ConsentFlowScreenState extends State<ConsentFlowScreen> {
  bool _isParent = false;
  bool _hasReadPolicy = false;
  bool _isSaving = false;

  bool get _canProceed => _isParent && _hasReadPolicy;

  Future<void> _onConfirm() async {
    if (!_canProceed) return;
    setState(() => _isSaving = true);
    // Sprint 10B do të ruajë consent-in dhe do të aktivizojë cloud
    // Për tani, kthehemi me true
    if (mounted) Navigator.of(context).pop(true);
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
              'Aktivizo Sinkronizimin',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sinkronizimi cloud ju lejon të aksesoni progresin e fëmijëve '
              'tuaj nga çdo pajisje. Kjo kërkon pelqimin tuaj si prind.',
              style: TextStyle(color: CosmicColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  _ConsentInfo(
                    icon: Icons.cloud_sync,
                    title: 'Çfarë ruhet në cloud',
                    body:
                        'Pseudonimet, pikët dhe progresi i moduleve. '
                        'Asnjë emër real, foto apo të dhënë të ndjeshme.',
                  ),
                  _ConsentInfo(
                    icon: Icons.lock_outline,
                    title: 'Siguria',
                    body:
                        'Të dhënat kodohen gjatë transmetimit. '
                        'Vetëm llogarinë tuaj e prindërit ka akses.',
                  ),
                  _ConsentInfo(
                    icon: Icons.delete_outline,
                    title: 'E drejta e fshirjes',
                    body:
                        'Mund të fshini llogarinë dhe të gjitha të dhënat '
                        'cloud në çdo moment nga Cilësimet.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Checkboxet e pelqimit
            GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _isParent,
                    onChanged: (v) =>
                        setState(() => _isParent = v ?? false),
                    title: const Text(
                      'Jam prind ose kujdestar ligjor i fëmijës',
                      style: TextStyle(
                        color: CosmicColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    activeColor: CosmicColors.secondaryContainer,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: _hasReadPolicy,
                    onChanged: (v) =>
                        setState(() => _hasReadPolicy = v ?? false),
                    title: const Text(
                      'Kam lexuar dhe pranoj Politikën e Privatësisë',
                      style: TextStyle(
                        color: CosmicColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    activeColor: CosmicColors.secondaryContainer,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CosmicButton(
              label: _isSaving ? 'Duke konfirmuar...' : 'Konfirmo dhe Vazhdo',
              onPressed: (_canProceed && !_isSaving) ? _onConfirm : null,
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Anulo — mbaj vetëm lokal',
                  style: TextStyle(color: CosmicColors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget ndihmës
// ---------------------------------------------------------------------------

class _ConsentInfo extends StatelessWidget {
  const _ConsentInfo({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: CosmicColors.secondaryContainer),
      title: Text(
        title,
        style: const TextStyle(
          color: CosmicColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        body,
        style: const TextStyle(
          color: CosmicColors.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// P-07 — Age Verification Gate
// ---------------------------------------------------------------------------

/// Pengesë për fëmijët që tentojnë të aksesojnë funksione prindërore.
///
/// Thirret kur dikush tenton të hapë regjistrim cloud pa konfigurim prindëror.
class AgeVerificationGate {
  AgeVerificationGate._();

  /// Shfaq dialog informues. Kthen `false` gjithmonë (aksesi i refuzuar).
  static Future<bool> showParentRequired(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CosmicColors.surface,
        title: const Text(
          'Kërkohet Prindi',
          style: TextStyle(color: CosmicColors.onSurface),
        ),
        content: const Text(
          'Ky seksion kërkon konfigurim nga prindi ose kujdestari ligjor.\n\n'
          'Lëre prindërin tënd të konfigurojë këtë funksion.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kuptova'),
          ),
        ],
      ),
    );
    return false;
  }
}
