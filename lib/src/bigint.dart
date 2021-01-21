import 'dart:collection';

import 'enum.dart';
import 'error.dart';

BigInt solvewithBigInt(ListQueue<Obj> input) {
  var resultStack = ListQueue<Obj>(input.length);
  for (final token in input) {
    token.when(num: (val) {
      resultStack.add(convertToBig(token));
    }, op: (op) {
      if (resultStack.length < 2) {
        throw Exception('Not enough arguments for operation ${op.operator}');
      }
      var a = resultStack.removeLast();
      var b = resultStack.removeLast();
      resultStack.add(Num(op.operation(a, b)));
    }, fun: (function) {
      if (resultStack.isEmpty) {
        throw Exception(
            'Not enough arguments for function ${function.function}');
      }
      var a = resultStack.removeLast();
      resultStack.add(Num(function.run(a)));
    }, undefined: () {
      throw UndefinedObjectException(token);
    });
  }
  var res = resultStack.last;
  if (res is Num) {
    if (res.value == double.infinity) {
      throw OverflowException(res.value);
    }
    return res.value;
  } else {
    throw Exception('Result is not a number');
  }
}

BigNum convertToBig(Num num) {
  return BigNum(BigInt.from(num.value));
}
