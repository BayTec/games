import 'dart:async';

import './player.dart';
import './modifier.dart';

class DartsGame {
  final StreamController<DartsGame> _controller;
  final List<Player> _players;
  final List<Player> _activePlayers;
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
        _activePlayers = [...players],
        _points = points,
        _doubleOut = doubleOut,
        _winners = [],
        _currentPlayer = 0,
        _gameState = GameState.ongoing;

  int get points => _points;
  bool get doubleOut => _doubleOut;
  List<Player> get players => _players;
  List<Player> get activePlayers => _activePlayers;
  List<Player> get winners => _winners;
  Player get currentPlayer => _activePlayers[_currentPlayer];
  GameState get gameState => _gameState;

  void next() {
    if (_gameState == GameState.over) return;

    if (_activePlayers[_currentPlayer].score > _points) {
      _activePlayers[_currentPlayer].invalidateLastTurn();
    }

    if (_doubleOut) {
      bool invalidate = false;
      if ((_points - _activePlayers[_currentPlayer].score) == 1) {
        invalidate = true;
      }

      if (_activePlayers[_currentPlayer].score == _points) {
        final turn = _activePlayers[_currentPlayer].turns.last;
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
        _activePlayers[_currentPlayer].invalidateLastTurn();
      }
    }

    if (_activePlayers[_currentPlayer].score == _points) {
      _winners.add(_activePlayers[_currentPlayer]);
      _activePlayers.removeAt(_currentPlayer);
      _currentPlayer =
          _currentPlayer > 0 ? _currentPlayer - 1 : _activePlayers.length - 1;
    }

    if (_activePlayers.length <= 1) {
      _gameState = GameState.over;
      _notifyListeners();
      return;
    }

    _currentPlayer++;
    if (_currentPlayer > _activePlayers.length - 1) {
      _currentPlayer = 0;
    }

    _notifyListeners();
  }

  void reset() {
    for (final player in _players) {
      player.reset();
    }

    _winners.clear();
    _activePlayers.clear();

    _activePlayers.addAll(_players);

    _currentPlayer = 0;

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
