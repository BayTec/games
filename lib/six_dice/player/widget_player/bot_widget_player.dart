import 'package:flutter/material.dart';
import 'package:six_dice/six_dice/dice/clone_dice.dart';
import 'package:six_dice/six_dice/dice/six_dice.dart';
import 'package:six_dice/six_dice/dice/widget_six_dice.dart';
import 'package:six_dice/six_dice/player/widget_player/widget_player.dart';
import 'package:six_dice/six_dice/score/player_score.dart';
import 'package:six_dice/six_dice/score/score.dart';

import '../../dice/dice.dart';

class BotWidgetPlayer extends StatefulWidget implements WidgetPlayer {
  final String _name;
  final List<Dice> _dices;
  final Score _score;
  final List<List<Dice>> _rolls;

  BotWidgetPlayer(this._name, {Key? key})
      : _dices = [
          SixDice(),
          SixDice(),
          SixDice(),
          SixDice(),
          SixDice(),
          SixDice(),
        ],
        _score = PlayerScore(),
        _rolls = [],
        super(key: key);

  @override
  State<BotWidgetPlayer> createState() => _BotWidgetPlayerState();

  @override
  String name() => _name;

  @override
  int score() => _score.getValue();

  @override
  int turn() {
    int turnScore = 0;
    int prevScore = 0;
    var inDices = <Dice>[];
    final values = _dices.first.values();
    final Map<int, List<Dice>> mappedDices = {};

    inDices.addAll(_dices);

    do {
      // roll all dices
      for (final element in inDices) {
        element.roll();
      }

      // save current roll
      final List<Dice> roll = [];
      for (final dice in inDices) {
        roll.add(CloneDice(dice));
      }
      _rolls.add(roll);

      // split dices by values
      for (final value in values) {
        List<Dice> list = [];
        list.addAll(inDices.where((element) => element.value() == value));
        mappedDices[value] = list;
      }

      // Check for strike
      if (inDices.length == _dices.length) {
        var strike = false;
        for (final value in values) {
          if (mappedDices[value]!.length == inDices.length) {
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
      if (inDices.length == _dices.length) {
        for (final value in values) {
          if (mappedDices[value]!.length != 1) {
            street = false;
            break;
          }
        }
        if (street) {
          turnScore += 2000;
          inDices.clear();
        }
      }

      // Check for 3 of a kind
      if (inDices.length >= 3) {
        for (var i = values.length - 1; i >= 0; i--) {
          if (mappedDices[values[i]]!.length >= 3) {
            if (values[i] == 1) {
              turnScore += 1000;
            } else {
              turnScore += values[i] * 100;
            }
            for (var x = 0; x < 3; x++) {
              var index =
                  inDices.indexWhere((element) => element.value() == values[i]);
              inDices.removeAt(index);
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
      for (var i = 0; i < inDices.length; i++) {
        if (inDices[i].value() == 1) {
          turnScore += 100;
          removeIndexes.add(i);
        }
      }

      for (var i = 0; i < removeIndexes.length; i++) {
        inDices.removeAt(removeIndexes[i] - i);
      }

      removeIndexes.clear();

      for (var i = 0; i < inDices.length; i++) {
        if (inDices[i].value() == 5) {
          turnScore += 50;
          removeIndexes.add(i);
        }
      }

      for (var i = 0; i < removeIndexes.length; i++) {
        inDices.removeAt(removeIndexes[i] - i);
      }

      // Check if the score changed
      if (turnScore == prevScore) {
        turnScore = 0;
        break;
      }

      // Check if the score is at least 350 and inDices is not empty
      if (turnScore >= 350 && inDices.isNotEmpty) {
        break;
      }

      // Check if all dices are used
      if (inDices.isEmpty) {
        inDices.addAll(_dices);
      }

      prevScore = turnScore;
    } while (inDices.isNotEmpty);

    _score.setValue(_score.getValue() + turnScore);
    return turnScore;
  }

  @override
  Widget widget() => this;
}

class _BotWidgetPlayerState extends State<BotWidgetPlayer> {
  late final int oldScore;
  late final int turnScore;

  @override
  void initState() {
    oldScore = widget.score();
    turnScore = widget.turn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name()),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.name()),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget._rolls.length,
              itemBuilder: (context, index) {
                final roll = widget._rolls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(
                      roll.length,
                      (index) {
                        final dice = roll[index];
                        return WidgetSixDice(dice);
                      },
                    ),
                  ),
                );
              },
            ),
            Text('Turn Score: $turnScore'),
            Text('New Total Score: ${widget.score()}'),
            Text('Old Total Score: $oldScore'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget._rolls.clear();
          });
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
