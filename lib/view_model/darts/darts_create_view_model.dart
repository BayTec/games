import 'package:games/mvvm/view_model.dart';
import 'package:games/src/games/darts/darts_game.dart';

class DartsCreateViewModel extends ViewModel {
  final List<Player> _players;

  DartsCreateViewModel() : _players = [];

  List<Player> get players => _players;

  void addPlayer(String name) {
    _players.add(Player(name));
    notifyListeners();
  }

  void removePlayer(int index) {
    if (!(0 <= index && index < players.length)) return;

    _players.removeAt(index);
    notifyListeners();
  }

  DartsGame createGame({
    int points = 301,
    bool doubleOut = false,
  }) =>
      DartsGame(players: _players, points: points, doubleOut: doubleOut);
}
