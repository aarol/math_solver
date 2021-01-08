import 'dart:math';

import 'package:math_solver/math_solver.dart';
import 'package:math_solver/src/enum.dart';
import 'package:math_solver/src/format.dart';
import 'package:test/test.dart';

void main() {
  group('object parse test', () {
    test('sin2+1/17', () {
      var input = 'sin2+1/17';
      var res = [
        Fun(Function.Sin),
        Num(2.0),
        Op(Operator.Add),
        Num(1.0),
        Op(Operator.Divide),
        Num(17.0)
      ];
      expect(convertString(input), res);
    });
    test('2π', () {
      var input = '2π';
      var res = 2 * pi;
      expect(solve(input), res);
    });
  });
  group('solver unit test', () {
    var testValues = {
      '6*6': 36,
      '-6+(3*4)': 6,
      '2*sqrt(9)': 6,
      '3+4*2/(1-5)^2^3': 3.0001220703125,
      '((10-4*2)^3)^2': 64,
    };
    for (var entry in testValues.entries) {
      test(entry.key, () {
        expect(solve(entry.key), entry.value);
      });
    }
  });
  group('format output', () {
    var testValues = {
      1633418654.0: '1 633 418 654',
      31415.0: '31 415',
      155.0: '155',
      0.04: '0.04',
      2000.04: '2000.04',
    };
    for (var entry in testValues.entries) {
      test(entry.key, () {
        expect(format(entry.key), entry.value);
      });
    }
  });
  group('format test test', () {
    test('test', () {
      format(6343);
    });
  });
}
