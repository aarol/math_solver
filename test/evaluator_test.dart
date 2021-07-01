import 'package:math_solver/src/evaluator.dart';
import 'package:math_solver/src/infix_postfix.dart';
import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:rational/rational.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  final tokenizer = DefaultTokenizer();
  final infixPostfix = DefaultInfixToPostfix();

  List<Obj> tokenize(String str) => tokenizer.tokenize(str);
  List<Obj> postfix(List<Obj> ls) => infixPostfix.infixToPostfix(ls);

  final evaluator = DefaultEvaluator();

  group('evaluate', () {
    final map = <List<Obj>, Rational>{
      postfix(tokenize('1+2')): rs('3'),
      postfix(tokenize('2 ^ 2 / 2 - 2')): rs('0'),
      postfix(tokenize('12 / (2 + 2 * 2)')): rs('2'),
    };
    for (var entry in map.entries) {
      test(entry.key, () {
        expect(evaluator.evaluate(entry.key), entry.value);
      });
    }
  });
}
