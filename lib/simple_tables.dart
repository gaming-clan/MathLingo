import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'colors.dart';
import 'core/providers/tables_provider.dart';
import 'l10n/app_localizations.dart';
import 'responsive.dart';

const _tableSnackBarMargin = EdgeInsets.fromLTRB(16, 8, 16, 96);

enum _TableOperation { addition, subtraction, multiplication, division }

enum _LegacyGeometryShape { rectangle, square, triangle }

enum _LegacyGeometryQuestion { perimeter, area }

extension _TableOperationX on _TableOperation {
  String label(AppLocalizations l10n) {
    switch (this) {
      case _TableOperation.addition:
        return l10n.dashboardOperationAddition;
      case _TableOperation.subtraction:
        return l10n.dashboardOperationSubtraction;
      case _TableOperation.multiplication:
        return l10n.dashboardOperationMultiplication;
      case _TableOperation.division:
        return l10n.dashboardOperationDivision;
    }
  }

  String tabLabel(AppLocalizations l10n) {
    switch (this) {
      case _TableOperation.addition:
        return l10n.tablesTabAddition;
      case _TableOperation.subtraction:
        return l10n.tablesTabSubtraction;
      case _TableOperation.multiplication:
        return l10n.tablesTabMultiplication;
      case _TableOperation.division:
        return l10n.tablesTabDivision;
    }
  }

  String get symbol {
    switch (this) {
      case _TableOperation.addition:
        return '+';
      case _TableOperation.subtraction:
        return '−';
      case _TableOperation.multiplication:
        return '×';
      case _TableOperation.division:
        return '÷';
    }
  }

  IconData get icon {
    switch (this) {
      case _TableOperation.addition:
        return Icons.add;
      case _TableOperation.subtraction:
        return Icons.remove;
      case _TableOperation.multiplication:
        return Icons.close;
      case _TableOperation.division:
        return Icons.more_horiz;
    }
  }
}

// Simple Operation Tables Screen
class OperationTablesScreen extends ConsumerStatefulWidget {
  const OperationTablesScreen({super.key});

  @override
  ConsumerState<OperationTablesScreen> createState() =>
      _OperationTablesScreenState();
}

