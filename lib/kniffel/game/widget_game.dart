import 'dart:async';

import 'package:flutter/material.dart';
import 'package:six_dice/kniffel/game/game.dart';
import 'package:six_dice/kniffel/player/player.dart';
import 'package:six_dice/kniffel/widget/gameover_widget.dart';
import 'package:six_dice/store/property_container.dart';
import 'package:six_dice/store/store.dart';

class WidgetGame extends StatefulWidget implements Game {
  WidgetGame(this._players, {Key? key})
      : _winners = [[]],
        pausedStore = PropertyStore(false),
        super(key: key);

  final List<Player> _players;
  final List<List<Player>> _winners;
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
  int completeRounds = 0;

  @override
  Widget build(BuildContext context) {
    final players = widget.players();
    final fields = players.first.score().fields();

    return Scaffold(
      appBar: AppBar(title: const Text('Kniffel')),
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
                      horizontalInside: BorderSide(color: Colors.black)),
                  children: List.generate(
                      fields.length,
                      (index) => TableRow(
                          children: List.generate(
                              players.length,
                              (index) => TableCell(
                                  child:
                                      Container())))), //TODO: replace the container with actual content
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

              if (widget.pausedStore.get()) {
                break;
              }
            }

            if (widget.pausedStore.get()) {
              break;
            }

            currentPlayerIndex = 0;
          }

          if (!widget.pausedStore.get()) {
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
              widget._winners.add(players
                  .where((element) => element.score().total() == score)
                  .toList());
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameoverWidget(widget._winners)));
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
