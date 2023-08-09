library darts_game;

import 'dart:async';

part './turn.dart';
part './throw.dart';
part 'player.dart';

class DartsGame {
  final StreamController<DartsGame> _controller;
  final List<Player> _players;
  final List<Player> _winners;
  final int _points;
  final bool _doubleOut;
  int _currentPlayer;
  GameState _gameState;

  DartsGame({
    required List<Player> players,
    int points = 301,
    bool doubleOut = false,
  })  : _controller = StreamController.broadcast(),
        _players = players,
        _points = points,
        _doubleOut = doubleOut,
        _winners = [],
        _currentPlayer = 0,
        _gameState = GameState.ongoing;

  int get points => _points;
  bool get doubleOut => _doubleOut;
  List<Player> get players => _players;
  List<Player> get winners => _winners;
  Player get currentPlayer => _players[_currentPlayer];
  GameState get gameState => _gameState;

  void next() {
    if (_gameState == GameState.over) return;

    if (_players[_currentPlayer].score > _points) {
      _players[_currentPlayer].invalidateLastTurn();
    }

    if (_doubleOut) {
      bool invalidate = false;
      if ((_points - _players[_currentPlayer].score) == 1) {
        invalidate = true;
      }

      if (_players[_currentPlayer].score == _points) {
        final turn = _players[_currentPlayer].turns.last;
        final lastThrow = turn.third.score != 0
            ? turn.third
            : turn.second.score != 0
                ? turn.second
                : turn.first;
        if (lastThrow.modifier != Modifier.double) {
          invalidate = true;
        }
      }

      if (invalidate) {
        _players[_currentPlayer].invalidateLastTurn();
      }
    }

    if (_players[_currentPlayer].score == _points) {
      final playerBefore =
          _currentPlayer > 0 ? _players[_currentPlayer - 1] : _players.last;
      _winners.add(_players[_currentPlayer]);
      _players.removeAt(_currentPlayer);
      _currentPlayer = _players.indexOf(playerBefore);
    }

    if (_players.length <= 1) {
      _gameState = GameState.over;
      _notifyListeners();
      return;
    }

    _currentPlayer++;
    if (_currentPlayer > _players.length - 1) {
      _currentPlayer = 0;
    }

    _notifyListeners();
  }

  void reset() {
    final participants = [...players, ...winners];

    winners.clear();
    players.clear();

    players.addAll(participants.map((e) => Player(e.name)));

    _gameState = GameState.ongoing;

    _notifyListeners();
  }

  StreamSubscription<DartsGame> subscribe(void Function(DartsGame) listener) {
    final subscription = _controller.stream.listen(listener);
    return subscription;
  }

  void _notifyListeners() => _controller.add(this);
}

enum GameState {
  ongoing,
  over,
}
