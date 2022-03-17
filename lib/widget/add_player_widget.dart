import 'package:flutter/material.dart';
import 'package:six_dice/player/widget_player/bot_widget_player.dart';
import 'package:six_dice/player/widget_player/input_widget_player.dart';
import 'package:six_dice/player/widget_player/widget_player.dart';

class AddPlayerWidget extends StatelessWidget {
  const AddPlayerWidget({Key? key}) : super(key: key);

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
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop<WidgetPlayer>(
                            context, InputWidgetPlayer(nameController.text));
                      },
                      child: const Text('Add Player'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop<WidgetPlayer>(
                            context, BotWidgetPlayer(nameController.text));
                      },
                      child: const Text('Add Bot'),
                    ),
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
