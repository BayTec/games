import 'package:flutter/material.dart';
import 'package:six_dice/six_dice/widget/six_dice_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Six Dies',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const SixDiceWidget(),
    );
  }
}
