import 'package:flutter/material.dart';
import 'package:classic_games/six_dice/game/widget_game.dart';
import 'package:classic_games/six_dice/player/bot_player.dart';
import 'package:classic_games/six_dice/player/player.dart';
import 'package:classic_games/six_dice/widget/add_player_widget.dart';

class SixDiceWidget extends StatefulWidget {
  const SixDiceWidget({Key? key}) : super(key: key);

  @override
  State<SixDiceWidget> createState() => _SixDiceWidgetState();
}

class _SixDiceWidgetState extends State<SixDiceWidget> {
  // ignoring const because List needs to be extandable
  // ignore: prefer_const_literals_to_create_immutables
  final game = WidgetGame([]);

  @override
  Widget build(BuildContext context) {
    var players = game.players();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Six Dice'),
      ),
      body: Hero(
        tag: 'six_dice',
        child: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome to Six Dice!',
                ),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    var icon = Icons.person;

                    if (player.runtimeType == BotPlayer) {
                      icon = Icons.computer;
                    }

                    return ListTile(
                      leading: Icon(icon),
                      title: Text(player.name()),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            players.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (players.isNotEmpty) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => game,
                          ));
                      setState(() {
                        players.clear();
                      });
                    } else {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('No Players'),
                                content: const Text(
                                    'Please add at least one player!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    }
                  },
                  child: const Text('Start Game!'),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push<Player>(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPlayerWidget(game))).then((value) {
            if (value != null) {
              setState(() {
                players.add(value);
              });
            }
          });
        },
      ),
    );
  }
}
