import 'dart:math';

import 'package:math_solver/src/evaluator.dart';
import 'package:math_solver/src/infixToPostfix.dart';
import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  final tokenizer = DefaultTokenizer();
  final infixPostfix = DefaultInfixToPostfix();

  final tokenize = (str) => tokenizer.tokenize(str);
  final postfix = (ls) => infixPostfix.infixToPostfix(ls);

  final evaluator = DefaultEvaluator();

  final map = <List<Obj>, String>{
    postfix(tokenize('1+2')): '3',
    postfix(tokenize('2 ^ 2 / 2 - 2')): '0',
    postfix(tokenize('12 / (2 + 2 * 2)')): '2'
  };

  for (var entry in map.entries) {
    test(entry.key, () {
      expect(evaluator.evaluate(entry.key), entry.value);
    });
  }
}
