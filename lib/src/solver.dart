import 'dart:collection';
import 'dart:math';
import 'dart:async';

import 'enum.dart';
import 'error.dart';
import 'eval.dart';
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
Future<String> solve(String input,
    {Map<String, dynamic>? valuesToRemap}) async {
  var buffer = StringBuffer();
  try {
    // √ 9 -> sqrt 9
    var remapped = remapValues(input, valuesToRemap);
    if (remapped != input) {
      buffer.writeln('remapped values: $remapped');
    }

    // String input to List of <Obj>
    var objs = convertString(remapped);
    buffer.writeln('converted to objs: $objs');

    // Performs checks on objs
    var clean = cleanInput(objs);
    if (clean != objs) {
      buffer.writeln('cleaned: $clean');
    }
    // Shunting-yard algorithm
    var postfix = infixToPostfix(clean);
    buffer.writeln('in postfix: $postfix');

    // dynamic because can be with double or BigInt
    var eval = await evaluate(postfix);
    buffer.writeln('evaluated: $eval');

    // Only for bigInt, adds scientific notation
    var res = simplify(eval);
    buffer.write('result: $res');
    return res;
  } catch (e) {
    throw SolverException(e, 'Debug information: \n $buffer');
  }
}

String remapValues(String input, Map<String, dynamic>? values) {
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
    token.when(number: (_) {
      output.add(token);
    }, op: (val) {
      while (operatorStack.isNotEmpty) {
        final last = operatorStack.last;
        if (shouldPop(val, last)) {
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
        throw MissingParenthesisException(isLeft: true);
      }
    }, undefined: () {
      throw UndefinedObjectException(token as Undefined);
    });
  }
  while (operatorStack.isNotEmpty) {
    final last = operatorStack.removeLast();
    // allows for easier usage by
    // not forcing to complete parenthesis so
    // '8(10-2' is an accepted input
    if (last != ParL()) {
      output.add(last);
    }
  }
  return output;
}
