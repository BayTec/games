import 'package:games/component/material_hero.dart';
import 'package:games/component/outlined_text_field.dart';
import 'package:games/src/games/six_dice/six_dice_game.dart';
import 'package:games/view_model/six_dice_game_view_model.dart';
import 'package:flutter/material.dart';
import 'package:games/mvvm/view.dart' as mvvm;

class SixDiceGameView extends StatefulWidget {
  const SixDiceGameView({super.key, required SixDiceGame game}) : _game = game;

  final SixDiceGame _game;

  @override
  // ignore: no_logic_in_create_state
  State<SixDiceGameView> createState() => _SixDiceGameViewState(game: _game);
}

class _SixDiceGameViewState
    extends mvvm.View<SixDiceGameView, SixDiceGameViewModel> {
  final TextEditingController _inputController;

  _SixDiceGameViewState({required SixDiceGame game})
      : _inputController = TextEditingController(),
        super(SixDiceGameViewModel(game: game));

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget buildView(BuildContext context) {
    if (viewModel.gameState == GameState.over) {
      final winners = [...viewModel.players];
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
                        ...List.generate(viewModel.players.length, (index) {
                          final player = viewModel.players[index];

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
              "${viewModel.currentPlayer.name}'s turn!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Builder(
              builder: (context) {
                if (viewModel.currentPlayer.runtimeType == InputPlayer) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 80.0, 0.0),
                    child: OutlinedTextField(
                      controller: _inputController,
                      label: 'Score',
                    ),
                  );
                } else if (viewModel.currentPlayer.runtimeType == BotPlayer) {
                  final botPlayer = viewModel.currentPlayer as BotPlayer;
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
          if (viewModel.currentPlayer.runtimeType == InputPlayer) {
            (viewModel.currentPlayer as InputPlayer)
                .turn(int.tryParse(_inputController.text) ?? 0);
            _inputController.clear();
          }
          viewModel.next();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
