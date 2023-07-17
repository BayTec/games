import 'dart:async';

import 'package:flutter/material.dart';

abstract class ViewModel {
  final List<StreamController<ViewModel>> _controllers = [];

  Stream<ViewModel> listen() {
    final controller = StreamController<ViewModel>();
    controller.onListen = () => controller.add(this);
    controller.onCancel = () {
      controller.close();
      _controllers.remove(controller);
    };
    _controllers.add(controller);

    return controller.stream;
  }

  @protected
  void notifyListeners() {
    for (var element in _controllers) {
      element.add(this);
    }
  }
}
