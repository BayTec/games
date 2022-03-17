import 'package:flutter/material.dart';
import 'package:six_dice/dice/dice.dart';

class WidgetSixDice extends StatelessWidget implements Dice {
  final Dice _dice;

  const WidgetSixDice(this._dice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (value()) {
      case 1:
        return const Icon(Icons.looks_one);
      case 2:
        return const Icon(Icons.looks_two);
      case 3:
        return const Icon(Icons.looks_3);
      case 4:
        return const Icon(Icons.looks_4);
      case 5:
        return const Icon(Icons.looks_5);
      case 6:
        return const Icon(Icons.looks_6);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  @override
  void roll() => _dice.roll();

  @override
  int value() => _dice.value();

  @override
  List<int> values() => _dice.values();
}
