import 'dart:collection';

import 'package:meta/meta.dart';

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
    var res = evaluator(input);
    return format(res);
  }

  @visibleForTesting
  String evaluator(List<Obj> input) {
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
      return res.value.toString();
    } else {
      throw Exception('Result is not a number');
    }
  }

  @visibleForTesting
  String format(String input) {
    var value = double.tryParse(input);
    if (value == null) return '';
    if (value.remainder(1) != 0.0) {
      //value is decimal
      //skip everything
      return value.toString();
    }
    // 1234567 ->  <String>[7,6,5,4,3,2,1]
    var list = value.toInt().toString().split('').reversed.toList();
    final length = list.length;
    // count is added so the index moves as the list grows
    var count = 0;
    // --> [7, 6, 5,'',4,3,2,'',1]
    for (var i = 0; i < length; i++) {
      if (i != 0 && i % 3 == 0) {
        list.insert(i + count, ' ');
        count++;
      }
    }
    return list.reversed.join();
  }
}
