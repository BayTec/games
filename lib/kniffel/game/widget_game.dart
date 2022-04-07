import 'package:classic_games/property/bool_property.dart';
import 'package:classic_games/property/property.dart';
import 'package:flutter/material.dart';
import 'package:classic_games/kniffel/game/game.dart';
import 'package:classic_games/kniffel/player/player.dart';
import 'package:classic_games/kniffel/widget/gameover_widget.dart';
import 'package:classic_games/widget/quit_game_button.dart';

class WidgetGame extends StatefulWidget implements Game {
  WidgetGame(this._players, {Key? key})
      : _finishedPlayers = [],
        paused = BoolProperty(false),
        super(key: key);

  final List<Player> _players;
  final List<List<Player>> _finishedPlayers;
  final Property<bool> paused;

  @override
  State<WidgetGame> createState() => _WidgetGameState();

  @override
  List<Player> players() => _players;

  @override
  void pause() {
    paused.set(true);
  }

  @override
  void play() {
    paused.set(false);
  }
}

class _WidgetGameState extends State<WidgetGame> {
  int? currentPlayerIndex;
  int completeRounds = 0;

  @override
  Widget build(BuildContext context) {
    final players = widget.players();
    final fields = players.first.score().fields();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kniffel'),
        leading: const QuitGameButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text('Scores'),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.black),
                    verticalInside: BorderSide(color: Colors.black),
                  ),
                  children: List.generate(fields.length + 1, (rowIndex) {
                    return TableRow(
                        children:
                            List.generate(players.length + 1, (columnIndex) {
                      late final String content;

                      if (rowIndex == 0) {
                        if (columnIndex == 0) {
                          content = '';
                        } else {
                          content = players[columnIndex - 1].name();
                        }
                      } else if (columnIndex == 0) {
                        content = fields.entries.toList()[rowIndex - 1].key;
                      } else {
                        final value = players[columnIndex - 1]
                            .score()
                            .fields()
                            .entries
                            .toList()[rowIndex - 1]
                            .value;
                        content = value == null ? '' : value.toString();
                      }

                      return TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }));
                  }),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.play();

          for (completeRounds;
              completeRounds < fields.length;
              completeRounds++) {
            for (int i = currentPlayerIndex ?? 0; i < players.length; i++) {
              currentPlayerIndex = i;
              final player = players[i];
              await player.turn();

              if (widget.paused.get()) {
                break;
              }
            }

            if (widget.paused.get()) {
              break;
            }

            currentPlayerIndex = 0;
          }

          if (!widget.paused.get()) {
            List<int> scores = [];
            for (final player in players) {
              final playerTotalScore = player.score().total();
              if (!scores.contains(playerTotalScore)) {
                scores.add(playerTotalScore);
              }
            }

            scores.sort();
            scores = scores.reversed.toList();

            for (final score in scores) {
              widget._finishedPlayers.add(players
                  .where((element) => element.score().total() == score)
                  .toList());
            }

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GameoverWidget(widget._finishedPlayers)));
          } else {
            setState(() {});
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
