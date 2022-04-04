import 'package:flutter/material.dart';
import 'package:classic_games/kniffel/widget/kniffel_widget.dart';
import 'package:classic_games/six_dice/widget/six_dice_widget.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classic Games',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            Hero(
              tag: 'six_dice',
              child: Material(
                child: GameKachel(
                  title: const Text('Six Dice'),
                  route: () => MaterialPageRoute(
                    builder: (context) => const SixDiceWidget(),
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'kniffel',
              child: Material(
                child: GameKachel(
                  title: const Text('Kniffel'),
                  route: () => MaterialPageRoute(
                    builder: (context) => const KniffelWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameKachel extends StatelessWidget {
  const GameKachel({
    required this.title,
    required this.route,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final MaterialPageRoute Function() route;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, route());
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          title,
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
