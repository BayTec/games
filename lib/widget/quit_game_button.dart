import 'package:flutter/material.dart';

class QuitGameButton extends StatelessWidget {
  const QuitGameButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        bool quit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Quit'),
                content: const Text('Are you shure you want to quit the game?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Quit',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;

        if (quit) {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.cancel),
    );
  }
}
