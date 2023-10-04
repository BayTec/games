import './throw.dart';

class Turn {
  final Throw _first;
  final Throw _second;
  final Throw _third;
  bool _valid;

  Turn({
    required Throw first,
    required Throw second,
    required Throw third,
  })  : _first = first,
        _second = second,
        _third = third,
        _valid = true;

  Throw get first => _first;
  Throw get second => _second;
  Throw get third => _third;
  bool get valid => _valid;
  int get score => _valid ? _first.score + _second.score + _third.score : 0;

  void invalidate() => _valid = false;
}
