import 'package:flutter/material.dart';
import 'package:classic_games/kniffel/player/player.dart';

class FinishedPlayersWidget extends StatelessWidget {
  const FinishedPlayersWidget({
    Key? key,
    required this.finischedPlayers,
  }) : super(key: key);

  final List<List<Player>> finischedPlayers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: finischedPlayers.length,
      itemBuilder: (context, i) {
        final positionedFinishedPlayers = finischedPlayers[i];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.yellow[300],
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
                            .total()
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
    );
  }
}
