import 'package:six_dice/kniffel/score/score.dart';

abstract class Player {
  String name();
  Score score();
  Future<void> turn();
}
