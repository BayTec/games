library darts_game;

import 'dart:async';

part './turn.dart';
part './throw.dart';
part 'player.dart';

class DartsGame {
  final StreamController<DartsGame> _controller;
  final List<Player> _players;
  final List<Player> _winners;
  int _currentPlayer;
  GameState _gameState;

  DartsGame({
    required List<Player> players,
  })  : _controller = StreamController.broadcast(),
        _players = players,
        _winners = [],
        _currentPlayer = 0,
        _gameState = GameState.ongoing;

  List<Player> get players => _players;
  List<Player> get winners => _winners;
  Player get currentPlayer => _players[_currentPlayer];
  GameState get gameState => _gameState;

  void next() {
    if (_gameState == GameState.over) return;

    // TODO: replace 301 with variable
    if (_players[_currentPlayer].score > 301) {
      _players[_currentPlayer].invalidateLastTurn();
    } else if (_players[_currentPlayer].score == 301) {
      _winners.add(_players[_currentPlayer]);
      _players.removeAt(_currentPlayer);
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
