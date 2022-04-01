import 'package:six_dice/kniffel/score/score.dart';

class KniffelScore implements Score {
  final Map<String, int?> _fields;

  KniffelScore()
      : _fields = {
          '1': null,
          '2': null,
          '3': null,
          '4': null,
          '5': null,
          '6': null,
          '3er': null,
          '4er': null,
          'full house': null,
          'small street': null,
          'large street': null,
          'kniffel': null,
          'chance': null,
        };

  @override
  Map<String, int?> fields() => _fields;

  @override
  int total() => totalFirst() + totalSecond();

  @override
  int totalFirst() {
    final map = fields();

    var result = (map['1'] ?? 0) +
        (map['2'] ?? 0) +
        (map['3'] ?? 0) +
        (map['4'] ?? 0) +
        (map['5'] ?? 0) +
        (map['6'] ?? 0);

    if (result >= 63) {
      result += 35;
    }

    return result;
  }

  @override
  int totalSecond() {
    final map = fields();

    return (map['3er'] ?? 0) +
        (map['4er'] ?? 0) +
        (map['full house'] ?? 0) +
        (map['small street'] ?? 0) +
        (map['large street'] ?? 0) +
        (map['kniffel'] ?? 0) +
        (map['chance'] ?? 0);
  }
}
