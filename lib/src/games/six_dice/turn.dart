part of './six_dice_game.dart';

class Turn {
  final List<List<int>> rolls;
  final int score;

  Turn({
    required this.rolls,
    required this.score,
  });
}