class _OperationTablesScreenState
    extends ConsumerState<OperationTablesScreen> {

  List<({int operand, int result})> _buildVisibleEntries(
    _TableOperation operation,
    int Function(int, int) calculate,
    int selectedTable,
  ) {
    final entries = <({int operand, int result})>[];

    for (var operand = 1; operand <= 10; operand++) {
      if (operation == _TableOperation.subtraction && selectedTable < operand) {
        continue;
      }
      if (operation == _TableOperation.division && selectedTable % operand != 0) {
        continue;
      }

      entries.add((operand: operand, result: calculate(selectedTable, operand)));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedTable = ref.watch(tablesProvider).selectedTable;
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AdaptiveLayout.pagePadding(context).left,
              AdaptiveLayout.pagePadding(context).top,
              AdaptiveLayout.pagePadding(context).right,
              12,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tablesTitle,
                        style: TextStyle(
                          color: CosmicColors.primaryContainer,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        l10n.tablesSubtitle,
                        style: TextStyle(
                          color: CosmicColors.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AdaptiveLayout.pagePadding(context).left,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Container(
                  decoration: BoxDecoration(
                    color: CosmicColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: CosmicColors.primaryContainer,
                      width: 2,
                    ),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                      color: CosmicColors.primaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    unselectedLabelColor: Colors.white,
                    tabs: _TableOperation.values.map((op) {
                      final showText =
                          MediaQuery.sizeOf(context).width >= 360;
                      return Tab(
                        icon: Icon(op.icon, size: 20),
                        text: showText ? op.tabLabel(l10n) : null,
                        iconMargin: const EdgeInsets.only(bottom: 2),
                        height: showText ? 54 : 42,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _buildOperationTable(
                  _TableOperation.addition,
                  (a, b) => a + b,
                  Colors.green,
                  selectedTable,
                ),
                _buildOperationTable(
                  _TableOperation.subtraction,
                  (a, b) => a - b,
                  Colors.red,
                  selectedTable,
                ),
                _buildOperationTable(
                  _TableOperation.multiplication,
                  (a, b) => a * b,
                  Colors.orange,
                  selectedTable,
                ),
                _buildOperationTable(
                  _TableOperation.division,
                  (a, b) => a ~/ b,
                  Colors.blue,
                  selectedTable,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationTable(
    _TableOperation operation,
    int Function(int, int) calculate,
    Color color,
    int selectedTable,
  ) {
    final l10n = AppLocalizations.of(context);
    final entries = _buildVisibleEntries(operation, calculate, selectedTable);
    final operationLabel = operation.label(l10n);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                l10n.tablesHeader(operationLabel, selectedTable),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: CosmicColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.tablesChooseNumber,
                style: const TextStyle(
                  fontSize: 18,
                  color: CosmicColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 12,
            itemBuilder: (context, index) {
              int num = index + 1;
              final isSelected = selectedTable == num;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(tablesProvider.notifier).selectTable(num),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? color
                        : CosmicColors.surfaceHighest,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    elevation: isSelected ? 12 : 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.white
                            : color,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    '$num',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000
                  ? 5
                  : (constraints.maxWidth >= 700 ? 4 : 3);
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  AdaptiveLayout.pagePadding(context).left,
                  16,
                  AdaptiveLayout.pagePadding(context).right,
                  32,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: constraints.maxWidth >= 700 ? 1.25 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final num = entry.operand;
                  final result = entry.result;
                  final op = operation.symbol;
                  return Card(
                    color: color.withValues(alpha: 0.2),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: color, width: 3),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.tablesEquationSnackBar(
                                selectedTable,
                                op,
                                num,
                                result,
                              ),
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: color,
                            behavior: SnackBarBehavior.floating,
                            margin: _tableSnackBarMargin,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  color.withValues(alpha: 0.15),
                                  color.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$selectedTable $op $num',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: CosmicColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                  child: Text(
                                    '$result',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // C2: badge simboli operacionit (WCAG non-color encoding)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                op,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Simple Geometry Challenge (Easier)
class SimpleGeometryChallenge extends StatefulWidget {
  const SimpleGeometryChallenge({super.key});

  @override
  State<SimpleGeometryChallenge> createState() =>
      _SimpleGeometryChallengeState();
}

class _SimpleGeometryChallengeState extends State<SimpleGeometryChallenge> {
  int score = 0;
  int question = 0;
  late List<_GeometryProblem> problems;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() {
    problems = [
      _GeometryProblem(
        shape: _LegacyGeometryShape.rectangle,
        width: 5,
        height: 3,
        questionType: _LegacyGeometryQuestion.perimeter,
        answer: 16,
        options: [14, 16, 18, 20],
      ),
      _GeometryProblem(
        shape: _LegacyGeometryShape.square,
        width: 4,
        height: 4,
        questionType: _LegacyGeometryQuestion.area,
        answer: 16,
        options: [12, 14, 16, 18],
      ),
      _GeometryProblem(
        shape: _LegacyGeometryShape.triangle,
        width: 6,
        height: 4,
        questionType: _LegacyGeometryQuestion.area,
        answer: 12,
        options: [10, 12, 14, 16],
      ),
      _GeometryProblem(
        shape: _LegacyGeometryShape.rectangle,
        width: 8,
        height: 2,
        questionType: _LegacyGeometryQuestion.perimeter,
        answer: 20,
        options: [16, 18, 20, 22],
      ),
      _GeometryProblem(
        shape: _LegacyGeometryShape.square,
        width: 5,
        height: 5,
        questionType: _LegacyGeometryQuestion.perimeter,
        answer: 20,
        options: [18, 20, 22, 24],
      ),
    ];
  }

  void _checkAnswer(int selected) {
    final l10n = AppLocalizations.of(context);
    if (selected == problems[question].answer) {
      setState(() => score++);
      _nextQuestion();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(l10n.legacyGeometryWrongAnswer),
          behavior: SnackBarBehavior.floating,
          margin: _tableSnackBarMargin,
        ),
      );
    }
  }

  void _nextQuestion() {
    if (question < problems.length - 1) {
      setState(() => question++);
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.legacyGeometryResultTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.legacyGeometryScoreSummary(score, problems.length),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              score >= 3
                  ? l10n.legacyGeometrySuccessMessage
                  : l10n.legacyGeometryRetryMessage,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.legacyGeometryFinish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final problem = problems[question];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.legacyGeometryQuestionTitle(question + 1, problems.length)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.legacyGeometryCurrentScore(score),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _questionLabel(l10n, problem.questionType),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildShape(problem),
            const SizedBox(height: 40),
            Text(
              l10n.legacyGeometryShapeDimensions(
                _shapeLabel(l10n, problem.shape),
                problem.width,
                problem.height,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: problem.options.map((option) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _shapeLabel(AppLocalizations l10n, _LegacyGeometryShape shape) {
    switch (shape) {
      case _LegacyGeometryShape.rectangle:
        return l10n.legacyGeometryRectangleLabel;
      case _LegacyGeometryShape.square:
        return l10n.legacyGeometrySquareLabel;
      case _LegacyGeometryShape.triangle:
        return l10n.legacyGeometryTriangleLabel;
    }
  }

  String _questionLabel(
    AppLocalizations l10n,
    _LegacyGeometryQuestion questionType,
  ) {
    switch (questionType) {
      case _LegacyGeometryQuestion.perimeter:
        return l10n.legacyGeometryPerimeterQuestion;
      case _LegacyGeometryQuestion.area:
        return l10n.legacyGeometryAreaQuestion;
    }
  }

  Widget _buildShape(_GeometryProblem problem) {
    final width = problem.width.toDouble();
    final height = problem.height.toDouble();
    final scale = 40.0 / (width > height ? width : height);

    switch (problem.shape) {
      case _LegacyGeometryShape.rectangle:
        return Container(
          width: width * scale,
          height: height * scale,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 3),
            color: Colors.purple[50],
          ),
        );
      case _LegacyGeometryShape.square:
        return Container(
          width: width * scale,
          height: height * scale,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 3),
            color: Colors.orange[50],
          ),
        );
      case _LegacyGeometryShape.triangle:
        return CustomPaint(
          size: Size(width * scale, height * scale),
          painter: TrianglePainter(),
        );
    }
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}

class _GeometryProblem {
  final _LegacyGeometryShape shape;
  final int width;
  final int height;
  final _LegacyGeometryQuestion questionType;
  final int answer;
  final List<int> options;

  _GeometryProblem({
    required this.shape,
    required this.width,
    required this.height,
    required this.questionType,
    required this.answer,
    required this.options,
  });
}
