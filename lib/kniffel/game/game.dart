import 'package:six_dice/kniffel/player/player.dart';

abstract class Game {
  List<Player> players();
  void play();
  void pause();
}
