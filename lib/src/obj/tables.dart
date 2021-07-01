import 'package:math_solver/src/obj.dart';
import 'dart:math' as math;

const kFunctionTable = <String, Fun>{
  'sin': Fun(Function.Sin),
  'cos': Fun(Function.Cos),
  'tan': Fun(Function.Tan),
  'sqrt': Fun(Function.SquareRoot),
};

final kOperationTable = <Operator, double Function(double a, double b)>{
  Operator.Add: (a, b) => b + a,
  Operator.Substract: (a, b) => b - a,
  Operator.Multiply: (a, b) => b * a,
  Operator.Exponent: (a, b) => math.pow(b, a) as double,
  Operator.Divide: (a, b) {
    if (a == 0) {
      throw IntegerDivisionByZeroException();
    }
    return b / a;
  }
};

const kObjParseTable = <String, Obj>{
  '+': Op(Operator.Add),
  '-': Op(Operator.Substract),
  '*': Op(Operator.Multiply),
  '/': Op(Operator.Divide),
  '^': Op(Operator.Exponent),
  '(': ParL(),
  ')': ParR(),
};

const kOperatorPrecedenceTable = <Operator, int>{
  Operator.Add: 2,
  Operator.Substract: 2,
  Operator.Multiply: 3,
  Operator.Divide: 3,
  Operator.Exponent: 4,
};
