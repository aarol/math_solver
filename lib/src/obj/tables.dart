import 'package:math_solver/src/obj.dart';

import 'package:rational/rational.dart';

import '../function.dart';
import '../operator.dart';

const kParseTable = <String, Obj>{
  '+': Op(Add()),
  '-': Op(Substract()),
  '*': Op(Multiply()),
  '/': Op(Divide()),
  '^': Op(Exponent()),
  '(': ParL(),
  ')': ParR(),
  'sin': Fun(Sin()),
  'cos': Fun(Cos()),
  'tan': Fun(Tan()),
  'sqrt': Fun(SquareRoot()),
};
