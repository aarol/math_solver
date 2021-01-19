import 'dart:collection';
import 'dart:math';

import 'enum.dart';
import 'error.dart';
import 'utils.dart';

/// Parses and solves an mathematical expression from a string
///
///Examples:
///
///     solve('-8*(-10)') // 80.0;
///     solve('100/12.5') // 8.0;
///     solve('(5*4-10)^2') // 100.0;
///     solve('60sin(sqrt(1350*6))') // 60.0;
///
/// Throws `SolverException` when has any error. `SolverException` contains the
/// original exception and a string with debug information. Useful for debugging.
///
///A map of <String, dynamic> is optional, it is used to replace certain characters.
///
///Examples:
///
///     solve('√36', {'√': 'sqrt'} ) // 'sqrt36'
///     solve('2×5÷5)', {'×': '*', '÷': '/'}) // '2*5/5'
///     solve('2×π)', {'×': '*', 'π': pi}) // '2*3.14159...'
///
double solve(String input, {Map<String, dynamic> valuesToRemap}) {
  var buffer = StringBuffer();
  try {
    var remapped = remapValues(input, valuesToRemap);
    buffer.writeln('remapped values: $remapped');
    var objs = convertString(remapped);
    buffer.writeln('converted to objs: $objs');
    var clean = cleanInput(objs);
    if (clean != objs) {
      buffer.writeln('cleaned: $clean');
    }
    var postfix = infixToPostfix(clean);
    buffer.writeln('in postfix: $postfix');
    var res = evaluate(postfix);
    buffer.write('result: $res');
    return res;
  } catch (e) {
    throw SolverException(e, 'Debug information: \n $buffer');
  }
}

String remapValues(String input, Map<String, dynamic> values) {
  if (values != null) {
    var inputList = input.split('');
    var hashMap = HashMap<String, dynamic>.from(values);
    for (var i = 0; i < input.length; i++) {
      //remove spaces
      if (inputList[i] == ' ') {
        inputList[i] == '';
      } else {
        var hashValue = hashMap[inputList[i]];
        if (hashValue != null) {
          inputList[i] = hashValue.toString();
        }
      }
    }
    return inputList.join('');
  } else {
    return input.replaceAll(' ', '');
  }
}

List<Obj> convertString(String input) {
  var res = ListQueue<Obj>(input.length ~/ 0.8);
  var stack = ListQueue<String>();

  final numReg = RegExp('[0-9.]');
  final alphaReg = RegExp('[a-z]');

  void clear() {
    if (stack.isEmpty) {
      return;
    }
    final parsedNum = double.tryParse(stack.join());
    Obj obj;
    if (parsedNum != null) {
      obj = Num(parsedNum);
    } else {
      obj = functionFromString(stack.join());
    }
    stack.clear();
    res.add(obj);
  }

  void addStack(String char) {
    if (stack.isNotEmpty) {
      final isNumeric = numReg.hasMatch(stack.first);
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
    if (numReg.hasMatch(char) || alphaReg.hasMatch(char)) {
      addStack(char);
    } else if (char == 'π') {
      clear();
      res.add(Num(pi));
    } else {
      clear();
      Obj obj;
      obj = operatorFromString(char);
      res.add(obj);
    }
  }
  clear();
  return res.toList();
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
      if (input[i - 1] is Num && input[i] == ParL()) {
        input.insert(i, Op(Operator.Multiply));
      }
      // 2π -> 2*π
      // should only happen with pi
      if (input[i - 1] is Num && input[i] == Num(pi)) {
        input.insert(i, Op(Operator.Multiply));
      }
      if (input[i - 1] == Num(pi) && input[i] is Num) {
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

///Shunting-yard algorithm
///
///https://en.wikipedia.org/wiki/Shunting-yard_algorithm
///
///turns infix ( 3*(2+1) ) to postfix ( 321+* )
///
ListQueue<Obj> infixToPostfix(List<Obj> input) {
  var output = ListQueue<Obj>(input.length);
  var operatorStack = ListQueue<Obj>();

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
      //add to when finished
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

double evaluate(ListQueue<Obj> input) {
  var resultStack = ListQueue<Obj>(input.length);
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
    if (res.value == double.infinity) {
      throw OverflowException(res.value);
    }
    return res.value;
  } else {
    throw Exception('Result is not a number');
  }
}

bool _shouldPop(Op operator, Obj last) {
  if (last == ParL()) {
    return false;
  }
  if (last is Op) {
    return operator.precedence < last.precedence ||
        (operator.precedence == last.precedence &&
            operator.assoc == Assoc.Left);
  }
  //functions always have precedence of 1
  if (last is Fun) {
    return operator.precedence < 1 ||
        (operator.precedence == 1 && operator.assoc == Assoc.Left);
  }
  throw InvalidOperatorException([operator, last]);
}
