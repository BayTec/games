import 'package:flutter/material.dart';
import 'package:six_dice/player/player.dart';

class GameoverWidget extends StatelessWidget {
  final List<List<Player>> finischedPlayers;

  const GameoverWidget(this.finischedPlayers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish'),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: finischedPlayers.length,
          itemBuilder: (context, i) {
            final positionedFinishedPlayers = finischedPlayers[i];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${i + 1}.'),
                    ],
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      finischedPlayers[i].length,
                      (x) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(positionedFinishedPlayers[x].name()),
                            Text(positionedFinishedPlayers[x]
                                .score()
                                .toString()),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
