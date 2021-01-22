import 'dart:collection';

import 'enum.dart';
import 'error.dart';
import 'utils.dart';

Future<BigInt> solvewithBigInt(ListQueue<Obj> input) async {
  var resultStack = ListQueue<Obj>(input.length);
  for (final token in input) {
    token.when(num: (val) {
      resultStack.add(convertToBig(token));
    }, bigNum: (val) {
      resultStack.add(token);
    }, op: (op) {
      if (resultStack.length < 2) {
        throw Exception('Not enough arguments for operation ${op.operator}');
      }
      var a = resultStack.removeLast();
      var b = resultStack.removeLast();
      //op.operation accepts bigint or double
      resultStack.add(BigNum(op.operation(a, b)));
    }, fun: (function) {
      if (resultStack.isEmpty) {
        throw Exception(
            'Not enough arguments for function ${function.function}');
      }
      var a = resultStack.removeLast();
      resultStack.add(BigNum(function.run(a)));
    }, undefined: () {
      throw UndefinedObjectException(token);
    });
  }
  var res = resultStack.last;
  if (res is BigNum) {
    return res.value;
  } else {
    throw Exception('Result is not a number');
  }
}

BigNum convertToBig(Num num) {
  return BigNum(BigInt.from(num.value));
}
