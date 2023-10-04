import './turn.dart';

class Player {
  final String _name;
  final List<Turn> _turns;

  Player(String name)
      : _name = name,
        _turns = [];

  String get name => _name;

  Iterable<Turn> get turns => _turns;

  int get score {
    int result = 0;
    for (final turn in _turns) {
      result += turn.score;
    }
    return result;
  }

  void turn(Turn turn) => _turns.add(turn);
  void invalidateLastTurn() => _turns.last.invalidate();
  void reset() => _turns.clear();
}
