import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../gamify_exercise.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/operation.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_bottom_nav.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../simple_tables.dart';
import '../../challenges/presentation/challenge_screen.dart';
import '../../geometry/presentation/geometry_challenge_screen.dart';
import 'lessons_page.dart';
import 'progress_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardPage(
        onStartChallenge: _startChallenge,
        onStartGeometryChallenge: _startGeometryChallenge,
        onStartGamifyExercise: _startGamifyExercise,
      ),
      LessonsPage(onStartGeometryChallenge: _startGeometryChallenge),
      const OperationTablesScreen(),
      const ProgressPage(),
    ];

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(),
      body: SafeArea(
        top: false,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: CosmicBottomNav(
        selectedIndex: _selectedIndex,
        onSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({
    required this.onStartChallenge,
    required this.onStartGeometryChallenge,
    required this.onStartGamifyExercise,
  });

  final ValueChanged<Operation> onStartChallenge;
  final VoidCallback onStartGeometryChallenge;
  final VoidCallback onStartGamifyExercise;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ResponsivePage(
      maxWidth: 1120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Column(
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
              if (isWide) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _GamifyCard(onStart: onStartGamifyExercise),
                    ),
                    const SizedBox(width: 24),
                    const Expanded(flex: 4, child: _ProgressModuleCard()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _QuickActionsCard(
                        onStartChallenge: onStartChallenge,
                        onStartGamifyExercise: onStartGamifyExercise,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: _DailyChallengeCard(
                        onStart: onStartGeometryChallenge,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _GamifyCard(onStart: onStartGamifyExercise),
                const SizedBox(height: 24),
                _QuickActionsCard(
                  onStartChallenge: onStartChallenge,
                  onStartGamifyExercise: onStartGamifyExercise,
                ),
                const SizedBox(height: 24),
                const _ProgressModuleCard(),
                const SizedBox(height: 24),
                _DailyChallengeCard(onStart: onStartGeometryChallenge),
              ],
            ],
          );
        },
      ),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 620;
          final mascot = const MascotFrame(size: 220);
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: mascot),
                const SizedBox(height: 18),
                content,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: Center(child: mascot)),
              const SizedBox(width: 24),
              Expanded(child: content),
            ],
          );
        },
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

class _ProgressModuleCard extends StatelessWidget {
  const _ProgressModuleCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardProgressModuleTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        GlassPanel(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              CosmicProgress(
                label: l10n.dashboardProgressAbstractAlgebra,
                value: 0.85,
                color: CosmicColors.secondaryContainer,
              ),
              const SizedBox(height: 18),
              CosmicProgress(
                label: l10n.dashboardProgressMathematicalAnalysis,
                value: 0.42,
                color: CosmicColors.primaryContainer,
              ),
            ],
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
      child: GlassPanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
                border: Border.all(color: color.withValues(alpha: 0.35)),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CosmicColors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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