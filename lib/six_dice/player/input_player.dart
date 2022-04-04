import 'package:flutter/material.dart';
import 'package:classic_games/main.dart';
import 'package:classic_games/six_dice/game/game.dart';
import 'package:classic_games/six_dice/player/player.dart';
import 'package:classic_games/six_dice/score/player_score.dart';
import 'package:classic_games/six_dice/score/score.dart';

class InputPlayer implements Player {
  InputPlayer(
    this._name,
    this._game,
  ) : _score = PlayerScore();

  final String _name;
  final Game _game;
  final Score _score;

  @override
  String name() => _name;

  @override
  Score score() => _score;

  @override
  Future<void> turn() async {
    final pause = await Navigator.push(scaffoldKey.currentContext!,
            MaterialPageRoute(builder: (context) => InputPlayerWidget(this))) ??
        false;

    if (pause) {
      _game.pause();
    }
  }
}

class InputPlayerWidget extends StatefulWidget {
  const InputPlayerWidget(this._player, {Key? key}) : super(key: key);

  final Player _player;

  @override
  State<InputPlayerWidget> createState() => _InputPlayerWidgetState();
}

class _InputPlayerWidgetState extends State<InputPlayerWidget> {
  final TextEditingController _controller = TextEditingController();
  late int newScore;

  int currentScore() => widget._player.score().getValue();

  @override
  void initState() {
    newScore = widget._player.score().getValue();

    _controller.addListener(() {
      setState(() {
        newScore = (int.tryParse(_controller.text) ?? 0) + currentScore();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._player.name()),
        leading: IconButton(
          icon: const Icon(Icons.list_alt),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Current Score: ${currentScore()}'),
                Text('New Score: $newScore'),
              ],
            ),
            TextField(
              autofocus: true,
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'value'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget._player.score().setValue(newScore);
          Navigator.pop(context, false);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
