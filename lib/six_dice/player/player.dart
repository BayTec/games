import 'package:classic_games/six_dice/score/score.dart';

abstract class Player {
  String name();
  Score score();
  Future<void> turn();
}
