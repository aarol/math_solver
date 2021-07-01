import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:rational/rational.dart';

import 'obj.dart';

abstract class Evaluator {
  /// takes in a postfix-orderer input
  /// returns a string representing a number: 0, 1e100 etc
  Rational evaluate(List<Obj> input);
}

class DefaultEvaluator implements Evaluator {
  const DefaultEvaluator();

  @override
  Rational evaluate(List<Obj> input) {
    var res = evaluator(input);
    //TODO: higher than 64 bit calculations
    // if (res.isInfinite) {
    //   return evaluateInfinite(input);
    // }
    return res;
  }

  @visibleForTesting
  Rational evaluator(List<Obj> input) {
    var resultStack = Queue<Obj>();
    for (var token in input) {
      token.when(
        number: (_) => resultStack.add(token),
        op: (op) {
          if (resultStack.length < 2) {
            throw Exception(
                'Not enough arguments for operation ${op.operator}');
          }
          var a = resultStack.removeLast() as Num;
          var b = resultStack.removeLast() as Num;
          resultStack.add(Num(op.use(a.value, b.value)));
        },
        fun: (fn) {
          if (resultStack.isEmpty) {
            throw Exception('Not enough arguments for function ${fn.function}');
          }
          var a = resultStack.removeLast() as Num;
          resultStack.add(Num(fn.use(a.value)));
        },
        undefined: () => throw token.toString(),
      );
    }
    var res = resultStack.last;
    if (res is Num) {
      return res.value;
    } else {
      throw Exception('Result is not a number');
    }
  }
}
