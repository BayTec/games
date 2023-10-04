import 'package:games/src/tools/dice/dice.dart';

import './player.dart';
import '../turn.dart';

class BotPlayer extends Player {
  static const maxDices = 6;

  final String _name;
  int _score;
  Turn? _lastTurn;

  BotPlayer({
    required String name,
  })  : _name = name,
        _score = 0;

  @override
  String get name => _name;
  @override
  int get score => _score;
  Turn? get lastTurn => _lastTurn;

  Turn turn() {
    final dices = <Dice>[
      SixSidedDice(),
      SixSidedDice(),
      SixSidedDice(),
      SixSidedDice(),
      SixSidedDice(),
      SixSidedDice(),
    ];
    final rolls = <List<int>>[];
    final Map<int, List<Dice>> mappedDices = {};
    int turnScore = 0;

    if (rolls.isEmpty) {
      int prevScore = 0;
      final values = dices.first.possibleValues;

      do {
        // roll all dices
        for (final element in dices) {
          element.roll();
        }

        // save current roll
        rolls.add(dices.map((e) => e.value).toList());

        // split dices by values
        for (final value in values) {
          List<Dice> list = [];
          list.addAll(dices.where((element) => element.value == value));
          mappedDices[value] = list;
        }

        // Check for strike
        if (dices.length == maxDices) {
          var strike = false;
          for (final value in values) {
            if (mappedDices[value]!.length == dices.length) {
              strike = false;
              break;
            }
          }
          if (strike) {
            turnScore += 5000;
            break;
          }
        }

        // Check for street if all dices where rolled
        var street = true;
        if (dices.length == maxDices) {
          for (final value in values) {
            if (mappedDices[value]!.length != 1) {
              street = false;
              break;
            }
          }
          if (street) {
            turnScore += 2000;
            dices.clear();
          }
        }

        // Check for 3 of a kind
        if (dices.length >= 3) {
          for (var i = values.length - 1; i >= 0; i--) {
            if (mappedDices[values[i]]!.length >= 3) {
              if (values[i] == 1) {
                turnScore += 1000;
              } else {
                turnScore += values[i] * 100;
              }
              for (var x = 0; x < 3; x++) {
                var index =
                    dices.indexWhere((element) => element.value == values[i]);
                dices.removeAt(index);
              }
              for (var x = 0; x < 3; x++) {
                mappedDices[values[i]]!.removeLast();
              }
              break;
            }
          }
        }

        // Check for 1s and 5s
        List<int> removeIndexes = [];
        for (var i = 0; i < dices.length; i++) {
          if (dices[i].value == 1) {
            turnScore += 100;
            removeIndexes.add(i);
          }
        }

        for (var i = 0; i < removeIndexes.length; i++) {
          dices.removeAt(removeIndexes[i] - i);
        }

        removeIndexes.clear();

        for (var i = 0; i < dices.length; i++) {
          if (dices[i].value == 5) {
            turnScore += 50;
            removeIndexes.add(i);
          }
        }

        for (var i = 0; i < removeIndexes.length; i++) {
          dices.removeAt(removeIndexes[i] - i);
        }

        // Check if the score changed
        if (turnScore == prevScore) {
          turnScore = 0;
          break;
        }

        // Check if the score is at least 350 and inDices is not empty
        if (turnScore >= 350 && dices.isNotEmpty) {
          break;
        }

        // Check if all dices are used
        if (dices.isEmpty) {
          dices.addAll([
            SixSidedDice(),
            SixSidedDice(),
            SixSidedDice(),
            SixSidedDice(),
            SixSidedDice(),
            SixSidedDice(),
          ]);
        }

        prevScore = turnScore;
      } while (dices.isNotEmpty);
    }

    _score += turnScore;
    _lastTurn = Turn(
      rolls: rolls,
      score: turnScore,
    );

    return _lastTurn!;
  }
}
