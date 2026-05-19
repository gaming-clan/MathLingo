import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/domain/difficulty_engine.dart';
import '../../../core/providers/challenge_provider.dart';
import '../../../core/providers/family_provider.dart';
import '../../../core/services/session_tracker.dart';
import '../../../core/sync/sync_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/operation.dart';
import '../../../responsive.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/painting/multiplication_grid_painter.dart';
import '../../../shared/widgets/section_header.dart';
import 'widgets/answer_button.dart';
import 'results_screen.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({
    super.key,
    this.operation = Operation.addition,
    this.sessionLength = 5,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final Operation operation;
  final int sessionLength;
  final Random random;

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  late final ChallengeConfig _config;
  bool _sessionRecorded = false;
  bool _leveledUp = false;
  bool _showGrid = false;

  @override
  void initState() {
    super.initState();
    final operationKey = widget.operation.name;
    final previousLevel = SessionTracker.getCurrentLevel(operationKey);
    final recent = SessionTracker.getRecentAccuracies(operationKey);
    final difficultyLevel = DifficultyEngine.evaluate(
      currentLevel: previousLevel,
      recentAccuracies: recent,
    );
    _leveledUp = difficultyLevel.index > previousLevel.index;
    _config = ChallengeConfig(
      operation: widget.operation,
      difficultyLevel: difficultyLevel,
      sessionLength: widget.sessionLength,
      random: widget.random,
    );
    if (_leveledUp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎉 Kalove në ${difficultyLevel.label}!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: CosmicColors.secondaryContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeProvider(_config));
    final l10n = AppLocalizations.of(context);

    ref.listen(challengeProvider(_config), (prev, next) {
      if (next.isAdvancing && !(prev?.isAdvancing ?? false)) {
        final navigator = Navigator.of(context);
        Future<void>.delayed(const Duration(milliseconds: 450), () {
          if (!mounted) return;
          if (next.isComplete) {
            if (!_sessionRecorded) {
              _sessionRecorded = true;
              final operationKey = widget.operation.name;
              SessionTracker.recordSession(operationKey, next.accuracy);
              SessionTracker.setCurrentLevel(
                operationKey,
                next.difficultyLevel,
              );
              // B-01: Auto-sync statistikat ditore pas çdo sesioni (fire-and-forget).
              final activeChild = ref.read(familyProvider).activeChild;
              if (activeChild != null) {
                ref.read(syncServiceProvider).updateDailyStats(
                  child: activeChild,
                  sessionPoints: next.score,
                  sessionAccuracy: next.accuracy / 100.0,
                  moduleKey: operationKey,
                );
              }
            }
            navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => ResultsScreen(
                  points: next.score,
                  accuracy: next.accuracy,
                  moduleKey: widget.operation.label,
                ),
              ),
            );
          } else {
            ref.read(challengeProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect!
              ? l10n.challengeCorrectFeedback
              : l10n.challengeIncorrectFeedback);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              kicker: l10n.challengeKicker,
              title: l10n.challengeTitle,
            ),
            const SizedBox(height: 8),
            _NeonLevelChip(level: state.difficultyLevel),
            const SizedBox(height: 14),
            CosmicProgress(
              label: l10n.challengeScoreLabel(state.score),
              value: state.progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.sizeOf(context).height;
                  final isTablet = constraints.maxWidth >= 720;
                  final height = isTablet
                      ? (screenHeight * 0.34).clamp(160.0, 240.0)
                      : (screenHeight * 0.27).clamp(120.0, 170.0);
                  final fontSize = isTablet ? 52.0 : 44.0;
                  return SizedBox(
                    height: height,
                    child: Center(
                      child: Text(
                        l10n.challengeEquationPrompt(
                          state.question.num1,
                          widget.operation.displaySymbol,
                          state.question.num2,
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CosmicColors.secondaryContainer,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            if (widget.operation == Operation.multiplication)
              _MultiplicationGridSection(
                num1: state.question.num1,
                num2: state.question.num2,
                showGrid: _showGrid,
                onToggle: () => setState(() => _showGrid = !_showGrid),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 720;
                final childAspectRatio = isTablet ? 3.4 : 2.8;

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: childAspectRatio,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: state.question.options.map((option) {
                    final isSelected = state.selectedAnswer == option;
                    final isCorrect = option == state.question.answer;
                    final color = isSelected && isCorrect
                        ? CosmicColors.secondaryContainer
                        : isSelected
                        ? CosmicColors.error
                        : CosmicColors.primaryContainer;
                    return AnswerButton(
                      key: isCorrect
                          ? const ValueKey('correct-answer')
                          : ValueKey('answer-$option'),
                      value: option,
                      color: color,
                      onPressed: () => ref
                          .read(challengeProvider(_config).notifier)
                          .checkAnswer(option),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: feedback.isEmpty
                  ? const SizedBox(height: 28)
                  : Text(
                      feedback,
                      key: ValueKey(feedback),
                      style: TextStyle(
                        color: state.isAnswerCorrect == true
                            ? CosmicColors.secondaryContainer
                            : CosmicColors.error,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
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
// _NeonLevelChip
// ---------------------------------------------------------------------------
class _NeonLevelChip extends StatelessWidget {
  const _NeonLevelChip({required this.level});

  final DifficultyLevel level;

  Color get _color {
    switch (level) {
      case DifficultyLevel.level1:
        return CosmicColors.secondaryContainer;
      case DifficultyLevel.level2:
        return const Color(0xFFFFD700); // gold
      case DifficultyLevel.level3:
        return const Color(0xFFFF6B35); // neon orange
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Chip(
        key: ValueKey(level),
        label: Text(
          level.label,
          style: TextStyle(
            color: _color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: _color.withValues(alpha: 0.12),
        side: BorderSide(color: _color, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MultiplicationGridSection — grilë animuar për shumëzim
// ---------------------------------------------------------------------------
class _MultiplicationGridSection extends StatefulWidget {
  const _MultiplicationGridSection({
    required this.num1,
    required this.num2,
    required this.showGrid,
    required this.onToggle,
  });

  final int num1;
  final int num2;
  final bool showGrid;
  final VoidCallback onToggle;

  @override
  State<_MultiplicationGridSection> createState() =>
      _MultiplicationGridSectionState();
}

class _MultiplicationGridSectionState
    extends State<_MultiplicationGridSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _colAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 * widget.num2),
    );
    _colAnim = Tween<double>(begin: 0, end: widget.num2.toDouble()).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_MultiplicationGridSection old) {
    super.didUpdateWidget(old);
    if (widget.num2 != old.num2) {
      _ctrl.duration = Duration(milliseconds: 300 * widget.num2);
      _colAnim = Tween<double>(begin: 0, end: widget.num2.toDouble()).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      );
    }
    if (widget.showGrid && !old.showGrid) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.num1.clamp(1, 12);
    final cols = widget.num2.clamp(1, 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: widget.onToggle,
          icon: Icon(
            widget.showGrid ? Icons.grid_off : Icons.grid_on,
            size: 18,
          ),
          label: Text(widget.showGrid ? 'Fshih Grilën' : 'Shfaq Grilën'),
          style: OutlinedButton.styleFrom(
            foregroundColor: CosmicColors.secondaryContainer,
            side: BorderSide(
              color: CosmicColors.secondaryContainer.withValues(alpha: 0.5),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: widget.showGrid
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AnimatedBuilder(
              animation: _colAnim,
              builder: (_, __) => SizedBox(
                height: (rows * 28.0).clamp(60, 200),
                child: CustomPaint(
                  painter: MultiplicationGridPainter(
                    rows: rows,
                    cols: cols,
                    animatedCols: _colAnim.value.round(),
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
