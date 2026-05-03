import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MathLingoApp());
}

class MathLingoApp extends StatelessWidget {
  const MathLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathLingo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.lightBlue[50],
        fontFamily: 'Comic Sans MS', // A fun font for kids if available
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> funFacts = [
    // Interesting Math Facts
    "A e dinit se zeroja (0) është i vetmi numër që nuk ka shifër romake?",
    "Shenja e barazimit (=) u shpik në vitin 1557 nga Robert Recorde!",
    "Fjala 'Matematikë' vjen nga greqishtja e lashtë dhe do të thotë 'të mësosh'.",
    "Numri 8 konsiderohet numër me fat në shumë kultura aziatike.",
    "Numri π (pi) nuk përfundon kurrë dhe përsëritet përgjithmonë!",
    "Numri 9 ka veti të mahnitshme: 9+9=18, dhe 1+8=9!",
    "Numri 1 nuk është numër i thjeshtë sipas përkufizimit matematikor.",
    "Numri më i vogël i thjeshtë është 2, dhe është i vetmi çift!",
    
    // Addition Table Facts (1-10)
    "1 + 1 = 2",
    "2 + 2 = 4",
    "3 + 3 = 6",
    "4 + 4 = 8",
    "5 + 5 = 10",
    "6 + 6 = 12",
    "7 + 7 = 14",
    "8 + 8 = 16",
    "9 + 9 = 18",
    "10 + 10 = 20",
    "1 + 2 = 3",
    "2 + 3 = 5",
    "3 + 4 = 7",
    "4 + 5 = 9",
    "5 + 6 = 11",
    "6 + 7 = 13",
    "7 + 8 = 15",
    "8 + 9 = 17",
    "9 + 10 = 19",
    
    // Subtraction Table Facts (1-10)
    "5 - 1 = 4",
    "5 - 2 = 3",
    "5 - 3 = 2",
    "5 - 4 = 1",
    "5 - 5 = 0",
    "10 - 1 = 9",
    "10 - 2 = 8",
    "10 - 3 = 7",
    "10 - 4 = 6",
    "10 - 5 = 5",
    "10 - 6 = 4",
    "10 - 7 = 3",
    "10 - 8 = 2",
    "10 - 9 = 1",
    "10 - 10 = 0",
    "8 - 3 = 5",
    "9 - 4 = 5",
    "7 - 2 = 5",
    "6 - 1 = 5",
    
    // Multiplication Table Facts (1-10)
    "1 × 1 = 1",
    "1 × 2 = 2",
    "1 × 3 = 3",
    "1 × 4 = 4",
    "1 × 5 = 5",
    "2 × 2 = 4",
    "2 × 3 = 6",
    "2 × 4 = 8",
    "2 × 5 = 10",
    "2 × 6 = 12",
    "2 × 7 = 14",
    "2 × 8 = 16",
    "2 × 9 = 18",
    "2 × 10 = 20",
    "3 × 3 = 9",
    "3 × 4 = 12",
    "3 × 5 = 15",
    "3 × 6 = 18",
    "3 × 7 = 21",
    "3 × 8 = 24",
    "3 × 9 = 27",
    "3 × 10 = 30",
    "4 × 4 = 16",
    "4 × 5 = 20",
    "4 × 6 = 24",
    "4 × 7 = 28",
    "4 × 8 = 32",
    "4 × 9 = 36",
    "4 × 10 = 40",
    "5 × 5 = 25",
    "5 × 6 = 30",
    "5 × 7 = 35",
    "5 × 8 = 40",
    "5 × 9 = 45",
    "5 × 10 = 50",
    "6 × 6 = 36",
    "6 × 7 = 42",
    "6 × 8 = 48",
    "6 × 9 = 54",
    "6 × 10 = 60",
    "7 × 7 = 49",
    "7 × 8 = 56",
    "7 × 9 = 63",
    "7 × 10 = 70",
    "8 × 8 = 64",
    "8 × 9 = 72",
    "8 × 10 = 80",
    "9 × 9 = 81",
    "9 × 10 = 90",
    "10 × 10 = 100",
    
    // Division Table Facts (1-10)
    "2 ÷ 1 = 2",
    "4 ÷ 2 = 2",
    "6 ÷ 2 = 3",
    "8 ÷ 2 = 4",
    "10 ÷ 2 = 5",
    "6 ÷ 3 = 2",
    "9 ÷ 3 = 3",
    "12 ÷ 3 = 4",
    "15 ÷ 3 = 5",
    "18 ÷ 3 = 6",
    "21 ÷ 3 = 7",
    "24 ÷ 3 = 8",
    "27 ÷ 3 = 9",
    "30 ÷ 3 = 10",
    "8 ÷ 4 = 2",
    "12 ÷ 4 = 3",
    "16 ÷ 4 = 4",
    "20 ÷ 4 = 5",
    "24 ÷ 4 = 6",
    "28 ÷ 4 = 7",
    "32 ÷ 4 = 8",
    "36 ÷ 4 = 9",
    "40 ÷ 4 = 10",
    "10 ÷ 5 = 2",
    "15 ÷ 5 = 3",
    "20 ÷ 5 = 4",
    "25 ÷ 5 = 5",
    "30 ÷ 5 = 6",
    "35 ÷ 5 = 7",
    "40 ÷ 5 = 8",
    "45 ÷ 5 = 9",
    "50 ÷ 5 = 10",
    "12 ÷ 6 = 2",
    "18 ÷ 6 = 3",
    "24 ÷ 6 = 4",
    "30 ÷ 6 = 5",
    "36 ÷ 6 = 6",
    "42 ÷ 6 = 7",
    "48 ÷ 6 = 8",
    "54 ÷ 6 = 9",
    "60 ÷ 6 = 10",
    "14 ÷ 7 = 2",
    "21 ÷ 7 = 3",
    "28 ÷ 7 = 4",
    "35 ÷ 7 = 5",
    "42 ÷ 7 = 6",
    "49 ÷ 7 = 7",
    "56 ÷ 7 = 8",
    "63 ÷ 7 = 9",
    "70 ÷ 7 = 10",
    "16 ÷ 8 = 2",
    "24 ÷ 8 = 3",
    "32 ÷ 8 = 4",
    "40 ÷ 8 = 5",
    "48 ÷ 8 = 6",
    "56 ÷ 8 = 7",
    "64 ÷ 8 = 8",
    "72 ÷ 8 = 9",
    "80 ÷ 8 = 10",
    "18 ÷ 9 = 2",
    "27 ÷ 9 = 3",
    "36 ÷ 9 = 4",
    "45 ÷ 9 = 5",
    "54 ÷ 9 = 6",
    "63 ÷ 9 = 7",
    "72 ÷ 9 = 8",
    "81 ÷ 9 = 9",
    "90 ÷ 9 = 10",
    "20 ÷ 10 = 2",
    "30 ÷ 10 = 3",
    "40 ÷ 10 = 4",
    "50 ÷ 10 = 5",
    "60 ÷ 10 = 6",
    "70 ÷ 10 = 7",
    "80 ÷ 10 = 8",
    "90 ÷ 10 = 9",
    "100 ÷ 10 = 10",
  ];

