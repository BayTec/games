library six_dice_game;

import 'package:classic_games/src/dice.dart';
import 'package:classic_games/src/six_sided_dice.dart';

part './player/player.dart';
part './player/bot_player.dart';
part './player/input_player.dart';

class SixDiceGame {
  final List<Player> _players;
  int _currentPlayer;
  bool _over;

  SixDiceGame({
    required List<Player> players,
  })  : _players = players,
        _currentPlayer = 0,
        _over = false {
    if (players[_currentPlayer].runtimeType == BotPlayer) {
      (players[_currentPlayer] as BotPlayer).turn();
    }
  }

  List<Player> get players => _players;
  Player get currentPlayer => _players[_currentPlayer];
  bool get over => _over;

  void next() {
    if (_over) return;

    _currentPlayer++;

    if (_currentPlayer > _players.length - 1) {
      if (_players.any((element) => element.score >= 5000)) {
        _over = true;
        return;
      }

      _currentPlayer = 0;
    }

    if (players[_currentPlayer].runtimeType == BotPlayer) {
      (players[_currentPlayer] as BotPlayer).turn();
    }
  }
}
