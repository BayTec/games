import 'package:flutter/material.dart';
import 'package:classic_games/kniffel/game/widget_game.dart';
import 'package:classic_games/kniffel/player/player.dart';
import 'package:classic_games/kniffel/widget/add_player_widget.dart';

class KniffelWidget extends StatefulWidget {
  const KniffelWidget({Key? key}) : super(key: key);

  @override
  State<KniffelWidget> createState() => _KniffelWidgetState();
}

class _KniffelWidgetState extends State<KniffelWidget> {
  // ignoring const because List needs to be extandable
  // ignore: prefer_const_literals_to_create_immutables
  final game = WidgetGame([]);

  @override
  Widget build(BuildContext context) {
    var players = game.players();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kniffel'),
      ),
      body: Hero(
        tag: 'kniffel',
        child: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome to Kniffel!',
                ),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    var icon = Icons.person;

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
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => game,
                          ));
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
