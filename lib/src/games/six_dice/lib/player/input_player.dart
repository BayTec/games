import './player.dart';

class InputPlayer extends Player {
  final String _name;
  int _score;

  InputPlayer({
    required String name,
  })  : _name = name,
        _score = 0;

  @override
  String get name => _name;
  @override
  int get score => _score;

  void turn(int score) => _score += score;
}
