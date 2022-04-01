import 'package:flutter/material.dart';
import 'package:six_dice/six_dice/game/game.dart';
import 'package:six_dice/six_dice/player/player.dart';
import 'package:six_dice/six_dice/player/widget_player/widget_player.dart';
import 'package:six_dice/six_dice/widget/finished_players_widget.dart';
import 'package:six_dice/six_dice/widget/gameover_widget.dart';

class WidgetGame extends StatefulWidget implements Game {
  final List<WidgetPlayer> _players;
  final List<List<Player>> finishedPlayers;

  WidgetGame(this._players, {Key? key})
      : finishedPlayers = [[]],
        super(key: key);

  @override
  State<WidgetGame> createState() => _WidgetGameState();

  @override
  List<WidgetPlayer> players() => _players;
}

class _WidgetGameState extends State<WidgetGame> {
  WidgetPlayer? currentPlayer;
  int finishedPlayersIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          onPressed: () async {
            bool quit = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Quit'),
                    content:
                        const Text('Are you shure you want to quit the game?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Quit',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (quit) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Scores'),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: const TableBorder(
                      horizontalInside: BorderSide(color: Colors.black)),
                  children: List.generate(
                    widget.players().length,
                    (index) {
                      final player = widget.players()[index];
                      return TableRow(
                        children: [
                          TableCell(
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  player.name(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  player.score().toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Finished players'),
                ),
                FinishedPlayersWidget(finischedPlayers: widget.finishedPlayers)
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          currentPlayer ??= widget.players().first;
          bool turn = true;

          int startIndex = widget
              .players()
              .indexWhere((element) => element == currentPlayer);

          do {
            for (int i = startIndex; i < widget.players().length; i++) {
              currentPlayer = widget.players()[i];

              turn = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => currentPlayer!.widget(),
                    ),
                  ) ??
                  true;

              if (currentPlayer!.score() >= 5000) {
                widget.finishedPlayers[finishedPlayersIndex]
                    .add(currentPlayer!);
              }

              setState(() {});

              if (!turn) {
                break;
              }
            }

            for (final player in widget.finishedPlayers[finishedPlayersIndex]) {
              widget.players().remove(player);
            }

            startIndex = 0;

            if (turn &&
                widget.finishedPlayers[finishedPlayersIndex].isNotEmpty) {
              if (widget.players().isEmpty) {
                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GameoverWidget(widget.finishedPlayers)));
                break;
              }

              finishedPlayersIndex++;
              widget.finishedPlayers.add([]);

              if (widget.players().length == 1) {
                final player = widget.players().first;
                widget.finishedPlayers[finishedPlayersIndex].add(player);
                widget.players().remove(player);

                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GameoverWidget(widget.finishedPlayers)));
                break;
              }
            }
          } while (turn);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
