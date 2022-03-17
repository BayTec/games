import 'package:flutter/material.dart';
import 'package:six_dice/player/player.dart';

class WinnersWidget extends StatelessWidget {
  final List<Player> winners;

  const WinnersWidget(this.winners, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Winners')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: winners.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(winners[index].name()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}
