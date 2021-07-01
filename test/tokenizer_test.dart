import 'dart:math';

import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:math_solver/src/util.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  final tokenizer = DefaultTokenizer();

  final map = <String, List<Obj>>{
    '1+2': [Num(r(1)), Op(Operator.add), Num(r(2))],
    '2^8': [Num(r(2)), Op(Operator.exponent), Num(r(8))],
    '2.5*4.000001': [Num(r(2.5)), Op(Operator.multiply), Num(r(4.000001))],
    '100*0': [Num(r(100)), Op(Operator.multiply), Num(r(0))],
    'sin(3^2)': [
      Fun(Function.sin),
      ParL(),
      Num(r(3)),
      Op(Operator.exponent),
      Num(r(2)),
      ParR(),
    ],
    'tan(π/2.99)': [
      Fun(Function.tan),
      ParL(),
      Num(r(pi)),
      Op(Operator.divide),
      Num(r(2.99)),
      ParR()
    ],
    '2(sqrt(9)+2)': [
      Num(r(2)),
      Op(Operator.multiply),
      ParL(),
      Fun(Function.squareRoot),
      ParL(),
      Num(r(9)),
      ParR(),
      Op(Operator.add),
      Num(r(2)),
      ParR(),
    ],
    '10sqrt(81)': [
      Num(r(10)),
      Op(Operator.multiply),
      Fun(Function.squareRoot),
      ParL(),
      Num(r(81)),
      ParR(),
    ],
    'sqrt 1+2': [
      Fun(Function.squareRoot),
      ParL(),
      Num(r(1)),
      ParR(),
      Op(Operator.add),
      Num(r(2)),
    ],
    // in postfix
    '2 1 +': [Num(r(2)), Num(r(1)), Op(Operator.add)],
    '2 2 ^ 2 / 2 -': [
      Num(r(2)),
      Num(r(2)),
      Op(Operator.exponent),
      Num(r(2)),
      Op(Operator.divide),
      Num(r(2)),
      Op(Operator.substract)
    ],
  };

  group('tokenize', () {
    for (var entry in map.entries) {
      test(entry.key, () {
        expect(tokenizer.tokenize(entry.key), entry.value);
      });
    }
  });

  group('replace', () {
    var tInput = '√1×2÷8';
    var tOutput = 'sqrt1*2/8';
    test('√1×2÷8', () {
      expect(
          tokenizer.replace(tInput, {
            '×': '*',
            '√': 'sqrt',
            '÷': '/',
          }),
          tOutput);
    });
  });
}
