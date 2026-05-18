import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';

/// P-01 — Politika e Privatësisë brenda aplikacionit (GDPR Neni 13).
///
/// Gjuhë e thjeshtë shqipe, max ~300 fjalë.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 680,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _PolicySection(
              title: 'Politika e Privatësisë',
              subtitle: 'Versioni 1.0 · Maj 2026',
            ),
            _PolicyBlock(
              heading: 'Çfarë mblidhet',
              body:
                  'MathLingo ruan vetëm të dhënat e nevojshme për të '
                  'personalizuar përvojën mësimore:\n\n'
                  '• Pseudonimet e fëmijëve (jo emra realë)\n'
                  '• Pikët, saktësia dhe historia e moduleve mësimore\n'
                  '• PIN-i prindëror (ruhet vetëm lokalisht)\n'
                  '• Tabela e zgjedhur dhe preferencat e mënyrës së luajtjes',
            ),
            _PolicyBlock(
              heading: 'Pse mblidhen',
              body:
                  'Të dhënat përdoren vetëm brenda familjes suaj lokale: '
                  'për të ndarë progresin mes profileve të fëmijëve dhe '
                  'për të adaptuar nivelin e vështirësisë sipas performancës.',
            ),
            _PolicyBlock(
              heading: 'Kush ka akses',
              body:
                  'Vetëm familja juaj lokale. MathLingo nuk dërgon asnjë '
                  'të dhënë në internet — gjithçka ruhet vetëm në pajisjen '
                  'tuaj. Asnjë server i jashtëm nuk ka akses në këto të dhëna.',
            ),
            _PolicyBlock(
              heading: 'Si fshihet (GDPR Neni 17)',
              body:
                  'Cilësimet → "Fshi të Gjitha të Dhënat".\n\n'
                  'Ky veprim fshin çdo profil, progres dhe PIN nga pajisja '
                  'juaj dhe nuk mund të kthehet.',
            ),
            _PolicyBlock(
              heading: 'Si eksportohet (GDPR Neni 20)',
              body:
                  'Cilësimet → "Shkarko të Dhënat".\n\n'
                  'Merrni një skedar JSON me të gjitha të dhënat tuaja '
                  'për transferim ose arkivim sipas dëshirës tuaj.',
            ),
            _PolicyBlock(
              heading: 'Të drejtat e fëmijëve',
              body:
                  'Si prind ose kujdestar ligjor, keni të drejtë të '
                  'aksesoni, ndryshoni ose fshini çdo të dhënë të fëmijëve '
                  'tuaj në çdo kohë. Asnjë të dhënë nuk kalohet te palë të '
                  'treta pa pelqimin tuaj eksplicit.',
            ),
            _PolicyBlock(
              heading: 'Kontakti',
              body: 'Për çdo pyetje lidhur me privatësinë:\n'
                  'support@mathlingo.app',
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

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CosmicColors.primaryContainer,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyBlock extends StatelessWidget {
  const _PolicyBlock({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              color: CosmicColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
