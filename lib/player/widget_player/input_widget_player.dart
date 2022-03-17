import 'package:flutter/material.dart';
import 'package:six_dice/player/widget_player/widget_player.dart';
import 'package:six_dice/score/player_score.dart';
import 'package:six_dice/score/score.dart';

class InputWidgetPlayer extends StatefulWidget implements WidgetPlayer {
  final String _name;
  final Score _score;
  final TextEditingController _scoreController;

  InputWidgetPlayer(this._name, {Key? key})
      : _score = PlayerScore(),
        _scoreController = TextEditingController(),
        super(key: key);

  @override
  State<InputWidgetPlayer> createState() => _InputWidgetPlayerState();

  @override
  String name() => _name;

  @override
  int score() => _score.getValue();

  @override
  int turn() {
    var turnScore = int.tryParse(_scoreController.text) ?? 0;

    _score.setValue(_score.getValue() + turnScore);

    return turnScore;
  }

  @override
  Widget widget() => this;
}

class _InputWidgetPlayerState extends State<InputWidgetPlayer> {
  bool turnDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.name()),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: widget._scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'score'),
                autofocus: true,
              ),
            ),
            Text('Total Score: ${widget.score()}'),
            ElevatedButton(
              onPressed: () {
                if (turnDone) {
                  turnDone = false;
                  widget._scoreController.clear();
                  Navigator.pop(context);
                } else {
                  setState(() {
                    widget.turn();
                    turnDone = true;
                  });
                }
              },
              child: turnDone ? const Text('Next') : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
