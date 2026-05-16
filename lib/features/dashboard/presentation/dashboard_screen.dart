import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../gamify_exercise.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/operation.dart';
import '../../../responsive.dart';
import '../../../shared/navigation/adaptive_scaffold.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/skeleton_card.dart';
import '../../../simple_tables.dart';
import '../../challenges/presentation/challenge_screen.dart';
import '../../geometry/presentation/geometry_challenge_screen.dart';
import '../../fraction/presentation/fraction_challenge_screen.dart';
import '../../missing_x/presentation/missing_x_challenge_screen.dart';
import 'lessons_page.dart';
import 'progress_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onProfilePressed() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.dashboardProfileComingSoon),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onNotificationsPressed() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.dashboardNotificationsComingSoon),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _DashboardPage(
          onStartChallenge: _startChallenge,
          onStartGeometryChallenge: _startGeometryChallenge,
          onStartGamifyExercise: _startGamifyExercise,
          onStartMissingXChallenge: _startMissingXChallenge,
          onStartFractionChallenge: _startFractionChallenge,
        );
      case 1:
        return LessonsPage(onStartGeometryChallenge: _startGeometryChallenge);
      case 2:
        return const OperationTablesScreen();
      case 3:
        return const ProgressPage();
      default:
        return _DashboardPage(
          onStartChallenge: _startChallenge,
          onStartGeometryChallenge: _startGeometryChallenge,
          onStartGamifyExercise: _startGamifyExercise,
          onStartMissingXChallenge: _startMissingXChallenge,
          onStartFractionChallenge: _startFractionChallenge,
        );
    }
  }

  void _startChallenge([Operation operation = Operation.addition]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeScreen(operation: operation),
      ),
    );
  }

  void _startGeometryChallenge() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const GeometryChallengeScreen()),
    );
  }

  void _startGamifyExercise() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const GamifyExerciseScreen()),
    );
  }

  void _startMissingXChallenge() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MissingXChallengeScreen(),
      ),
    );
  }

  void _startFractionChallenge() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const FractionChallengeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelected: _onTabSelected,
      appBar: CosmicTopBar(
        onProfilePressed: _onProfilePressed,
        onNotificationsPressed: _onNotificationsPressed,
      ),
      body: _buildCurrentPage(),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({
    required this.onStartChallenge,
    required this.onStartGeometryChallenge,
    required this.onStartGamifyExercise,
    required this.onStartMissingXChallenge,
    required this.onStartFractionChallenge,
  });

  final ValueChanged<Operation> onStartChallenge;
  final VoidCallback onStartGeometryChallenge;
  final VoidCallback onStartGamifyExercise;
  final VoidCallback onStartMissingXChallenge;
  final VoidCallback onStartFractionChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMasterDetail = width >= 840;

    if (isMasterDetail) {
      return _buildMasterDetailLayout(context, l10n);
    }

    return ResponsivePage(
      maxWidth: 1120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardWelcomeTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: CosmicColors.primaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dashboardWelcomeSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          _QuickActionsCard(
            onStartChallenge: onStartChallenge,
            onStartGamifyExercise: onStartGamifyExercise,
          ),
          const SizedBox(height: 20),
          _DailyChallengeCard(onStart: onStartGeometryChallenge),
          const SizedBox(height: 20),
          _MissingXCard(onStart: onStartMissingXChallenge),
          const SizedBox(height: 20),
          _FractionsCard(onStart: onStartFractionChallenge),
          const SizedBox(height: 20),
          _GamifyCard(onStart: onStartGamifyExercise),
          const SizedBox(height: 24),
          const _ProgressModuleCard(),
        ],
      ),
    );
  }

  Widget _buildMasterDetailLayout(BuildContext context, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel i majtë — Hero: Sfida e Ditës + GamifyCard
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AdaptiveLayout.pagePadding(context).left,
              AdaptiveLayout.pagePadding(context).top,
              16,
              AdaptiveLayout.pagePadding(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboardWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dashboardWelcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                _DailyChallengeCard(onStart: onStartGeometryChallenge),
                const SizedBox(height: 20),
                _MissingXCard(onStart: onStartMissingXChallenge),
                const SizedBox(height: 20),
                _FractionsCard(onStart: onStartFractionChallenge),
                const SizedBox(height: 20),
                _GamifyCard(onStart: onStartGamifyExercise),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1, color: Color(0x1FEEEBFF)),
        // Panel i djathtë — Control Center: QuickActions + Progress
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              AdaptiveLayout.pagePadding(context).top,
              AdaptiveLayout.pagePadding(context).right,
              AdaptiveLayout.pagePadding(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuickActionsCard(
                  onStartChallenge: onStartChallenge,
                  onStartGamifyExercise: onStartGamifyExercise,
                ),
                const SizedBox(height: 24),
                const _ProgressModuleCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: RepaintBoundary(child: MascotFrame(size: 220))),
          const SizedBox(height: 18),
          _NeonChip(
            icon: Icons.local_fire_department,
            label: l10n.tabDailyChallenge,
            color: CosmicColors.secondaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dashboardDailyChallengeTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dashboardDailyChallengeDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          CosmicButton(
            key: const ValueKey('start-challenge'),
            label: l10n.dashboardStartChallenge,
            icon: Icons.arrow_forward,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _MissingXCard extends StatelessWidget {
  const _MissingXCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NeonChip(
            icon: Icons.search,
            label: 'Gjej X-in',
            color: CosmicColors.secondaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            'Gjej X-in',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Zgjidh ekuacionin duke gjetur numrin e munguar. Stërvit logjikën!\n'
            '5 + ? = 12    ? × 4 = 20    9 − ? = 3',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          CosmicButton(
            label: 'Fillo sfidën',
            icon: Icons.arrow_forward,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _FractionsCard extends StatelessWidget {
  const _FractionsCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NeonChip(
            icon: Icons.pie_chart_outline,
            label: l10n.dashboardFractionsChip,
            color: CosmicColors.secondaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dashboardFractionsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dashboardFractionsDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          CosmicButton(
            label: l10n.dashboardFractionsButton,
            icon: Icons.arrow_forward,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _GamifyCard extends StatelessWidget {
  const _GamifyCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NeonChip(
            icon: Icons.camera_alt,
            label: l10n.dashboardGamifyChip,
            color: CosmicColors.primaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dashboardGamifyTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dashboardGamifyDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          CosmicButton(
            label: l10n.dashboardStartAdventure,
            icon: Icons.camera_alt,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _ProgressModuleCard extends ConsumerWidget {
  const _ProgressModuleCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(progressProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardProgressModuleTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        progressAsync.when(
          loading: () => const CosmicShimmer(height: 120, rows: 2),
          error: (_, __) => const CosmicShimmer(height: 120, rows: 2),
          data: (progress) => GlassPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                CosmicProgress(
                  label: l10n.dashboardProgressPointsLabel(
                    progress.totalPoints,
                  ),
                  value: progress.totalPointsProgress(),
                  color: CosmicColors.secondaryContainer,
                ),
                const SizedBox(height: 18),
                CosmicProgress(
                  label: l10n.dashboardProgressAccuracyLabel(
                    progress.averageAccuracy.round(),
                  ),
                  value: progress.accuracyProgress(),
                  color: CosmicColors.primaryContainer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({
    required this.onStartChallenge,
    required this.onStartGamifyExercise,
  });

  final ValueChanged<Operation> onStartChallenge;
  final VoidCallback onStartGamifyExercise;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardQuickActionsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = AdaptiveLayout.columnsForWidth(
              constraints.maxWidth,
              compact: 2,
              medium: 2,
              expanded: 4,
            );
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: AdaptiveLayout.gridAspectForColumns(columns),
              children: [
                _OperationTile(
                  operation: Operation.addition,
                  label: l10n.dashboardOperationAddition,
                  color: CosmicColors.primaryContainer,
                  onTap: () => onStartChallenge(Operation.addition),
                ),
                _OperationTile(
                  operation: Operation.subtraction,
                  label: l10n.dashboardOperationSubtraction,
                  color: CosmicColors.primaryContainer,
                  onTap: () => onStartChallenge(Operation.subtraction),
                ),
                _OperationTile(
                  operation: Operation.multiplication,
                  label: l10n.dashboardOperationMultiplication,
                  color: CosmicColors.secondaryContainer,
                  onTap: () => onStartChallenge(Operation.multiplication),
                ),
                _OperationTile(
                  operation: Operation.division,
                  label: l10n.dashboardOperationDivision,
                  color: CosmicColors.secondaryContainer,
                  onTap: () => onStartChallenge(Operation.division),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _OperationTile extends StatelessWidget {
  const _OperationTile({
    required this.operation,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final Operation operation;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ActionTile(
      icon: operation.icon,
      label: label,
      color: color,
      onTap: onTap,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxHeight < 96 || constraints.maxWidth < 116;
          final iconBoxSize = isCompact ? 40.0 : 54.0;
          final iconSize = isCompact ? 20.0 : 24.0;
          final verticalGap = isCompact ? 8.0 : 12.0;
          final tilePadding = isCompact ? 8.0 : 12.0;
          final fontSize = isCompact ? 11.0 : 14.0;

          return GlassPanel(
            padding: EdgeInsets.all(tilePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.12),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
                SizedBox(height: verticalGap),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: isCompact ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CosmicColors.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: fontSize,
                      height: 1.05,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NeonChip extends StatelessWidget {
  const _NeonChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