  String currentFact = "";

  @override
  void initState() {
    super.initState();
    _generateRandomFact();
  }

  void _generateRandomFact() {
    final random = Random();
    setState(() {
      currentFact = funFacts[random.nextInt(funFacts.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MathLingo - Mëso Matematikë!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Zgjidh një lojë!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuCard(context, 'Mbledhje (+)', '+', Colors.green),
                  _buildMenuCard(context, 'Zbritje (-)', '-', Colors.redAccent),
                  _buildMenuCard(context, 'Shumëzim (x)', '*', Colors.orange),
                  _buildMenuCard(context, 'Pjesëtim (÷)', '/', Colors.blue),
                ],
              ),
            ),
            Card(
              color: Colors.yellow[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '💡 Fakt Interesant',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentFact,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: _generateRandomFact,
                      child: const Text('Trego një tjetër'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String operation, Color color) {
    return InkWell(
      onTap: () {
        _showLevelDialog(context, title, operation);
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showLevelDialog(BuildContext context, String title, String operation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Zgjidh Nivelin për $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _startQuiz(context, operation, 1),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Niveli 1 (I Lehtë)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _startQuiz(context, operation, 2),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Niveli 2 (Mesatar)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _startQuiz(context, operation, 3),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Niveli 3 (I Vështirë)'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startQuiz(BuildContext context, String operation, int level) {
    Navigator.pop(context); // Close dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(operation: operation, level: level),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String operation;
  final int level;

  const QuizScreen({super.key, required this.operation, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  List<int> options = [];
  int score = 0;
  String feedback = "";
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    int maxNumber = widget.level == 1 ? 10 : (widget.level == 2 ? 50 : 100);

    setState(() {
      feedback = "";
      feedbackColor = Colors.transparent;

      if (widget.operation == '+') {
        num1 = random.nextInt(maxNumber) + 1;
        num2 = random.nextInt(maxNumber) + 1;
        correctAnswer = num1 + num2;
      } else if (widget.operation == '-') {
        num1 = random.nextInt(maxNumber) + 5; // Ensure it's big enough
        num2 = random.nextInt(num1) + 1; // Ensure no negative results for kids
        correctAnswer = num1 - num2;
      } else if (widget.operation == '*') {
        int multMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 20);
        num1 = random.nextInt(multMax) + 1;
        num2 = random.nextInt(multMax) + 1;
        correctAnswer = num1 * num2;
      } else if (widget.operation == '/') {
        int divMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 20);
        correctAnswer = random.nextInt(divMax) + 1;
        num2 = random.nextInt(divMax) + 1;
        num1 = correctAnswer * num2; // Ensures clean whole-number division
      }

      _generateOptions(random);
    });
  }

  void _generateOptions(Random random) {
    options = [correctAnswer];
    while (options.length < 4) {
      // Generate plausible wrong answers
      int offset = random.nextInt(10) - 5;
      if (offset == 0) offset = 1;
      int wrongAnswer = correctAnswer + offset;
      
      if (wrongAnswer >= 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle(); // Randomize button positions
  }

  void _checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score += 10;
        feedback = "Të lumtë! E saktë! 🎉";
        feedbackColor = Colors.green;
      });
      Future.delayed(const Duration(seconds: 1), () {
        _generateQuestion();
      });
    } else {
      setState(() {
        feedback = "E gabuar. Provo përsëri! 🤔";
        feedbackColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String opSymbol = widget.operation == '*' ? 'x' : (widget.operation == '/' ? '÷' : widget.operation);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pikët: $score'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Niveli ${widget.level}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
                ],
              ),
              child: Text(
                '$num1 $opSymbol $num2 = ?',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: options.map((option) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => _checkAnswer(option),
                    child: Text(
                      option.toString(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              feedback,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: feedbackColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}