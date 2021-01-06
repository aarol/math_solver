import 'enum.dart';
import 'error.dart';

double solve(String input) {
  print('input: $input');
  var objs = convertString(input);
  print('objs: $objs');
  var postfix = infixToPostfix(objs);
  print('objs: $postfix');
  var res = evaluate(postfix);
  print('res: $res');
  return res;
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
      switch (stack.join()) {
        case 'sqrt':
          obj = Fun(Function.SquareRoot);
          break;
        case 'sin':
          obj = Fun(Function.Sin);
          break;
        case 'cos':
          obj = Fun(Function.Cos);
          break;
        case 'tan':
          obj = Fun(Function.Tan);
          break;
        default:
          obj = Undefined();
      }
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
    if (numReg.hasMatch(char) || 'sqrtinatc'.contains(char)) {
      addStack(char);
    } else {
      clear();
      Obj obj;
      switch (char) {
        case '(':
          obj = ParL();
          break;
        case ')':
          obj = ParR();
          break;
        case '-':
          obj = Op(Operator.Substract);
          break;
        case '+':
          obj = Op(Operator.Add);
          break;
        case '*':
          obj = Op(Operator.Multiply);
          break;
        case '/':
          obj = Op(Operator.Divide);
          break;
        case '^':
          obj = Op(Operator.Exponent);
          break;
        default:
          obj = Undefined();
      }
      res.add(obj);
    }
  }
  clear();
  return res;
}

List<Obj> infixToPostfix(List<Obj> input) {
  List<Obj> output = [];
  List<Obj> operatorStack = [];

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
      var found = false;
      while (operatorStack.isNotEmpty) {
        if (operatorStack.last != ParL) {
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
      print('undefined object');
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
  List<Obj> resultStack = [];
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

bool _shouldPop(Op op, Obj last) {
  if (last == ParL()) {
    return false;
  }
  last.when(op: (last) {
    return op.precedence < last.precedence ||
        (op.precedence == last.precedence && op.assoc == Assoc.Left);
  });
  throw InvalidOperatorException([op, last]);
}
