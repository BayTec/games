import 'package:classic_games/kniffel/player/player.dart';

abstract class Game {
  List<Player> players();
  void play();
  void pause();
}
