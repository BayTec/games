import 'dart:async';

import 'package:flutter/material.dart';
import 'package:classic_games/mvvm/view_model.dart';

abstract class View<SW extends StatefulWidget, VM extends ViewModel>
    extends State<SW> {
  final VM viewModel;
  final Stream<ViewModel> _stream;

  View(this.viewModel) : _stream = viewModel.listen();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error occured: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            return buildView(context);
          }

          return const CircularProgressIndicator();
        });
  }

  Widget buildView(BuildContext context);
}
