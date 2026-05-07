import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/geometry_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/geometry_shape.dart';
import '../../../responsive.dart';
import '../../../shared/painting/geometry_shape_painter.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/geometry_hint_chip.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import '../../challenges/presentation/results_screen.dart';
import '../../challenges/presentation/widgets/answer_button.dart';
import '../widgets/formula_reference_panel.dart';

class GeometryChallengeScreen extends ConsumerStatefulWidget {
  const GeometryChallengeScreen({
    super.key,
    this.sessionLength = 4,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final int sessionLength;
  final Random random;

  @override
  ConsumerState<GeometryChallengeScreen> createState() =>
      _GeometryChallengeScreenState();
}

class _GeometryChallengeScreenState
    extends ConsumerState<GeometryChallengeScreen> {
  late final GeometryConfig _config;

  // C3 � hint chip state
  bool _showHint = false;
  bool _hintShownThisQuestion = false;
  Timer? _hintTimer;
  Timer? _hintHideTimer;

  @override
  void initState() {
    super.initState();
    _config = GeometryConfig(
      sessionLength: widget.sessionLength,
      random: widget.random,
    );
    _scheduleHint();
  }

  void _scheduleHint() {
    _hintTimer?.cancel();
    _hintHideTimer?.cancel();
    if (_hintShownThisQuestion) return;
    _hintTimer = Timer(const Duration(seconds: 8), () {
      if (!mounted || _hintShownThisQuestion) return;
      setState(() {
        _showHint = true;
        _hintShownThisQuestion = true;
      });
      _hintHideTimer = Timer(const Duration(seconds: 4), () {
        if (!mounted) return;
        setState(() => _showHint = false);
      });
    });
  }

  void _resetHint() {
    _hintTimer?.cancel();
    _hintHideTimer?.cancel();
    setState(() {
      _showHint = false;
      _hintShownThisQuestion = false;
    });
    _scheduleHint();
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _hintHideTimer?.cancel();
    super.dispose();
  }

  String _promptForShape(GeometryShape shape, AppLocalizations l10n) {
    switch (shape) {
      case GeometryShape.rectangle:
        return l10n.geometryRectanglePrompt;
      case GeometryShape.triangle:
        return l10n.geometryTrianglePrompt;
      case GeometryShape.square:
        return l10n.geometrySquarePrompt;
    }
  }

  String _measurementForShape(GeometryState state, AppLocalizations l10n) {
    final q = state.question;
    switch (q.shape) {
      case GeometryShape.rectangle:
        return l10n.geometryRectangleMeasurement(q.width, q.height);
      case GeometryShape.triangle:
        return l10n.geometryTriangleMeasurement(q.width, q.height);
      case GeometryShape.square:
        return l10n.geometrySquareMeasurement(q.width);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geometryProvider(_config));
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTablet = AdaptiveLayout.isTablet(context);
    final isLandscape = size.width > size.height;

    ref.listen(geometryProvider(_config), (prev, next) {
      // Resetojm� hint kur ndryshon pyetja
      if (prev != null && prev.question != next.question) {
        _resetHint();
      }

      if (next.isAdvancing && !(prev?.isAdvancing ?? false)) {
        final navigator = Navigator.of(context);
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          if (next.isComplete) {
            navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => ResultsScreen(
                  points: next.score,
                  accuracy: next.accuracy,
                  moduleKey: 'Gjeometri',
                ),
              ),
            );
          } else {
            ref.read(geometryProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect!
            ? l10n.geometryCorrectFeedback
            : l10n.geometryIncorrectFeedback);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: isTablet && isLandscape
          ? _buildLandscapeBody(context, state, l10n, feedback)
          : _buildPortraitBody(context, state, l10n, feedback),
    );
  }

  // ---------------------------------------------------------------------------
  // Portrait body
  // ---------------------------------------------------------------------------
  Widget _buildPortraitBody(
    BuildContext context,
    GeometryState state,
    AppLocalizations l10n,
    String feedback,
  ) {
    return ResponsivePage(
      maxWidth: 960,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            kicker: l10n.geometryKicker,
            title: l10n.geometryTitle,
          ),
          const SizedBox(height: 18),
          CosmicProgress(
            label: l10n.geometryScoreLabel(state.score),
            value: state.progress,
            color: CosmicColors.secondaryContainer,
          ),
          const SizedBox(height: 24),
          _buildQuestionCard(context, state, l10n),
          const SizedBox(height: 24),
          _buildAnswerGrid(state),
          const SizedBox(height: 12),
          Center(
            child: GeometryHintChip(
              shape: state.question.shape,
              visible: _showHint,
            ),
          ),
          const SizedBox(height: 6),
          _buildFeedback(state, feedback),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Landscape body (C1)
  // ---------------------------------------------------------------------------
  Widget _buildLandscapeBody(
    BuildContext context,
    GeometryState state,
    AppLocalizations l10n,
    String feedback,
  ) {
    final pad = AdaptiveLayout.pagePadding(context);

    return Column(
      children: [
        // Header full-width � progress bar + score
        Padding(
          padding: EdgeInsets.fromLTRB(pad.left, pad.top, pad.right, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                kicker: l10n.geometryKicker,
                title: l10n.geometryTitle,
              ),
              const SizedBox(height: 14),
              CosmicProgress(
                label: l10n.geometryScoreLabel(state.score),
                value: state.progress,
                color: CosmicColors.secondaryContainer,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Ndar�se
        const Divider(height: 1, thickness: 1, color: Color(0x1FEEEBFF)),
        // Dy kolona
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolona e majt� (flex 1.1) � forma + pyetja + butonat
              Expanded(
                flex: 11,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad.left, 20, 16, pad.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionCard(context, state, l10n),
                      const SizedBox(height: 20),
                      _buildAnswerGrid(state),
                      const SizedBox(height: 12),
                      Center(
                        child: GeometryHintChip(
                          shape: state.question.shape,
                          visible: _showHint,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildFeedback(state, feedback),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Color(0x1FEEEBFF),
              ),
              // Kolona e djatht� (flex 0.9) � panel formulash referimi
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, pad.right, pad.bottom),
                  child: FormulaReferencePanel(
                    activeShape: state.question.shape,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Shared widgets
  // ---------------------------------------------------------------------------
  Widget _buildQuestionCard(
    BuildContext context,
    GeometryState state,
    AppLocalizations l10n,
  ) {
    return GlassPanel(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 720;
              final height = isTablet ? 220.0 : 210.0;
              return SizedBox(
                height: height,
                child: CustomPaint(
                  painter: GeometryShapePainter(state.question),
                  child: Center(
                    child: Icon(
                      state.question.shape.icon,
                      color: CosmicColors.secondaryContainer.withValues(
                        alpha: 0.2,
                      ),
                      size: isTablet ? 110 : 96,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            _promptForShape(state.question.shape, l10n),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _measurementForShape(state, l10n),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerGrid(GeometryState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isTablet = width >= 720;
        final isLargeTablet = width >= 1000;

        late int columns;
        late double childAspectRatio;

        if (isLargeTablet) {
          columns = 4;
          childAspectRatio = 1.8;
        } else if (isTablet) {
          columns = 3;
          childAspectRatio = 1.7;
        } else {
          columns = 2;
          childAspectRatio = 1.9;
        }

        return GridView.count(
          crossAxisCount: columns,
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
                  ? const ValueKey('correct-geometry-answer')
                  : ValueKey('geometry-answer-$option'),
              value: option,
              color: color,
              onPressed: () =>
                  ref.read(geometryProvider(_config).notifier).checkAnswer(option),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFeedback(GeometryState state, String feedback) {
    return AnimatedSwitcher(
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
    );
  }
}
