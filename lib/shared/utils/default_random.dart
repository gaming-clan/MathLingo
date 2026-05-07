import 'dart:math';

class DefaultRandom implements Random {
  const DefaultRandom();

  Random get _random => Random();

  @override
  bool nextBool() => _random.nextBool();

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);
}