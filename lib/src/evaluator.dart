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
    //TODO: higher than 64 bit calculations
    // if (res.isInfinite) {
    //   return evaluateInfinite(input);
    // }
    return formatDouble(res);
  }

  @visibleForTesting
  double evaluator(List<Obj> input) {
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

  @visibleForTesting
  String formatDouble(double input) {
    //check if input is decimal
    //then return early
    if (input.remainder(1) != 0.0) {
      //return with precision
      //accounts for floating point error
      // TODO: tune precision
      var withPrecision = input.toStringAsFixed(6);
      // remove all trailing zeroes
      while (withPrecision.endsWith('0')) {
        withPrecision = withPrecision.substring(0, withPrecision.length - 1);
      }
      return withPrecision;
    }
    // -0 --> 0
    if (-input == input) input = input.abs();
    // 1234567.0 ->  <String>[7,6,5,4,3,2,1]
    var list = input.toString().split('').reversed.toList()..removeRange(0, 2);
    final length = list.length;
    // count is added so the index moves as the list grows
    var count = 0;
    // --> [7, 6, 5,' ',4,3,2,' ',1]
    for (var i = 0; i < length; i++) {
      if (i != 0 && i % 3 == 0) {
        list.insert(i + count, ' ');
        count++;
      }
    }
    // --> '1 234 567'
    return list.reversed.join();
  }

  // String evaluateInfinite(List<Obj> input) {
  //   return 'AAAAA';
  // }
}
