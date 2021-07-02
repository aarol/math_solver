import 'package:math_solver/src/obj.dart';
import 'dart:math' as math;

import 'package:rational/rational.dart';

import '../util.dart';

const kParseTable = <String, Obj>{
  '+': Op(Operator.add),
  '-': Op(Operator.substract),
  '*': Op(Operator.multiply),
  '/': Op(Operator.divide),
  '^': Op(Operator.exponent),
  '(': ParL(),
  ')': ParR(),
  'sin': Fun(Function.sin),
  'cos': Fun(Function.cos),
  'tan': Fun(Function.tan),
  'sqrt': Fun(Function.squareRoot),
};

final kOperationTable = <Operator, Rational Function(Rational a, Rational b)>{
  Operator.add: (a, b) => b + a,
  Operator.substract: (a, b) => b - a,
  Operator.multiply: (a, b) => b * a,
  Operator.exponent: (a, b) => b.pow(a.toInt()),
  Operator.divide: (a, b) {
    if (a == Rational.zero) {
      throw IntegerDivisionByZeroException();
    }
    return b / a;
  }
};

final kFunctionTable = <Function, Rational Function(Rational)>{
  // From extension methods in util.dart
  Function.squareRoot: (a) => a.squareRoot(),
  Function.sin: (a) => a.sin(),
  Function.cos: (a) => a.cos(),
  Function.tan: (a) => a.tan(),
};

const kOperatorPrecedenceTable = <Operator, int>{
  Operator.add: 2,
  Operator.substract: 2,
  Operator.multiply: 3,
  Operator.divide: 3,
  Operator.exponent: 4,
};
