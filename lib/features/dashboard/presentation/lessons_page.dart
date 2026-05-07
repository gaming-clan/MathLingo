import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/section_header.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({
    super.key,
    required this.onStartGeometryChallenge,
  });

  final VoidCallback onStartGeometryChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          const GlassPanel(
            padding: EdgeInsets.all(22),
            child: SizedBox(
              height: 260,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '5 + 3 = 8',
                      style: TextStyle(
                        color: CosmicColors.secondaryContainer,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    bottom: -24,
                    child: MascotFrame(size: 170),
                  ),
                ],
              ),
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