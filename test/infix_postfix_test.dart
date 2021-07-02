import 'package:math_solver/src/function.dart';
import 'package:math_solver/src/infix_postfix.dart';
import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/operator.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  final infixPostfix = DefaultInfixToPostfix();
  final tokenizer = DefaultTokenizer();

  List<Obj> tokenize(String str) => tokenizer.tokenize(str);

  final map = <List<Obj>, List<Obj>>{
    tokenize('2+1'): tokenize('2 1 +'),
    tokenize('2^2/2-2'): tokenize('2 2 ^ 2 / 2 -'),
    tokenize('12/(2+2*2)'): tokenize('12 2 2 2 * + /'),
    tokenize('sin(tan(cos(5)))'): [
      Num(r(5)),
      Fun(Functions.cos),
      Fun(Functions.tan),
      Fun(Functions.sin)
    ],
    tokenize('(1)-634*(1-42)'): tokenize('1 634 1 42 - * -'),
    tokenize('sqrt(4) * 2'): [
      Num(r(4)),
      Fun(Functions.squareRoot),
      Num(r(2)),
      Op(Operators.multiply),
    ],
  };

  group('infixToPostfix', () {
    for (var entry in map.entries) {
      test(entry.key, () {
        expect(infixPostfix.infixToPostfix(entry.key), entry.value);
      });
    }
  });

  test('specific', () {
    final i = tokenize('sqrt(4) * 2');
    final o = [
      Num(r(4)),
      Fun(Functions.squareRoot),
      Num(r(2)),
      Op(Operators.multiply),
    ];
    expect(infixPostfix.infixToPostfix(i), o);
  });
}
