import 'package:games/mvvm/view_model.dart';
import 'package:games/src/games/six_dice/six_dice_game.dart';

class SixDiceGameViewModel extends ViewModel {
  final SixDiceGame _game;

  SixDiceGameViewModel({
    required SixDiceGame game,
  }) : _game = game {
    _game.subscribe((game) {
      notifyListeners();
    });
  }

  List<Player> get players => _game.players;
  Player get currentPlayer => _game.currentPlayer;
  GameState get gameState => _game.gameState;

  void next() {
    _game.next();
  }
}
