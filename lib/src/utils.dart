import 'package:math_solver/src/enum.dart';
import 'dart:math' as math;

const double radians2Degrees = 180.0 / math.pi;

const double degrees2Radians = math.pi / 180.0;

bool shouldPop(Op operator, Obj last) {
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
  throw Exception('Cannot compare ${[operator, last]}');
}

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

double doubleOperation(Operator op, double a, double b) {
  switch (op) {
    case Operator.Add:
      // print('$b + $a');
      return b + a;
    case Operator.Substract:
      // print('$b - $a');
      return b - a;
    case Operator.Multiply:
      // print('$b * $a');
      return b * a;
    case Operator.Divide:
      // print('$b / $a');
      return b / a;
    case Operator.Exponent:
      // print('$b ^ $a');
      return math.pow(b, a);
    default:
      return 0;
  }
}

BigInt bigIntOperation(Operator op, BigInt a, BigInt b) {
  switch (op) {
    case Operator.Add:
      // print('$b + $a');
      return a + b;
    case Operator.Substract:
      // print('$b - $a');
      return b - a;
    case Operator.Multiply:
      // print('$b * $a');
      return b * a;
    case Operator.Divide:
      // print('$b / $a');
      return BigInt.from(b / a);
    case Operator.Exponent:
      // print('$b ^ $a');
      return b.pow(a.toInt());
    default:
      return BigInt.zero;
  }
}

extension When on Obj {
  R when<R extends Obj>({
    R Function(Num) num,
    R Function(BigNum) bigNum,
    R Function(Op) op,
    R Function(Fun) fun,
    R Function() parL,
    R Function() parR,
    R Function() undefined,
  }) {
    switch (type) {
      case ObjEnum.Num:
        return num(this as Num);
      case ObjEnum.BigNum:
        return bigNum(this as BigNum);
      case ObjEnum.Op:
        return op(this as Op);
      case ObjEnum.Fun:
        return fun(this as Fun);
      case ObjEnum.ParL:
        return parL();
      case ObjEnum.ParR:
        return parR();
      default:
        return undefined();
    }
  }
}
