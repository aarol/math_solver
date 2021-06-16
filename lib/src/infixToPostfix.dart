import 'dart:collection';

import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/util.dart';

abstract class InfixToPostfix {
  List<Obj> infixToPostfix(List<Obj> input);
}

class DefaultInfixToPostfix implements InfixToPostfix {
  const DefaultInfixToPostfix();
  @override
  List<Obj> infixToPostfix(List<Obj> input) {
    var output = Queue<Obj>();
    var operatorStack = Queue<Obj>();

    for (var token in input) {
      token.when(
        number: (_) => output.add(token),
        fun: (_) => operatorStack.add(token),
        parL: () => operatorStack.add(token),
        op: (op) {
          while (operatorStack.isNotEmpty) {
            var last = operatorStack.last;
            // pop every obj in stack which is higher or equal precedence
            if (shouldPop(op, last)) {
              output.add(operatorStack.removeLast());
            } else {
              break;
            }
          }
          operatorStack.add(token);
        },
        parR: () {
          var found = false;
          while (operatorStack.isNotEmpty) {
            if (operatorStack.last != ParL()) {
              output.add(operatorStack.removeLast());
            } else {
              operatorStack.removeLast();
              found = true;
              break;
            }
          }
          if (!found) {
            throw Exception('missing parenthesis (');
          }
        },
        undefined: () => throw Exception('undefined token $token'),
      );
    }
    while (operatorStack.isNotEmpty) {
      final last = operatorStack.removeLast();
      // does not force completion of parenthesis so
      // '8(10-2' is an acceptable input
      if (last != ParL()) {
        output.add(last);
      }
    }
    return output.toList();
  }
}
