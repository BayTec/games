library six_dice_game;

import 'dart:async';

import 'package:games/src/dice.dart';
import 'package:games/src/six_sided_dice.dart';

part './player/player.dart';
part './player/bot_player.dart';
part './player/input_player.dart';
part './turn.dart';

class SixDiceGame {
  final StreamController<SixDiceGame> _controller;
  final List<Player> _players;
  int _currentPlayer;
  GameState _gameState;

  SixDiceGame({
    required List<Player> players,
  })  : _controller = StreamController.broadcast(),
        _players = players,
        _currentPlayer = 0,
        _gameState = GameState.ongoing {
    if (players[_currentPlayer].runtimeType == BotPlayer) {
      (players[_currentPlayer] as BotPlayer).turn();
    }
  }

  List<Player> get players => _players;
  Player get currentPlayer => _players[_currentPlayer];
  GameState get gameState => _gameState;

  void next() {
    if (_gameState == GameState.over) return;

    _currentPlayer++;

    if (_currentPlayer > _players.length - 1) {
      if (_players.any((element) => element.score >= 5000)) {
        _gameState = GameState.over;
        _notifyListeners();
        return;
      }

      _currentPlayer = 0;
    }

    if (players[_currentPlayer].runtimeType == BotPlayer) {
      (players[_currentPlayer] as BotPlayer).turn();
    }

    _notifyListeners();
  }

  StreamSubscription<SixDiceGame> subscribe(
      void Function(SixDiceGame) listener) {
    final subscription = _controller.stream.listen(listener);
    return subscription;
  }

  void _notifyListeners() => _controller.add(this);
}

enum GameState {
  ongoing,
  over,
}
