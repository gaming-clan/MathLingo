import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/services/hive_consent_repository.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';

/// P-01 — Politika e Privatësisë brenda aplikacionit (GDPR Neni 13).
///
/// Gjuhë e thjeshtë shqipe, max ~300 fjalë.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static String _formatConsentDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: FutureBuilder<ConsentRecord?>(
        future: HiveConsentRepository.loadConsent(),
        builder: (context, snapshot) {
          final consent = snapshot.data;
          final hasConsent = consent != null;

          return ResponsivePage(
            maxWidth: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PolicySection(
                  title: 'Politika e Privatësisë',
                  subtitle: 'Versioni 1.1 · Maj 2026',
                ),
                const _PolicyBlock(
                  heading: 'Çfarë mblidhet',
                  body:
                      'MathLingo ruan vetëm të dhënat e nevojshme për të '
                      'personalizuar përvojën mësimore:\n\n'
                      '• Pseudonimet e fëmijëve (jo emra realë)\n'
                      '• Pikët, saktësia dhe historia e moduleve mësimore\n'
                      '• PIN-i prindëror (ruhet vetëm lokalisht)\n'
                      '• Tabela e zgjedhura dhe preferencat e mënyrës së luajtjes',
                ),
                const _PolicyBlock(
                  heading: 'Modaliteti lokal',
                  body:
                      'Modaliteti lokal është gjithmonë aktiv. Progresi, pikët '
                      'dhe aktiviteti ruhen në pajisjen tuaj dhe përdoren vetëm '
                      'për familjen tuaj lokale.',
                ),
                _PolicyBlock(
                  heading: 'Statusi aktual i sinkronizimit',
                  body: hasConsent
                      ? 'Sinkronizimi cloud është aktiv sipas pëlqimit tuaj '
                          'prindëror të dhënë më ${_formatConsentDate(consent.grantedAt)}. '
                          'Pseudonimet, progresi dhe statistikat e fëmijëve dërgohen '
                      'të enkriptuara në Firebase për sinkronizim ndërmjet pajisjeve. '
                      'Mund ta ndaloni nga Cilësimet pa fshirë të dhënat lokale.'
                      : 'Sinkronizimi cloud nuk është aktiv. Në këtë gjendje, '
                          'MathLingo nuk dërgon të dhëna mësimore në Firebase apo '
                          'në serverë të jashtëm.',
                ),
                if (hasConsent)
                  const _PolicyBlock(
                    heading: 'Kur aktivizohet cloud',
                    body:
                        'Kur prindi aktivizon sinkronizimin cloud, ruhen vetëm '
                        'pseudonimet, progresi, pikët dhe statistikat e moduleve. '
                        'Asnjë emër real, foto apo informacion i ndjeshëm nuk '
                        'kërkohet për këtë funksion.',
                  ),
                _PolicyBlock(
                  heading: 'Kush ka akses',
                  body: hasConsent
                      ? 'Në modalitetin lokal, qasja mbetet vetëm në pajisjen tuaj. '
                          'Kur cloud është aktiv, qasja te të dhënat e sinkronizuara '
                          'kufizohet te llogaria juaj prindërore.'
                      : 'Vetëm familja juaj lokale ka akses te këto të dhëna në '
                          'pajisje. Nuk ka qasje cloud pa pëlqim të ruajtur.',
                ),
                _PolicyBlock(
                  heading: 'Si fshihet (GDPR Neni 17)',
                  body: hasConsent
                    ? 'Cilësimet → "Çaktivizo sinkronizimin cloud" ose '
                      '"Hiq pëlqimin për cloud" për të ndalur sinkronizimin '
                      'pa fshirë llogarinë cloud.\n\n'
                      'Cilësimet → "Fshi llogarinë në cloud" për të fshirë '
                      'llogarinë cloud dhe të dhënat e sinkronizuara.\n\n'
                      'Cilësimet → "Fshi të Gjitha të Dhënat" për të pastruar '
                      'edhe të dhënat lokale nga pajisja.'
                      : 'Cilësimet → "Fshi të Gjitha të Dhënat".\n\n'
                          'Ky veprim fshin çdo profil, progres dhe PIN nga pajisja '
                          'juaj dhe nuk mund të kthehet.',
                ),
                const _PolicyBlock(
                  heading: 'Si eksportohet (GDPR Neni 20)',
                  body:
                      'Cilësimet → "Shkarko të Dhënat".\n\n'
                      'Merrni një skedar JSON me të gjitha të dhënat tuaja '
                      'për transferim ose arkivim sipas dëshirës tuaj.',
                ),
                const _PolicyBlock(
                  heading: 'Të drejtat e fëmijëve',
                  body:
                      'Si prind ose kujdestar ligjor, keni të drejtë të '
                      'aksesoni, ndryshoni ose fshini çdo të dhënë të fëmijëve '
                      'tuaj në çdo kohë. Asnjë e dhënë nuk ndahet me palë të '
                      'treta pa pëlqimin tuaj eksplicit.',
                ),
                const _PolicyBlock(
                  heading: 'Kontakti',
                  body: 'Për çdo pyetje lidhur me privatësinë:\n'
                      'support@mathlingo.app',
                ),
              ],
            ),
          );
        },
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
