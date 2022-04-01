import 'package:six_dice/store/store.dart';

class PropertyStore<T> implements Store<T> {
  T _property;

  PropertyStore(this._property);

  @override
  T get() => _property;

  @override
  void set(T value) {
    _property = value;
  }
}
