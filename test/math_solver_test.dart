import 'dart:collection';
import 'dart:convert';

import 'package:math_solver/math_solver.dart';
import 'package:math_solver/src/bigint.dart';
import 'package:math_solver/src/format.dart';
import 'package:math_solver/src/solver.dart';
import 'package:math_solver/src/enum.dart';
import 'package:test/test.dart';

void main() {
  group('remap values', () {
    var testValues = {
      '√9': [
        {'√': 'sqrt'},
        'sqrt9'
      ],
    };
    for (final entry in testValues.entries) {
      test(entry.key, () {
        expect(remapValues(entry.key, entry.value[0]), entry.value[1]);
      });
    }
  });
  group('solver unit test', () {
    var testValues = {
      '6*6': 36,
      '-6+(3*4)': 6,
      '2*sqrt(9)': 6,
      '3+4*2/(1-5)^2^3': 3.0001220703125,
      '((10-4*2)^3)^2': 64,
      '2sin(90)': 2,
      '8(10-2': 64,
    };
    for (var entry in testValues.entries) {
      test(entry.key, () async {
        expect(await solve(entry.key), entry.value);
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
  group('bigInt tests', () {
    var x = BigInt.parse('10000000000');
    var s = formatNotation(x);

    var js = '{value: 1.0}';

    Obj.fromJson(jsonDecode(js), t);

    var ls = [
      Num(1),
      Num(15),
      Op(Operator.Add),
    ];

    ls.forEach((element) {
      print(element.toJson());
    });

    test('t1', () {
      var input = [
        Num(2.0),
        Num(10000.0),
        Num(100.0),
        Op(Operator.Exponent),
        Op(Operator.Multiply),
      ];
      var res = solvewithBigInt(ListQueue.from(input));
      expect(res, BigInt.one, skip: true);
    });
  });
}
