import 'package:classic_games/property/property.dart';

class BoolProperty implements Property<bool> {
  BoolProperty(this.value);

  bool value;

  @override
  bool get() => value;

  @override
  void set(bool value) {
    this.value = value;
  }
}
