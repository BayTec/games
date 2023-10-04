import 'package:games/component/material_hero.dart';
import 'package:games/component/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:games/src/games/darts/darts_game.dart';
import 'package:games/view/darts/darts_game_view.dart';

class DartsCreateView extends StatefulWidget {
  const DartsCreateView({Key? key}) : super(key: key);

  @override
  State<DartsCreateView> createState() => _DartsCreateViewState();
}

class _DartsCreateViewState extends State<DartsCreateView> {
  final TextEditingController _nameController;
  final List<Player> _players;
  int _points;
  bool _doubleOut;

  _DartsCreateViewState()
      : _nameController = TextEditingController(),
        _players = [],
        _points = 301,
        _doubleOut = false,
        super();

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Darts')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialHero(
                tag: 'darts',
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Players',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _players.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final player = _players[index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(player.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    setState(() => _players.removeAt(index)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _points != 301
                            ? () => setState(() => _points = 301)
                            : null,
                        icon: _points == 301
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank),
                        label: const Text('301'),
                      ),
                      FilledButton.icon(
                        onPressed: _points != 501
                            ? () => setState(() => _points = 501)
                            : null,
                        icon: _points == 501
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank),
                        label: const Text('501'),
                      ),
                      FilledButton.icon(
                        onPressed: _points != 701
                            ? () => setState(() => _points = 701)
                            : null,
                        icon: _points == 701
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank),
                        label: const Text('701'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Double Out'),
                      Switch(
                        value: _doubleOut,
                        onChanged: (value) =>
                            setState(() => _doubleOut = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedTextField(
                  controller: _nameController,
                  label: 'Name',
                  keyboardType: TextInputType.name,
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() {
                    _players.add(Player(_nameController.text));
                    _nameController.clear();
                  }),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Player'),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DartsGameView(
                      game: DartsGame(
                        players: _players,
                        points: _points,
                        doubleOut: _doubleOut,
                      ),
                    ))),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
