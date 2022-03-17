import 'dart:math';

import 'dice.dart';

class SixDice implements Dice {
  final List<int> _values = [
    1,
    2,
    3,
    4,
    5,
    6,
  ];
  int _value = 1;

  SixDice();

  @override
  int value() => _value;

  @override
  List<int> values() => _values;

  @override
  void roll() {
    final random = Random();
    _value = _values[random.nextInt(_values.length)];
  }
}
