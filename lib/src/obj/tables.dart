import 'package:math_solver/src/obj.dart';
import 'dart:math' as math;

const kFunctionTable = <String, Fun>{
  'sin': Fun(Function.sin),
  'cos': Fun(Function.cos),
  'tan': Fun(Function.tan),
  'sqrt': Fun(Function.squareRoot),
};

final kOperationTable = <Operator, double Function(double a, double b)>{
  Operator.add: (a, b) => b + a,
  Operator.substract: (a, b) => b - a,
  Operator.multiply: (a, b) => b * a,
  Operator.exponent: (a, b) => math.pow(b, a) as double,
  Operator.divide: (a, b) {
    if (a == 0) {
      throw IntegerDivisionByZeroException();
    }
    return b / a;
  }
};

const kObjParseTable = <String, Obj>{
  '+': Op(Operator.add),
  '-': Op(Operator.substract),
  '*': Op(Operator.multiply),
  '/': Op(Operator.divide),
  '^': Op(Operator.exponent),
  '(': ParL(),
  ')': ParR(),
};

const kOperatorPrecedenceTable = <Operator, int>{
  Operator.add: 2,
  Operator.substract: 2,
  Operator.multiply: 3,
  Operator.divide: 3,
  Operator.exponent: 4,
};
