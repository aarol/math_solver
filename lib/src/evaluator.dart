import 'dart:collection';

import 'obj.dart';

abstract class Evaluator {
  /// takes in a postfix-orderer input
  /// returns a string representing a number: 0, 1e100 etc
  String evaluate(List<Obj> input);
}

class DefaultEvaluator implements Evaluator {
  const DefaultEvaluator();

  @override
  String evaluate(List<Obj> input) {
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
          resultStack.add(Num(op.operation(a.value, b.value)));
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
      return res.value.toInt().toString();
    } else {
      throw Exception('Result is not a number');
    }
  }
}
