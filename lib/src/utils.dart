import 'package:math_solver/src/enum.dart';
import 'dart:math' as math;

const double radians2Degrees = 180.0 / math.pi;

const double degrees2Radians = math.pi / 180.0;

Obj functionFromString(String input) {
  switch (input.toLowerCase()) {
    case 'sqrt':
      return Fun(Function.SquareRoot);
    case 'sin':
      return Fun(Function.Sin);
    case 'cos':
      return Fun(Function.Cos);
    case 'tan':
      return Fun(Function.Tan);
    default:
      return Undefined(input);
  }
}

Obj operatorFromString(String char) {
  switch (char) {
    case '(':
      return ParL();
    case ')':
      return ParR();
    case '-':
      return Op(Operator.Substract);
    case '+':
      return Op(Operator.Add);
    case '*':
      return Op(Operator.Multiply);
    case '/':
      return Op(Operator.Divide);
    case '^':
      return Op(Operator.Exponent);
    default:
      return Undefined(char);
  }
}
