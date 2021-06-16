import 'package:math_solver/src/infixToPostfix.dart';
import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  final infixPostfix = DefaultInfixToPostfix();
  final tokenizer = DefaultTokenizer();

  final tokenize = (str) => tokenizer.tokenize(str);

  final map = <List<Obj>, List<Obj>>{
    tokenize('2+1'): tokenize('2 1 +'),
    tokenize('2^2/2-2'): tokenize('2 2 ^ 2 / 2 -'),
    tokenize('12/(2+2*2)'): tokenize('12 2 2 2 * + /'),
    tokenize('sin(tan(cos(5)))'): [
      Num(5.0),
      Fun(Function.Cos),
      Fun(Function.Tan),
      Fun(Function.Sin)
    ],
    tokenize('(1)-634*(1-42)'): tokenize('1 634 1 42 - * -'),
    tokenize('sqrt(4) * 2'): [
      Num(4),
      Fun(Function.SquareRoot),
      Num(2),
      Op(Operator.Multiply),
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
      Num(4),
      Fun(Function.SquareRoot),
      Num(2),
      Op(Operator.Multiply),
    ];
    expect(infixPostfix.infixToPostfix(i), o);
  });
}
