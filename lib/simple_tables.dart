import 'package:flutter/material.dart';

import 'colors.dart';
import 'responsive.dart';

const _tableSnackBarMargin = EdgeInsets.fromLTRB(16, 8, 16, 96);

// Simple Operation Tables Screen
class OperationTablesScreen extends StatefulWidget {
  const OperationTablesScreen({super.key});

  @override
  State<OperationTablesScreen> createState() => _OperationTablesScreenState();
}

class _OperationTablesScreenState extends State<OperationTablesScreen> {
  int selectedTable = 1;
  String selectedOperation = 'Shumëzim';

  List<({int operand, int result})> _buildVisibleEntries(
    String title,
    int Function(int, int) calculate,
  ) {
    final entries = <({int operand, int result})>[];

    for (var operand = 1; operand <= 10; operand++) {
      if (title == 'Zbritje' && selectedTable < operand) {
        continue;
      }
      if (title == 'Pjesëtim' && selectedTable % operand != 0) {
        continue;
      }

      entries.add((operand: operand, result: calculate(selectedTable, operand)));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabelat Matematikore',
                        style: TextStyle(
                          color: CosmicColors.primaryContainer,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Praktiko dhe zotëro të gjitha operacionet',
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
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: CosmicColors.primaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(text: 'Mbledhje +'),
                      Tab(text: 'Zbritje -'),
                      Tab(text: 'Shumëzim ×'),
                      Tab(text: 'Pjesëtim ÷'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _buildOperationTable('Mbledhje', (a, b) => a + b, Colors.green),
                _buildOperationTable('Zbritje', (a, b) => a - b, Colors.red),
                _buildOperationTable(
                  'Shumëzim',
                  (a, b) => a * b,
                  Colors.orange,
                ),
                _buildOperationTable('Pjesëtim', (a, b) => a ~/ b, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationTable(
    String title,
    int Function(int, int) calculate,
    Color color,
  ) {
    final entries = _buildVisibleEntries(title, calculate);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '$title - Tabela e ${selectedTable.toString()}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: CosmicColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Zgjidh numrin',
                style: TextStyle(fontSize: 18, color: CosmicColors.onSurfaceVariant, fontWeight: FontWeight.bold),
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
                  onPressed: () => setState(() => selectedTable = num),
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
                  String op = title == 'Mbledhje'
                      ? '+'
                      : title == 'Zbritje'
                      ? '−'
                      : title == 'Shumëzim'
                      ? '×'
                      : '÷';
                  return Card(
                    color: color.withValues(alpha: 0.2),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: color,
                        width: 3,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$selectedTable $op $num = $result'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: color,
                            behavior: SnackBarBehavior.floating,
                            margin: _tableSnackBarMargin,
                          ),
                        );
                      },
                      child: Container(
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
  late List<GeometryProblem> problems;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() {
    problems = [
      GeometryProblem(
        shape: 'Drejtkëndësh',
        width: 5,
        height: 3,
        question: 'Sa është perimetri?',
        answer: 16,
        options: [14, 16, 18, 20],
      ),
      GeometryProblem(
        shape: 'Katror',
        width: 4,
        height: 4,
        question: 'Sa është sipërfaqja?',
        answer: 16,
        options: [12, 14, 16, 18],
      ),
      GeometryProblem(
        shape: 'Trekëndësh',
        width: 6,
        height: 4,
        question: 'Sa është sipërfaqja?',
        answer: 12,
        options: [10, 12, 14, 16],
      ),
      GeometryProblem(
        shape: 'Drejtkëndësh',
        width: 8,
        height: 2,
        question: 'Sa është perimetri?',
        answer: 20,
        options: [16, 18, 20, 22],
      ),
      GeometryProblem(
        shape: 'Katror',
        width: 5,
        height: 5,
        question: 'Sa është perimetri?',
        answer: 20,
        options: [18, 20, 22, 24],
      ),
    ];
  }

  void _checkAnswer(int selected) {
    if (selected == problems[question].answer) {
      setState(() => score++);
      _nextQuestion();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text('E gabuar, provo përsëri!'),
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Përfundim!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pikët: $score/${problems.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              score >= 3 ? '👏 Bravo!' : 'Përpiqu përsëri!',
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
            child: const Text('Mbaroj'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = problems[question];
    return Scaffold(
      appBar: AppBar(
        title: Text('Pyetja ${question + 1}/${problems.length}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Pikët: $score',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              problem.question,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildShape(problem),
            const SizedBox(height: 40),
            Text(
              '${problem.shape} (${problem.width} × ${problem.height})',
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

  Widget _buildShape(GeometryProblem problem) {
    final width = problem.width.toDouble();
    final height = problem.height.toDouble();
    final scale = 40.0 / (width > height ? width : height);

    if (problem.shape == 'Drejtkëndësh') {
      return Container(
        width: width * scale,
        height: height * scale,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 3),
          color: Colors.purple[50],
        ),
      );
    } else if (problem.shape == 'Katror') {
      return Container(
        width: width * scale,
        height: height * scale,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 3),
          color: Colors.orange[50],
        ),
      );
    } else {
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

class GeometryProblem {
  final String shape;
  final int width;
  final int height;
  final String question;
  final int answer;
  final List<int> options;

  GeometryProblem({
    required this.shape,
    required this.width,
    required this.height,
    required this.question,
    required this.answer,
    required this.options,
  });
}
