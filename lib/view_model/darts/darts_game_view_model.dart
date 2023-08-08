import 'package:games/mvvm/view_model.dart';
import 'package:games/src/games/darts/darts_game.dart';

class DartsGameViewModel extends ViewModel {
  final DartsGame _game;

  DartsGameViewModel({
    required DartsGame game,
  }) : _game = game {
    _game.subscribe((game) {
      notifyListeners();
    });
  }

  List<Player> get players => _game.players;
  List<Player> get winners => _game.winners;
  Player get currentPlayer => _game.currentPlayer;
  GameState get gameState => _game.gameState;

  void next() {
    _game.next();
  }
}
