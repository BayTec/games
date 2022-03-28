import 'package:flutter/material.dart';
import 'package:six_dice/six_dice/player/player.dart';

abstract class WidgetPlayer implements Player {
  Widget widget();
}
