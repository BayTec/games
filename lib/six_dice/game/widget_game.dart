import 'package:flutter/material.dart';
import 'package:six_dice/six_dice/game/game.dart';
import 'package:six_dice/six_dice/player/player.dart';
import 'package:six_dice/six_dice/widget/finished_players_widget.dart';
import 'package:six_dice/six_dice/widget/gameover_widget.dart';
import 'package:six_dice/store/property_container.dart';
import 'package:six_dice/store/store.dart';
import 'package:six_dice/widget/quit_game_button.dart';

class WidgetGame extends StatefulWidget implements Game {
  WidgetGame(this._players, {Key? key})
      : _finishedPlayers = [[]],
        pausedStore = PropertyStore(false),
        super(key: key);

  final List<Player> _players;
  final List<List<Player>> _finishedPlayers;
  final Store<bool> pausedStore;

  @override
  State<WidgetGame> createState() => _WidgetGameState();

  @override
  List<Player> players() => _players;

  @override
  void pause() {
    pausedStore.set(true);
  }

  @override
  void play() {
    pausedStore.set(false);
  }
}

class _WidgetGameState extends State<WidgetGame> {
  int? currentPlayerIndex;
  int finishedPlayersIndex = 0;

  @override
  Widget build(BuildContext context) {
    final players = widget.players();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: const QuitGameButton(),
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
                                  player.score().getValue().toString(),
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
                FinishedPlayersWidget(finischedPlayers: widget._finishedPlayers)
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.play();

          do {
            for (int i = currentPlayerIndex ?? 0; i < players.length; i++) {
              currentPlayerIndex = i;
              final player = players[i];
              await player.turn();

              if (widget.pausedStore.get()) {
                break;
              }
            }

            if (widget.pausedStore.get()) {
              break;
            }

            for (final player in players) {
              if (player.score().getValue() >= 5000) {
                widget._finishedPlayers[finishedPlayersIndex].add(player);
              }
            }

            for (final player
                in widget._finishedPlayers[finishedPlayersIndex]) {
              players.remove(player);
            }

            if (widget._finishedPlayers[finishedPlayersIndex].isNotEmpty &&
                players.isNotEmpty) {
              widget._finishedPlayers.add([]);
              finishedPlayersIndex++;
            }

            currentPlayerIndex = 0;
          } while (players.isNotEmpty);

          if (players.isEmpty) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GameoverWidget(widget._finishedPlayers)));
          } else {
            setState(() {});
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
