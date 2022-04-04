import 'package:six_dice/six_dice/score/score.dart';

abstract class Player {
  String name();
  Score score();
  Future<void> turn();
}
