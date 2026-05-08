import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/section_header.dart';
import '../../lessons/widgets/examples_panel.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key, required this.onStartGeometryChallenge});

  final VoidCallback onStartGeometryChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTablet = AdaptiveLayout.isTablet(context);
    final isLandscape = size.width > size.height;

    if (isTablet && isLandscape) {
      return _LessonsLandscapeLayout(
        l10n: l10n,
        onStartGeometryChallenge: onStartGeometryChallenge,
      );
    }

    return _LessonsPortraitLayout(
      l10n: l10n,
      onStartGeometryChallenge: onStartGeometryChallenge,
    );
  }
}

// ---------------------------------------------------------------------------
// Portrait layout
// ---------------------------------------------------------------------------
class _LessonsPortraitLayout extends StatelessWidget {
  const _LessonsPortraitLayout({
    required this.l10n,
    required this.onStartGeometryChallenge,
  });

  final AppLocalizations l10n;
  final VoidCallback onStartGeometryChallenge;

  @override
  Widget build(BuildContext context) {
    final isTablet = AdaptiveLayout.isTablet(context);
    final equationFontSize = isTablet ? 48.0 : 32.0;

    return ResponsivePage(
      maxWidth: 960,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            kicker: l10n.challengeKicker,
            title: l10n.challengeTitle,
          ),
          const SizedBox(height: 24),
          GlassPanel(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
            // B3: Column linear — ekuacioni lart, Stitch poshtë (pa mbivendosje)
            child: Column(
              children: [
                Text(
                  '5 + 3 = 8',
                  style: TextStyle(
                    color: CosmicColors.secondaryContainer,
                    fontSize: equationFontSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                const MascotFrame(size: 160),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.lessonsToolsTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MathTool(label: '√x'),
              _MathTool(label: 'π'),
              _MathTool(label: 'x²'),
              _MathTool(icon: Icons.lightbulb, selected: true),
            ],
          ),
          const SizedBox(height: 32),
          CosmicButton(
            label: l10n.commonContinue,
            icon: Icons.arrow_forward,
            onPressed: onStartGeometryChallenge,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Landscape layout (tablet)
// ---------------------------------------------------------------------------
class _LessonsLandscapeLayout extends StatelessWidget {
  const _LessonsLandscapeLayout({
    required this.l10n,
    required this.onStartGeometryChallenge,
  });

  final AppLocalizations l10n;
  final VoidCallback onStartGeometryChallenge;

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.pagePadding(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolona e majtë (flex 1) — ekuacioni + Stitch + mjetet + butoni sticky
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad.left, pad.top, 16, pad.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  kicker: l10n.challengeKicker,
                  title: l10n.challengeTitle,
                ),
                const SizedBox(height: 20),
                GlassPanel(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 22,
                  ),
                  // B3: ekuacioni mbi Stitch, jo Stack
                  child: const Column(
                    children: [
                      Text(
                        '5 + 3 = 8',
                        style: TextStyle(
                          color: CosmicColors.secondaryContainer,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 16),
                      MascotFrame(size: 120),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.lessonsToolsTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MathTool(label: '√x'),
                    _MathTool(label: 'π'),
                    _MathTool(label: 'x²'),
                    _MathTool(icon: Icons.lightbulb, selected: true),
                  ],
                ),
                const Spacer(),
                CosmicButton(
                  label: l10n.commonContinue,
                  icon: Icons.arrow_forward,
                  onPressed: onStartGeometryChallenge,
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1, color: Color(0x1FEEEBFF)),
        // Kolona e djathtë (flex 1) — panel shembujsh interaktiv
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, pad.top, pad.right, pad.bottom),
            child: const ExamplesPanel(),
          ),
        ),
      ],
    );
  }
}

class _MathTool extends StatelessWidget {
  const _MathTool({this.label, this.icon, this.selected = false});

  final String? label;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? CosmicColors.primary
        : CosmicColors.secondaryContainer;
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: selected ? 0.22 : 0.08),
        border: Border.all(
          color: color.withValues(alpha: selected ? 0.9 : 0.3),
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: CosmicColors.primaryContainer.withValues(alpha: 0.25),
              blurRadius: 16,
            ),
        ],
      ),
      child: Center(
        child: icon == null
            ? Text(
                label ?? '',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Icon(icon, color: color),
      ),
    );
  }
}
