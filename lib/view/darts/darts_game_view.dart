import 'dart:async';

import 'package:games/component/material_hero.dart';
import 'package:games/src/games/darts/darts_game.dart';
import 'package:flutter/material.dart';

class DartsGameView extends StatefulWidget {
  const DartsGameView({super.key, required this.game});

  final DartsGame game;

  @override
  State<DartsGameView> createState() => _SixDiceGameViewState();
}

class _SixDiceGameViewState extends State<DartsGameView> {
  late final StreamSubscription<DartsGame> _gameSubscription;
  final List<Throw> _thorws;
  late DartsGame _game;
  Modifier _modifier;

  _SixDiceGameViewState()
      : _thorws = [],
        _modifier = Modifier.signle,
        super();

  addThrow(int value) {
    if (_thorws.length >= 3) return;

    setState(() {
      _thorws.add(Throw(number: value, modifier: _modifier));
    });

    _modifier = Modifier.signle;
  }

  @override
  void initState() {
    super.initState();

    _game = widget.game;
    _gameSubscription = _game.subscribe((game) => setState(() => _game = game));
  }

  @override
  void dispose() {
    _gameSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_game.gameState == GameState.over) {
      final winners = [..._game.winners, ..._game.activePlayers];

      return _GameOver(game: _game, winners: winners);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Darts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialHero(
              tag: 'darts',
              child: _ScoreBoard(game: _game),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${_game.currentPlayer.name}'s turn!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("Rest: ${_game.points - _game.currentPlayer.score}")
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
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
                                  _thorws.elementAtOrNull(index)?.toString() ??
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
                Column(
                  children: [
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
                                  ? () => addThrow(
                                      (indexRow + (5 * indexColumn)) + 1)
                                  : null,
                              child: SizedBox(
                                width: 20.0,
                                child: Text(
                                  ((indexRow + (5 * indexColumn)) + 1)
                                      .toString(),
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
                            onPressed: _thorws.length < 3 &&
                                    _modifier != Modifier.triple
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      while (_thorws.length < 3) {
                        _thorws.add(Throw(number: 0));
                      }

                      _game.currentPlayer.turn(Turn(
                          first: _thorws[0],
                          second: _thorws[1],
                          third: _thorws[2]));
                      _thorws.clear();
                      _game.next();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({
    super.key,
    required this.game,
  });

  final DartsGame game;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1.0,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
              ...List.generate(game.activePlayers.length, (index) {
                final player = game.activePlayers[index];

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
                        (game.points - player.score).toString(),
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
    );
  }
}

class _GameOver extends StatelessWidget {
  const _GameOver({
    super.key,
    required this.game,
    required this.winners,
  });

  final DartsGame game;
  final List<Player> winners;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        leading: BackButton(
          onPressed: () {
            game.reset();
            Navigator.pop(context);
          },
        ),
      ),
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
}
