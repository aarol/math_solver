import 'dart:math';

import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  final tokenizer = DefaultTokenizer();

  final map = <String, List<Obj>>{
    '1+2': [Num(1), Op(Operator.Add), Num(2)],
    '2.5*4.000001': [Num(2.5), Op(Operator.Multiply), Num(4.000001)],
    '100*0': [Num(100), Op(Operator.Multiply), Num(0)],
    'sin(3^2)': [
      Fun(Function.Sin),
      ParL(),
      Num(3),
      Op(Operator.Exponent),
      Num(2),
      ParR(),
    ],
    'tan(π/2.99)': [
      Fun(Function.Tan),
      ParL(),
      Num(pi),
      Op(Operator.Divide),
      Num(2.99),
      ParR()
    ],
    '2(sqrt(9)+2)': [
      Num(2),
      Op(Operator.Multiply),
      ParL(),
      Fun(Function.SquareRoot),
      ParL(),
      Num(9),
      ParR(),
      Op(Operator.Add),
      Num(2),
      ParR(),
    ],
    // in postfix
    '2 1 +': [Num(2), Num(1), Op(Operator.Add)],
    '2 2 ^ 2 / 2 -': [
      Num(2),
      Num(2),
      Op(Operator.Exponent),
      Num(2),
      Op(Operator.Divide),
      Num(2),
      Op(Operator.Substract)
    ],
  };

  for (var entry in map.entries) {
    test(entry.key, () {
      expect(tokenizer.tokenize(entry.key), entry.value);
    });
  }
}
