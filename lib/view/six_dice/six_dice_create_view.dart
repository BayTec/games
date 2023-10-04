import 'package:games/component/material_hero.dart';
import 'package:games/component/outlined_text_field.dart';
import 'package:games/src/games/six_dice/six_dice.dart';
import 'package:games/view/six_dice/six_dice_game_view.dart';
import 'package:flutter/material.dart';

class SixDiceCreateView extends StatefulWidget {
  const SixDiceCreateView({Key? key}) : super(key: key);

  @override
  State<SixDiceCreateView> createState() => _SixDiceCreateViewState();
}

class _SixDiceCreateViewState extends State<SixDiceCreateView> {
  final List<Player> _players;
  final TextEditingController _nameController;
  bool _bot;

  _SixDiceCreateViewState()
      : _players = [],
        _nameController = TextEditingController(),
        _bot = false,
        super();

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Six Dice')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialHero(
                tag: 'six-dice',
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
                              leading: player.runtimeType == InputPlayer
                                  ? const Icon(Icons.person)
                                  : const Icon(Icons.computer),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Bot'),
                      Switch(
                        value: _bot,
                        onChanged: (value) => setState(() => _bot = value),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() {
                    _players.add(_bot
                        ? BotPlayer(name: _nameController.text)
                        : InputPlayer(name: _nameController.text));
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
                builder: (context) => SixDiceGameView(
                      game: SixDiceGame(players: _players),
                    ))),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
