import 'dart:math';

import 'enum.dart';
import 'error.dart';
part 'utils.dart';

double solve(String input) {
  var debugString = StringBuffer();
  try {
    var objs = convertString(input);
    debugString.write('converted to objs: $objs');
    var clean = cleanInput(objs);
    debugString.writeln('cleaned: $clean \n');
    var postfix = infixToPostfix(clean);
    debugString.writeln('in postfix: $postfix \n');
    var res = evaluate(postfix);
    debugString.writeln('result: $res \n');
    return res;
  } catch (e) {
    throw SolverException(e, 'Debug information: \n $debugString');
  }
}

List<Obj> convertString(String input) {
  var res = <Obj>[];
  var stack = <String>[];

  final numReg = RegExp('[0-9.]');

  void clear() {
    if (stack.isEmpty) {
      return;
    }
    final parsedNum = double.tryParse(stack.join());
    Obj obj;
    if (parsedNum != null) {
      obj = Num(parsedNum);
    } else {
      obj = _functionFromString(stack.join());
    }
    stack.clear();
    res.add(obj);
  }

  void addStack(String char) {
    if (stack.isNotEmpty) {
      final isNumeric = numReg.hasMatch(stack[0]);
      if (numReg.hasMatch(char)) {
        if (!isNumeric) {
          clear();
        }
      } else if (isNumeric) {
        clear();
      }
    }
    stack.add(char);
  }

  for (var char in input.split('')) {
    if (char == ' ') {
      clear();
      continue;
    }
    if (numReg.hasMatch(char) || 'sqrtinoatc'.contains(char)) {
      addStack(char);
    } else if (char == 'π') {
      clear();
      res.add(Num(pi));
    } else {
      clear();
      Obj obj;
      obj = _operatorFromString(char);
      res.add(obj);
    }
  }
  clear();
  return res;
}

List<Obj> cleanInput(List<Obj> input) {
  for (var i = 0; i < input.length; i++) {
    if (i == 0) {
      //Remove '-' at start of input and reverse value
      //- 2 + 5 -> -2 + 5
      if (input[0] == Op(Operator.Substract)) {
        var val = Num(-(input[1] as Num).value);
        input[1] = val;
        input.removeAt(0);
        //+ 2 + 5 -> 2 + 5
      } else if (input[0] == Op(Operator.Add)) {
        input.remove(0);
      }
    } else {
      //2( -> 2*(
      if (input[i - 1] is Num && input[i] is ParL) {
        input.insert(i, Op(Operator.Multiply));
      }
      // 2π -> 2*π
      // only happens with pi
      if (input[i - 1] is Num && input[i] == Num(pi)) {
        input.insert(i, Op(Operator.Multiply));
      }
      // 2sqrt(9) -> 2*sqrt(9)
      if (input[i - 1] is Num && input[i] is Fun) {
        input.insert(i, Op(Operator.Multiply));
      }
    }
  }
  return input;
}

List<Obj> infixToPostfix(List<Obj> input) {
  var output = <Obj>[];
  var operatorStack = <Obj>[];

  for (final token in input) {
    token.when(num: (_) {
      output.add(token);
    }, op: (val) {
      while (operatorStack.isNotEmpty) {
        final last = operatorStack.last;
        if (_shouldPop(val, last)) {
          output.add(operatorStack.removeLast());
        } else {
          break;
        }
      }
      operatorStack.add(token);
    }, fun: (_) {
      operatorStack.add(token);
    }, parL: () {
      operatorStack.add(token);
    }, parR: () {
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
        throw MissingParenthesisException(ParL());
      }
    }, undefined: () {
      throw Exception('Undefined object: $token');
    });
  }
  while (operatorStack.isNotEmpty) {
    var last = operatorStack.removeLast();
    if (last == ParL()) {
      throw MissingParenthesisException(ParR());
    }
    output.add(last);
  }
  return output;
}

double evaluate(List<Obj> input) {
  var resultStack = <Obj>[];
  for (final token in input) {
    token.when(num: (val) {
      resultStack.add(token);
    }, op: (op) {
      var a = resultStack.removeLast();
      var b = resultStack.removeLast();
      resultStack.add(Num(op.operation(a, b)));
    }, fun: (function) {
      var a = resultStack.removeLast();
      resultStack.add(Num(function.run(a)));
    }, undefined: () {
      throw Exception('No action found for $token');
    });
  }
  var res = resultStack.last;
  if (res is Num) {
    return res.value;
  } else {
    throw Exception('Evaluation failed');
  }
}

bool _shouldPop(Op operator, Obj last) {
  if (last == ParL()) {
    return false;
  }
  if (last is! Op) {
    throw InvalidOperatorException([operator, last]);
  }
  var last_op = last as Op;
  return operator.precedence < last_op.precedence ||
      (operator.precedence == last_op.precedence &&
          operator.assoc == Assoc.Left);
}
