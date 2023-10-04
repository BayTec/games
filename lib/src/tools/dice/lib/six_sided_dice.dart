import 'dart:math';

import './dice.dart';

class SixSidedDice extends Dice {
  final List<int> _possibleValues;
  int _value;

  SixSidedDice()
      : _possibleValues = [1, 2, 3, 4, 5, 6],
        _value = 1;

  @override
  int get value => _value;
  @override
  List<int> get possibleValues => _possibleValues;

  @override
  void roll() {
    final random = Random();
    _value = _possibleValues[random.nextInt(_possibleValues.length)];
  }
}
