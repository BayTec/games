import 'package:classic_games/mvvm/view_model.dart';
import 'package:classic_games/src/games/six_dice/six_dice_game.dart';

class SixDiceGameViewModel extends ViewModel {
  final SixDiceGame _game;

  SixDiceGameViewModel({
    required SixDiceGame game,
  }) : _game = game;

  List<Player> get players => _game.players;
  Player get currentPlayer => _game.currentPlayer;
  bool get gameOver => _game.over;

  void next() {
    _game.next();
    notifyListeners();
  }
}
