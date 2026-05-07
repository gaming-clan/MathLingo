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