import 'dart:async';

import 'package:games/component/material_hero.dart';
import 'package:games/component/outlined_text_field.dart';
import 'package:games/src/games/six_dice/six_dice_game.dart';
import 'package:flutter/material.dart';

class SixDiceGameView extends StatefulWidget {
  const SixDiceGameView({super.key, required SixDiceGame game}) : _game = game;

  final SixDiceGame _game;

  @override
  State<SixDiceGameView> createState() => _SixDiceGameViewState();
}

class _SixDiceGameViewState extends State<SixDiceGameView> {
  final TextEditingController _inputController;
  late final StreamSubscription<SixDiceGame> _gameSubscription;

  _SixDiceGameViewState()
      : _inputController = TextEditingController(),
        super();

  @override
  void initState() {
    super.initState();
    _gameSubscription = widget._game.subscribe((game) => setState(() {}));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _gameSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._game.gameState == GameState.over) {
      final winners = [...widget._game.players];
      winners.sort((a, b) => b.score.compareTo(a.score));

      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MaterialHero(
                tag: 'six-dice',
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('Place'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  'Player',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  'Score',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(winners.length, (index) {
                            final player = winners[index];

                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '${index + 1}.',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    player.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    player.score.toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Six Dice')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialHero(
              tag: 'six-dice',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.0,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: Text('Player'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                'Score',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        ...List.generate(widget._game.players.length, (index) {
                          final player = widget._game.players[index];

                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  player.name,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  player.score.toString(),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "${widget._game.currentPlayer.name}'s turn!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Builder(
              builder: (context) {
                if (widget._game.currentPlayer.runtimeType == InputPlayer) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 80.0, 0.0),
                    child: OutlinedTextField(
                      controller: _inputController,
                      label: 'Score',
                    ),
                  );
                } else if (widget._game.currentPlayer.runtimeType ==
                    BotPlayer) {
                  final botPlayer = widget._game.currentPlayer as BotPlayer;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(botPlayer.lastTurn!.rolls.length,
                            (index) {
                          final roll = botPlayer.lastTurn!.rolls[index];
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                                roll.length,
                                (rollIndex) =>
                                    Text(roll[rollIndex].toString())),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Score:'),
                              Text(
                                botPlayer.lastTurn!.score.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Placeholder();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget._game.currentPlayer.runtimeType == InputPlayer) {
            (widget._game.currentPlayer as InputPlayer)
                .turn(int.tryParse(_inputController.text) ?? 0);
            _inputController.clear();
          }
          widget._game.next();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
