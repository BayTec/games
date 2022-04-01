import 'package:flutter/material.dart';
import 'package:six_dice/kniffel/game/game.dart';
import 'package:six_dice/kniffel/player/input_player.dart';
import 'package:six_dice/kniffel/player/player.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop<Player>(
              context, InputPlayer(nameController.text, _game));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
