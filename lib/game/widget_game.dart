import 'package:flutter/material.dart';
import 'package:six_dice/game/game.dart';
import 'package:six_dice/player/player.dart';
import 'package:six_dice/player/widget_player/widget_player.dart';
import 'package:six_dice/widget/winners_widget.dart';

class WidgetGame extends StatefulWidget implements Game {
  final List<WidgetPlayer> _players;
  final List<Player> winners;

  WidgetGame(this._players, {Key? key})
      : winners = [],
        super(key: key);

  @override
  State<WidgetGame> createState() => _WidgetGameState();

  @override
  void play() {}

  @override
  List<WidgetPlayer> players() => _players;
}

class _WidgetGameState extends State<WidgetGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Scores'),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.players().length,
            itemBuilder: (context, index) {
              final player = widget.players()[index];
              return ListTile(
                title: Text('${player.name()}: ${player.score()}'),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              for (final player in widget.players()) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => player.widget(),
                  ),
                );

                if (player.score() >= 5000) {
                  setState(() {
                    widget.winners.add(player);
                  });
                }
              }
              if (widget.winners.isNotEmpty) {
                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WinnersWidget(widget.winners)));
              } else {
                setState(() {});
              }
            },
            child: const Text('Turn'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
