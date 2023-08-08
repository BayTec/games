import 'package:games/component/material_hero.dart';
import 'package:games/src/games/darts/darts_game.dart';
import 'package:games/view_model/darts/darts_game_view_model.dart';
import 'package:flutter/material.dart';
import 'package:games/mvvm/view.dart' as mvvm;

class DartsGameView extends StatefulWidget {
  const DartsGameView({super.key, required DartsGame game}) : _game = game;

  final DartsGame _game;

  @override
  // ignore: no_logic_in_create_state
  State<DartsGameView> createState() => _SixDiceGameViewState(game: _game);
}

class _SixDiceGameViewState
    extends mvvm.View<DartsGameView, DartsGameViewModel> {
  final List<Throw> _thorws;
  Modifier _modifier;

  _SixDiceGameViewState({required DartsGame game})
      : _thorws = [],
        _modifier = Modifier.signle,
        super(DartsGameViewModel(game: game));

  addThrow(int value) {
    if (_thorws.length >= 3) return;

    setState(() {
      _thorws.add(Throw(number: value, modifier: _modifier));
    });

    _modifier = Modifier.signle;
  }

  @override
  Widget buildView(BuildContext context) {
    if (viewModel.gameState == GameState.over) {
      final winners = [...viewModel.winners, ...viewModel.players];

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
                tag: 'darts',
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
                                  textAlign: TextAlign.end,
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
      appBar: AppBar(title: const Text('Darts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialHero(
              tag: 'darts',
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
                                  // TODO: replace 301 with variable
                                  (301 - player.score).toString(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
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
                                  child: Text(
                                    '1.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    '2.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    '3.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: List.generate(
                                3,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    _thorws
                                            .elementAtOrNull(index)
                                            ?.toString() ??
                                        '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => setState(() =>
                              _modifier == Modifier.double
                                  ? _modifier = Modifier.signle
                                  : _modifier = Modifier.double),
                          icon: _modifier == Modifier.double
                              ? const Icon(Icons.check_box_outlined)
                              : const Icon(Icons.check_box_outline_blank),
                          label: const Text('Double'),
                        ),
                        FilledButton.icon(
                          onPressed: () => setState(() =>
                              _modifier == Modifier.triple
                                  ? _modifier = Modifier.signle
                                  : _modifier = Modifier.triple),
                          icon: _modifier == Modifier.triple
                              ? const Icon(Icons.check_box_outlined)
                              : const Icon(Icons.check_box_outline_blank),
                          label: const Text('Triple'),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                    4,
                    (indexColumn) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          5,
                          (indexRow) => FilledButton(
                            onPressed: _thorws.length < 3
                                ? () =>
                                    addThrow((indexRow + (5 * indexColumn)) + 1)
                                : null,
                            child: SizedBox(
                              width: 20.0,
                              child: Text(
                                ((indexRow + (5 * indexColumn)) + 1).toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed:
                              _thorws.length < 3 && _modifier != Modifier.triple
                                  ? () => addThrow(25)
                                  : null,
                          child: const SizedBox(
                            width: 20.0,
                            child: Text(
                              '25',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed:
                              _thorws.length < 3 ? () => addThrow(0) : null,
                          child: const SizedBox(
                            width: 20.0,
                            child: Text(
                              '0',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: _thorws.isNotEmpty
                              ? () => setState(() => _thorws.removeLast())
                              : null,
                          child: const Icon(Icons.backspace),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _thorws.isNotEmpty
            ? () {
                while (_thorws.length < 3) {
                  _thorws.add(Throw(number: 0));
                }

                viewModel.currentPlayer.turn(Turn(
                    first: _thorws[0], second: _thorws[1], third: _thorws[2]));
                _thorws.clear();
                viewModel.next();
              }
            : null,
        child: _thorws.isNotEmpty
            ? const Icon(Icons.arrow_forward)
            : const Icon(Icons.block),
      ),
    );
  }
}
