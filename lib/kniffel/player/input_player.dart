import 'package:flutter/material.dart';
import 'package:six_dice/kniffel/game/game.dart';
import 'package:six_dice/kniffel/player/player.dart';
import 'package:six_dice/kniffel/score/kniffel_score.dart';
import 'package:six_dice/kniffel/score/score.dart';
import 'package:six_dice/main.dart';

class InputPlayer implements Player {
  final String _name;
  final Score _score;
  final Game _game;

  InputPlayer(this._name, this._game) : _score = KniffelScore();

  @override
  String name() => _name;

  @override
  Score score() => _score;

  @override
  Future<void> turn() async {
    final pause = await Navigator.push<bool>(scaffoldKey.currentContext!,
            MaterialPageRoute(builder: (context) => InputPlayerWidget(this))) ??
        false;

    if (pause) {
      _game.pause();
    }
  }
}

class InputPlayerWidget extends StatefulWidget {
  const InputPlayerWidget(this.player, {Key? key}) : super(key: key);

  final Player player;

  @override
  State<InputPlayerWidget> createState() => _InputPlayerWidgetState();
}

class _InputPlayerWidgetState extends State<InputPlayerWidget> {
  String selectedKey = '';
  bool additionalKniffel = false;
  final valueController = TextEditingController();

  @override
  void initState() {
    valueController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final openFields = widget.player
        .score()
        .fields()
        .entries
        .where(
          (element) => element.value == null,
        )
        .toList();

    final additionalKniffelSelectable = !openFields.any(
      (element) => element.key == 'kniffel',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name()),
        leading: IconButton(
          icon: const Icon(Icons.list_alt),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: openFields.length,
              itemBuilder: (context, index) {
                final entry = openFields[index];
                return RadioListTile(
                  title: Text(entry.key),
                  value: entry.key,
                  groupValue: selectedKey,
                  onChanged: (value) {
                    setState(() {
                      selectedKey = value != null ? value.toString() : '';
                    });
                  },
                );
              },
            ),
            CheckboxListTile(
              title: const Text('Additional Kniffel'),
              value: additionalKniffel,
              onChanged: (value) {
                if (additionalKniffelSelectable) {
                  setState(() {
                    additionalKniffel = value ?? false;
                  });
                }
              },
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(hintText: 'value'),
              textAlign: TextAlign.center,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'Total first score: ${widget.player.score().totalFirst()}'),
                Text(
                    'Total second score: ${widget.player.score().totalSecond()}'),
                Text('Total score: ${widget.player.score().total()}'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedKey.isEmpty) {
            await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Nothing selected'),
                      content: const Text('You have to select a field.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
            return;
          }

          final value = int.tryParse(valueController.text);

          if (value == null) {
            await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('No value'),
                      content: const Text('You have to supply a legit value.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
            return;
          }

          if (additionalKniffel) {
            final kniffel = widget.player.score().fields()['kniffel'] ?? 0;
            widget.player.score().fields()['kniffel'] = kniffel + 50;
          }

          widget.player.score().fields()[selectedKey] = value;

          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
