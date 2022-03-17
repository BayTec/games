import 'package:six_dice/score/score.dart';

class PlayerScore implements Score {
  int _value;

  PlayerScore() : _value = 0;

  @override
  int getValue() => _value;

  @override
  void setValue(int value) {
    _value = value;
  }
}
