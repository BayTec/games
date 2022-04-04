import 'package:classic_games/kniffel/score/score.dart';

abstract class Player {
  String name();
  Score score();
  Future<void> turn();
}
