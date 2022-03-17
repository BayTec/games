import 'package:six_dice/dice/dice.dart';

class CloneDice implements Dice {
  final int _value;
  final List<int> _values;

  CloneDice(Dice origin)
      : _value = origin.value(),
        _values = origin.values();

  @override
  void roll() {}

  @override
  int value() => _value;

  @override
  List<int> values() => _values;
}
