import 'package:flutter/material.dart';

class FloatingActionMenu extends StatelessWidget {
  const FloatingActionMenu(
      {super.key, List<Widget> children = const <Widget>[]})
      : _children = children;

  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    if (_children.length > 1) {
      _children.insert(
          1,
          const SizedBox(
            height: 24.0,
          ));
    }

    for (int i = _children.length - 1; i >= 3; i--) {
      _children.insert(
          i,
          const SizedBox(
            height: 16.0,
          ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.up,
      children: _children,
    );
  }
}
