import 'package:flutter/material.dart';

class MaterialHero extends StatelessWidget {
  const MaterialHero({super.key, required this.tag, required this.child});

  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: tag,
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ));
  }
}
