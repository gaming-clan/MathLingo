import 'dart:math';

import 'package:flutter/material.dart';

import 'colors.dart';
import 'gamify_exercise.dart';
import 'responsive.dart';
import 'simple_tables.dart';

void main() {
  runApp(const MathLingoApp());
}

class MathLingoApp extends StatelessWidget {
  const MathLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathLingo - Math Learning Adventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: CosmicColors.background,
        colorScheme: const ColorScheme.dark(
          primary: CosmicColors.primary,
          onPrimary: CosmicColors.onPrimaryContainer,
          secondary: CosmicColors.secondary,
          surface: CosmicColors.surface,
          onSurface: CosmicColors.onSurface,
          error: CosmicColors.error,
        ),
        fontFamily: 'Lexend',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          headlineMedium: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          bodyMedium: TextStyle(
            color: CosmicColors.onSurfaceVariant,
            fontSize: 16,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

enum Operation {
  addition('+', 'Mbledhje', Icons.add),
  subtraction('-', 'Zbritje', Icons.remove),
  multiplication('*', 'Shumëzim', Icons.close),
  division('/', 'Pjesëtim', Icons.percent);

  const Operation(this.symbol, this.label, this.icon);

  final String symbol;
  final String label;
  final IconData icon;

  String get displaySymbol {
    if (this == Operation.multiplication) return 'x';
    if (this == Operation.division) return '÷';
    return symbol;
  }
}

class MathQuestion {
  const MathQuestion({
    required this.num1,
    required this.num2,
    required this.answer,
    required this.options,
  });

  final int num1;
  final int num2;
  final int answer;
  final List<int> options;
}

enum GeometryShape {
  rectangle('Drejtkëndësh', Icons.crop_square),
  triangle('Trekëndësh', Icons.change_history),
  square('Katror', Icons.square_outlined);

  const GeometryShape(this.label, this.icon);

  final String label;
  final IconData icon;
}

class GeometryQuestion {
  const GeometryQuestion({
    required this.shape,
    required this.prompt,
    required this.measurement,
    required this.answer,
    required this.options,
    required this.width,
    required this.height,
  });

  final GeometryShape shape;
  final String prompt;
  final String measurement;
  final int answer;
  final List<int> options;
  final int width;
  final int height;
}

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
      _LessonsPage(
        onStartChallenge: _startChallenge,
        onStartGeometryChallenge: _startGeometryChallenge,
        onStartGamifyExercise: _startGamifyExercise,
      ),
      const OperationTablesScreen(),
      const _ProgressPage(),
    ];

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const _CosmicTopBar(),
      body: SafeArea(
        top: false,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: _CosmicBottomNav(
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
    return ResponsivePage(
      maxWidth: 1120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mirësevini!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: CosmicColors.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Zgjedh një mënyrë për të mësuar matematikën - më lehtë ose më sfiduese.',
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
                    Expanded(flex: 4, child: const _ProgressModuleCard()),
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
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 620;
          final mascot = const _MascotFrame(size: 220);
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _NeonChip(
                icon: Icons.local_fire_department,
                label: 'Sfida e Ditës',
                color: CosmicColors.secondaryContainer,
              ),
              const SizedBox(height: 16),
              Text(
                'Gjeometria Hapësinore',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Llogarit sipërfaqe dhe perimetra me sfida të shkurtra vizuale. Ndihmësi juaj AI është gati.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              CosmicButton(
                key: const ValueKey('start-challenge'),
                label: 'Fillo Sfidën',
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
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _NeonChip(
            icon: Icons.camera_alt,
            label: 'Argëto Ushtrimet',
            color: CosmicColors.primaryContainer,
          ),
          const SizedBox(height: 16),
          Text(
            'Fotografo ose Shkruaj Ushtrimin',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Fotografo ekuacionin që nuk e kupton, shkruaje direkt, dhe merrni zgjidhje argëtuese që të bëjnë matematikën më të lehtë për të kuptuar!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          CosmicButton(
            label: 'Filloi Aventurën',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progresi i Modulit',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        const GlassPanel(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              _CosmicProgress(
                label: 'Algjebra Abstrakte',
                value: 0.85,
                color: CosmicColors.secondaryContainer,
              ),
              SizedBox(height: 18),
              _CosmicProgress(
                label: 'Analiza Matematike',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Veprime të Shpejta',
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
                  color: CosmicColors.primaryContainer,
                  onTap: () => onStartChallenge(Operation.addition),
                ),
                _OperationTile(
                  operation: Operation.subtraction,
                  color: CosmicColors.primaryContainer,
                  onTap: () => onStartChallenge(Operation.subtraction),
                ),
                _OperationTile(
                  operation: Operation.multiplication,
                  color: CosmicColors.secondaryContainer,
                  onTap: () => onStartChallenge(Operation.multiplication),
                ),
                _OperationTile(
                  operation: Operation.division,
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

class _LessonsPage extends StatelessWidget {
  const _LessonsPage({
    required this.onStartChallenge,
    required this.onStartGeometryChallenge,
    required this.onStartGamifyExercise,
  });

  final ValueChanged<Operation> onStartChallenge;
  final VoidCallback onStartGeometryChallenge;
  final VoidCallback onStartGamifyExercise;

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      maxWidth: 960,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            kicker: 'ALGJEBRA BAZË',
            title: 'Zgjidh ekuacionin',
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
                      '√x² + y²',
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
                    child: _MascotFrame(size: 170),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Mjetet e Llogaritjes',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _MathTool(label: '√x'),
              _MathTool(label: 'π'),
              _MathTool(label: 'x²'),
              _MathTool(icon: Icons.lightbulb, selected: true),
            ],
          ),
          const SizedBox(height: 32),
          CosmicButton(
            label: 'Vazhdo',
            icon: Icons.arrow_forward,
            onPressed: onStartGeometryChallenge,
          ),
        ],
      ),
    );
  }
}

class _ProgressPage extends StatelessWidget {
  const _ProgressPage();

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      maxWidth: 820,
      child: Column(
        children: [
          Text(
            'Bravo!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: CosmicColors.primary,
              fontSize: 42,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Progresi yt po rritet çdo ditë.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          const _MascotFrame(size: 260),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  value: '+150',
                  label: 'Pikët',
                  icon: Icons.workspace_premium,
                  color: CosmicColors.tertiary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _ScoreCard(
                  value: '95%',
                  label: 'Saktësia',
                  icon: Icons.my_location,
                  color: CosmicColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    super.key,
    this.operation = Operation.addition,
    this.level = 1,
    this.sessionLength = 5,
    Random? random,
  }) : random = random ?? const _DefaultRandom();

  final Operation operation;
  final int level;
  final int sessionLength;
  final Random random;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late MathQuestion _question;
  int _score = 0;
  int _answered = 0;
  int _correct = 0;
  int? _selectedAnswer;
  String _feedback = '';
  bool _isAdvancing = false;

  @override
  void initState() {
    super.initState();
    _question = _generateQuestion();
  }

  MathQuestion _generateQuestion() {
    final random = widget.random;
    final maxNumber = widget.level == 1 ? 10 : (widget.level == 2 ? 50 : 100);
    late int num1;
    late int num2;
    late int answer;

    switch (widget.operation) {
      case Operation.addition:
        num1 = random.nextInt(maxNumber) + 1;
        num2 = random.nextInt(maxNumber) + 1;
        answer = num1 + num2;
      case Operation.subtraction:
        num1 = random.nextInt(maxNumber) + 5;
        num2 = random.nextInt(num1) + 1;
        answer = num1 - num2;
      case Operation.multiplication:
        final multMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 20);
        num1 = random.nextInt(multMax) + 1;
        num2 = random.nextInt(multMax) + 1;
        answer = num1 * num2;
      case Operation.division:
        final divMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 20);
        answer = random.nextInt(divMax) + 1;
        num2 = random.nextInt(divMax) + 1;
        num1 = answer * num2;
    }

    return MathQuestion(
      num1: num1,
      num2: num2,
      answer: answer,
      options: _generateOptions(answer),
    );
  }

  List<int> _generateOptions(int correctAnswer) {
    final random = widget.random;
    final options = <int>{correctAnswer};
    while (options.length < 4) {
      var offset = random.nextInt(12) - 6;
      if (offset == 0) offset = 1;
      final wrongAnswer = correctAnswer + offset;
      if (wrongAnswer >= 0) options.add(wrongAnswer);
    }
    final shuffled = options.toList()..shuffle(random);
    return shuffled;
  }

  void _checkAnswer(int answer) {
    if (_isAdvancing) return;

    final isCorrect = answer == _question.answer;
    setState(() {
      _selectedAnswer = answer;
      _feedback = isCorrect
          ? 'Saktë! Vazhdon fluturimi.'
          : 'Provo përsëri. Je shumë afër.';
      if (isCorrect) {
        _score += 10;
        _correct += 1;
        _answered += 1;
        _isAdvancing = true;
      }
    });

    if (!isCorrect) return;

    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (_answered >= widget.sessionLength) {
        final accuracy = ((_correct / widget.sessionLength) * 100).round();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ResultsScreen(points: _score, accuracy: accuracy),
          ),
        );
        return;
      }
      setState(() {
        _question = _generateQuestion();
        _selectedAnswer = null;
        _feedback = '';
        _isAdvancing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _answered / widget.sessionLength;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const _CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              kicker: 'ALGJEBRA BAZË',
              title: 'Zgjidh ekuacionin',
            ),
            const SizedBox(height: 18),
            _CosmicProgress(
              label: 'Pikët: $_score',
              value: progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '${_question.num1} ${widget.operation.displaySymbol} ${_question.num2} = ?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CosmicColors.secondaryContainer,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 720 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: columns == 4 ? 1.65 : 1.9,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: _question.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == _question.answer;
                    final color = isSelected && isCorrect
                        ? CosmicColors.secondaryContainer
                        : isSelected
                        ? CosmicColors.error
                        : CosmicColors.primaryContainer;
                    return _AnswerButton(
                      key: isCorrect
                          ? const ValueKey('correct-answer')
                          : ValueKey('answer-$option'),
                      value: option,
                      color: color,
                      onPressed: () => _checkAnswer(option),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _feedback.isEmpty
                  ? const SizedBox(height: 28)
                  : Text(
                      _feedback,
                      key: ValueKey(_feedback),
                      style: TextStyle(
                        color: _selectedAnswer == _question.answer
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

class GeometryChallengeScreen extends StatefulWidget {
  const GeometryChallengeScreen({
    super.key,
    this.sessionLength = 4,
    Random? random,
  }) : random = random ?? const _DefaultRandom();

  final int sessionLength;
  final Random random;

  @override
  State<GeometryChallengeScreen> createState() =>
      _GeometryChallengeScreenState();
}

class _GeometryChallengeScreenState extends State<GeometryChallengeScreen> {
  late GeometryQuestion _question;
  int _score = 0;
  int _answered = 0;
  int _correct = 0;
  int? _selectedAnswer;
  String _feedback = '';
  bool _isAdvancing = false;

  @override
  void initState() {
    super.initState();
    _question = _generateQuestion();
  }

  GeometryQuestion _generateQuestion() {
    final random = widget.random;
    final shape =
        GeometryShape.values[random.nextInt(GeometryShape.values.length)];
    late int width;
    late int height;
    late int answer;
    late String prompt;
    late String measurement;

    switch (shape) {
      case GeometryShape.rectangle:
        width = random.nextInt(7) + 3;
        height = random.nextInt(6) + 2;
        answer = width * height;
        prompt = 'Sa është sipërfaqja e drejtkëndëshit?';
        measurement = 'gjerësi $width, lartësi $height';
      case GeometryShape.triangle:
        width = (random.nextInt(5) + 3) * 2;
        height = random.nextInt(6) + 2;
        answer = (width * height) ~/ 2;
        prompt = 'Sa është sipërfaqja e trekëndëshit?';
        measurement = 'bazë $width, lartësi $height';
      case GeometryShape.square:
        width = random.nextInt(8) + 3;
        height = width;
        answer = width * 4;
        prompt = 'Sa është perimetri i katrorit?';
        measurement = 'brinja $width';
    }

    return GeometryQuestion(
      shape: shape,
      prompt: prompt,
      measurement: measurement,
      answer: answer,
      options: _generateOptions(answer),
      width: width,
      height: height,
    );
  }

  List<int> _generateOptions(int correctAnswer) {
    final random = widget.random;
    final options = <int>{correctAnswer};
    while (options.length < 4) {
      var offset = random.nextInt(14) - 7;
      if (offset == 0) offset = 2;
      final wrongAnswer = correctAnswer + offset;
      if (wrongAnswer > 0) options.add(wrongAnswer);
    }
    return options.toList()..shuffle(random);
  }

  void _checkAnswer(int answer) {
    if (_isAdvancing) return;

    final isCorrect = answer == _question.answer;
    setState(() {
      _selectedAnswer = answer;
      _feedback = isCorrect
          ? 'Saktë! Forma u analizua.'
          : 'Jo ende. Shiko matjet dhe provo përsëri.';
      if (isCorrect) {
        _score += 15;
        _correct += 1;
        _answered += 1;
        _isAdvancing = true;
      }
    });

    if (!isCorrect) return;

    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (_answered >= widget.sessionLength) {
        final accuracy = ((_correct / widget.sessionLength) * 100).round();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ResultsScreen(points: _score, accuracy: accuracy),
          ),
        );
        return;
      }
      setState(() {
        _question = _generateQuestion();
        _selectedAnswer = null;
        _feedback = '';
        _isAdvancing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _answered / widget.sessionLength;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const _CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              kicker: 'GJEOMETRIA BAZË',
              title: 'Sfida Gjeometrike',
            ),
            const SizedBox(height: 18),
            _CosmicProgress(
              label: 'Pikët: $_score',
              value: progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  SizedBox(
                    height: 210,
                    child: CustomPaint(
                      painter: GeometryShapePainter(_question),
                      child: Center(
                        child: Icon(
                          _question.shape.icon,
                          color: CosmicColors.secondaryContainer.withValues(
                            alpha: 0.2,
                          ),
                          size: 96,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _question.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _question.measurement,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 720 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: columns == 4 ? 1.65 : 1.9,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: _question.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == _question.answer;
                    final color = isSelected && isCorrect
                        ? CosmicColors.secondaryContainer
                        : isSelected
                        ? CosmicColors.error
                        : CosmicColors.primaryContainer;
                    return _AnswerButton(
                      key: isCorrect
                          ? const ValueKey('correct-geometry-answer')
                          : ValueKey('geometry-answer-$option'),
                      value: option,
                      color: color,
                      onPressed: () => _checkAnswer(option),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _feedback.isEmpty
                  ? const SizedBox(height: 28)
                  : Text(
                      _feedback,
                      key: ValueKey(_feedback),
                      style: TextStyle(
                        color: _selectedAnswer == _question.answer
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

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.points,
    required this.accuracy,
  });

  final int points;
  final int accuracy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const _CosmicTopBar(),
      body: ResponsivePage(
        maxWidth: 760,
        child: Column(
          children: [
            Text(
              'Bravo!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: CosmicColors.primary,
                fontSize: 46,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Përfundove me sukses sfidën.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            const _MascotFrame(size: 280, celebratory: true),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _ScoreCard(
                    value: '+$points',
                    label: 'Pikët',
                    icon: Icons.workspace_premium,
                    color: CosmicColors.tertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ScoreCard(
                    value: '$accuracy%',
                    label: 'Saktësia',
                    icon: Icons.my_location,
                    color: CosmicColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CosmicButton(
              label: 'Vazhdo',
              icon: Icons.arrow_forward,
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const DashboardScreen(),
                ),
                (_) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            CosmicColors.surface.withValues(alpha: 0.68),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primaryContainer.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CosmicButton extends StatelessWidget {
  const CosmicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [
              CosmicColors.primaryContainer,
              CosmicColors.tertiaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primaryContainer.withValues(alpha: 0.38),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: const StadiumBorder(),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    super.key,
    required this.value,
    required this.color,
    required this.onPressed,
  });

  final int value;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: CosmicColors.onSurface,
        side: BorderSide(color: color.withValues(alpha: 0.7), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: color.withValues(alpha: 0.14),
      ),
      onPressed: onPressed,
      child: Text(
        value.toString(),
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CosmicTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _CosmicTopBar({this.showBackButton = false});

  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xCC0B0C21),
      elevation: 0,
      toolbarHeight: 76,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          _RoundIconButton(
            icon: showBackButton ? Icons.arrow_back : Icons.person,
            onPressed: showBackButton
                ? () => Navigator.maybePop(context)
                : null,
          ),
          const Spacer(),
          const Text(
            'MathLingo',
            style: TextStyle(
              color: CosmicColors.primaryContainer,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const _RoundIconButton(icon: Icons.notifications),
        ],
      ),
    );
  }
}

class _CosmicBottomNav extends StatelessWidget {
  const _CosmicBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard, 'Sfida e Ditës'),
      (Icons.school, 'Mësime'),
      (Icons.grid_3x3, 'Tabelat'),
      (Icons.trending_up, 'Progresi'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: const Color(0xCC0B0C21),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primaryContainer.withValues(alpha: 0.12),
              blurRadius: 22,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _BottomNavItem(
                    icon: items[i].$1,
                    label: items[i].$2,
                    selected: i == selectedIndex,
                    onTap: () => onSelected(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? CosmicColors.primary : CosmicColors.outline;
    return Flexible(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: selected
              ? CosmicColors.primaryContainer.withValues(alpha: 0.12)
              : Colors.transparent,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        foregroundColor: CosmicColors.onSurface,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 22),
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

class _MascotFrame extends StatefulWidget {
  const _MascotFrame({required this.size, this.celebratory = false});

  final double size;
  final bool celebratory;

  @override
  State<_MascotFrame> createState() => _MascotFrameState();
}

class _MascotFrameState extends State<_MascotFrame>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _swayController;
  late AnimationController _celebrationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _swayAnimation;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();

    // Bouncing animation (up and down)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Swaying animation (side to side)
    _swayController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _swayAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
    );

    // Celebration animation (for when winning)
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    if (widget.celebratory) {
      _celebrationController.forward();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _swayController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _bounceAnimation,
          _swayAnimation,
          _celebrationAnimation,
        ]),
        builder: (context, child) {
          // Calculate animation values
          final bounceOffset = widget.celebratory
              ? _celebrationAnimation.value * 20
              : _bounceAnimation.value;
          final swayOffset = widget.celebratory ? 0.0 : _swayAnimation.value;
          final scale = widget.celebratory
              ? 0.8 + (_celebrationAnimation.value * 0.2)
              : 1.0;
          final rotation = widget.celebratory
              ? _celebrationAnimation.value * 0.1
              : 0.0;

          return Center(
            child: Transform.translate(
              offset: Offset(swayOffset, -bounceOffset),
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Image.asset(
                    'assets/icons/stich_icon.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.smart_toy,
                      color: CosmicColors.secondaryContainer,
                      size: widget.size * 0.6,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CosmicProgress extends StatelessWidget {
  const _CosmicProgress({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CosmicColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percent%',
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: value.clamp(0, 1),
            backgroundColor: CosmicColors.surfaceHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _OperationTile extends StatelessWidget {
  const _OperationTile({
    required this.operation,
    required this.color,
    required this.onTap,
  });

  final Operation operation;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ActionTile(
      icon: operation.icon,
      label: operation.label,
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

class GeometryShapePainter extends CustomPainter {
  GeometryShapePainter(this.question);

  final GeometryQuestion question;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CosmicColors.secondaryContainer.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = CosmicColors.secondaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = CosmicColors.primaryContainer.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final center = Offset(size.width / 2, size.height / 2);
    final shapeWidth = size.width * 0.62;
    final shapeHeight = size.height * 0.58;
    final rect = Rect.fromCenter(
      center: center,
      width: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : shapeWidth,
      height: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : shapeHeight,
    );

    switch (question.shape) {
      case GeometryShape.rectangle:
      case GeometryShape.square:
        final rounded = RRect.fromRectAndRadius(
          rect,
          const Radius.circular(18),
        );
        canvas.drawRRect(rounded, glow);
        canvas.drawRRect(rounded, paint);
        canvas.drawRRect(rounded, stroke);
      case GeometryShape.triangle:
        final path = Path()
          ..moveTo(center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, glow);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant GeometryShapePainter oldDelegate) {
    return oldDelegate.question != question;
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CosmicColors.surfaceHigh,
              border: Border.all(color: color.withValues(alpha: 0.42)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CosmicColors.outline,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.kicker, required this.title});

  final String kicker;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kicker,
          style: const TextStyle(
            color: CosmicColors.secondaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}

class _DefaultRandom implements Random {
  const _DefaultRandom();

  Random get _random => Random();

  @override
  bool nextBool() => _random.nextBool();

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);
}
