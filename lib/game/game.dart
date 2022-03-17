import '../player/player.dart';

abstract class Game {
  List<Player> players();
  void play();
}
