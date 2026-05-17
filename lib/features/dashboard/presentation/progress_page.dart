import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/score_card.dart';
import '../../progress/widgets/module_progress_ring.dart';
import '../../progress/widgets/session_history_panel.dart';

const _moduleKeys = [
  'Mbledhje',
  'Zbritje',
  'Shumëzim',
  'Pjesëtim',
  'Gjeometri',
  'Gjej X-in',
  'Fraksionet',
];

const _moduleColors = [
  Color(0xFF4CAF50),
  Color(0xFFF44336),
  Color(0xFFFF9800),
  Color(0xFF2196F3),
  Color(0xFF00EEFC),
  Color(0xFFAB47BC), // vjollcë për Gjej X-in
  Color(0xFFFFD700), // ari për Fraksionet
];

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTablet = AdaptiveLayout.isTablet(context);
    final isLandscape = size.width > size.height;

    if (isTablet && isLandscape) {
      return _ProgressLandscapeLayout(l10n: l10n);
    }

    // Portrait — layout vertikal ekzistues (zgjeruar me progress bars reale)
    return _ProgressPortraitLayout(l10n: l10n);
  }
}

// ---------------------------------------------------------------------------
// Portrait layout
// ---------------------------------------------------------------------------
class _ProgressPortraitLayout extends ConsumerWidget {
  const _ProgressPortraitLayout({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(activeProgressProvider);
    return ResponsivePage(
      maxWidth: 820,
      child: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
        data: (progress) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.progressPageTitle,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: CosmicColors.primary,
                fontSize: 42,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.progressPageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsPointsValue(progress.totalPoints),
                    label: l10n.progressPageTotalPointsLabel,
                    icon: Icons.workspace_premium,
                    color: CosmicColors.tertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsAccuracyValue(
                      progress.averageAccuracy.round(),
                    ),
                    label: l10n.progressPageAverageAccuracyLabel,
                    icon: Icons.my_location,
                    color: CosmicColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Center(child: ModuleProgressRing()),
            const SizedBox(height: 28),
            _ModuleProgressBars(progress: progress),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Landscape layout (tablet)
// ---------------------------------------------------------------------------
class _ProgressLandscapeLayout extends ConsumerWidget {
  const _ProgressLandscapeLayout({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(activeProgressProvider);
    final pad = AdaptiveLayout.pagePadding(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolona e majtë (flex 1.2) — statistika globale + ring chart
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad.left, pad.top, 16, pad.bottom),
            child: progressAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
              data: (progress) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.progressPageTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: CosmicColors.primary,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.progressPageSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ScoreCard(
                          value: l10n.resultsPointsValue(progress.totalPoints),
                          label: l10n.progressPageTotalPointsLabel,
                          icon: Icons.workspace_premium,
                          color: CosmicColors.tertiary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ScoreCard(
                          value: l10n.resultsAccuracyValue(
                            progress.averageAccuracy.round(),
                          ),
                          label: l10n.progressPageAverageAccuracyLabel,
                          icon: Icons.my_location,
                          color: CosmicColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Center(child: ModuleProgressRing()),
                  const SizedBox(height: 24),
                  _ModuleProgressBars(progress: progress),
                ],
              ),
            ),
          ),
        ),
        const VerticalDivider(
          width: 1,
          thickness: 1,
          color: Color(0x1FEEEBFF),
        ),
        // Kolona e djathtë (flex 1) — histori sesionesh
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, pad.top, pad.right, pad.bottom),
            child: const SessionHistoryPanel(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Progress bars per modul (reale nga Hive)
// ---------------------------------------------------------------------------
class _ModuleProgressBars extends StatelessWidget {
  const _ModuleProgressBars({required this.progress});

  final dynamic progress; // UserProgress

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progresi per modul',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: CosmicColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _moduleKeys.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _ModuleBar(
              label: _moduleKeys[i],
              color: _moduleColors[i],
              fraction: progress.progressForModule(_moduleKeys[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModuleBar extends StatefulWidget {
  const _ModuleBar({
    required this.label,
    required this.color,
    required this.fraction,
  });

  final String label;
  final Color color;
  final double fraction;

  @override
  State<_ModuleBar> createState() => _ModuleBarState();
}

class _ModuleBarState extends State<_ModuleBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: widget.fraction).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => Text(
                '${(_animation.value * 100).round()}%',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: _animation.value,
              backgroundColor: CosmicColors.surfaceHighest,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            ),
          ),
        ),
      ],
    );
  }
}
