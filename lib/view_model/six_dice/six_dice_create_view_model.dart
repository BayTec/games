import 'package:games/mvvm/view_model.dart';
import 'package:games/src/games/six_dice/six_dice_game.dart';

class SixDiceCreateViewModel extends ViewModel {
  final List<Player> _players;

  SixDiceCreateViewModel() : _players = [];

  List<Player> get players => _players;

  void addPlayer(String name, bool bot) {
    if (bot) {
      _players.add(BotPlayer(name: name));
    } else {
      _players.add(InputPlayer(name: name));
    }
    notifyListeners();
  }

  void removePlayer(int index) {
    if (!(0 <= index && index < players.length)) return;

    _players.removeAt(index);
    notifyListeners();
  }

  SixDiceGame createGame() => SixDiceGame(players: _players);
}
