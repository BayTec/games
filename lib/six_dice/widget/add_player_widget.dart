import 'package:flutter/material.dart';
import 'package:classic_games/six_dice/game/game.dart';
import 'package:classic_games/six_dice/player/bot_player.dart';
import 'package:classic_games/six_dice/player/input_player.dart';
import 'package:classic_games/six_dice/player/player.dart';

class AddPlayerWidget extends StatelessWidget {
  const AddPlayerWidget(this._game, {Key? key}) : super(key: key);

  final Game _game;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('New Player:'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: 'Name'),
                  autofocus: true,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              heroTag: 'add_player',
              onPressed: () {
                Navigator.pop<Player>(
                    context, InputPlayer(nameController.text, _game));
              },
              child: const Icon(Icons.person),
            ),
          ),
          FloatingActionButton(
            heroTag: 'add_bot',
            onPressed: () {
              Navigator.pop<Player>(
                  context, BotPlayer(nameController.text, _game));
            },
            child: const Icon(Icons.computer),
          ),
        ],
      ),
    );
  }
}
