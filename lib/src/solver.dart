import 'infixToPostfix.dart';
import 'tokenizer.dart';

import 'evaluator.dart';

/// Solves mathematical expressions
///
/// Has efficient default implementations
/// which can also be implemented by the developer.

class Solver {
  const Solver({
    this.tokenizer = const DefaultTokenizer(),
    this.infixToPostfix = const DefaultInfixToPostfix(),
    this.evaluator = const DefaultEvaluator(),
  });

  final Tokenizer tokenizer;
  final InfixToPostfix infixToPostfix;
  final Evaluator evaluator;

  String solve(String input) {
    final objects = tokenizer.tokenize(input);
    final postfix = infixToPostfix.infixToPostfix(objects);
    final eval = evaluator.evaluate(postfix);
    return eval;
  }
}

const _solver = Solver();

String solve(String input) => _solver.solve(input);
