import 'package:equatable/equatable.dart';
import 'package:math_solver/src/error.dart';
import 'dart:math';

enum _Obj {
  Num,
  Op,
  Fun,
  ParL,
  ParR,
  Undefined,
}
enum Operator { Add, Substract, Multiply, Divide, Exponent }

enum Function {
  SquareRoot,
  Sin,
  Tan,
  Cos,
}

enum Assoc {
  Left,
  Right,
}

abstract class Obj extends Equatable {
  const Obj(this._type);

  final _Obj _type;

  R when<R extends Object>({
    R Function(Num) num,
    R Function(Op) op,
    R Function(Fun) fun,
    R Function() parL,
    R Function() parR,
    R Function() undefined,
  }) {
    switch (_type) {
      case _Obj.Num:
        return num(this as Num);
      case _Obj.Op:
        return op(this as Op);
      case _Obj.Fun:
        return fun(this as Fun);
      case _Obj.ParL:
        return parL();
      case _Obj.ParR:
        return parR();
      default:
        return undefined();
    }
  }

  @override
  List<Object> get props => [];
}

class Num extends Obj {
  const Num(this.value) : super(_Obj.Num);
  final double value;
  @override
  String toString() => 'Num($value)';
  @override
  List<Object> get props => [value];
}

class Op extends Obj {
  const Op(this.operator) : super(_Obj.Op);
  final Operator operator;
  int get precedence {
    switch (operator) {
      case Operator.Add:
        return 2;
      case Operator.Substract:
        return 2;
      case Operator.Multiply:
        return 3;
      case Operator.Divide:
        return 3;
      case Operator.Exponent:
        return 4;
      default:
        return -1;
    }
  }

  Assoc get assoc {
    switch (operator) {
      case Operator.Exponent:
        return Assoc.Right;
      default:
        return Assoc.Left;
    }
  }

  double operation(Obj first, Obj second) {
    if (first is Num && second is Num) {
      var a = first.value;
      var b = second.value;
      switch (operator) {
        case Operator.Add:
          print('$b + $a');
          return b + a;
        case Operator.Substract:
          print('$b - $a');
          return b - a;
        case Operator.Multiply:
          print('$b * $a');
          return b * a;
        case Operator.Divide:
          print('$b / $a');
          return b / a;
        case Operator.Exponent:
          print('$b ^ $a');
          return pow(b, a);
        default:
      }
    }
  }

  @override
  String toString() => 'Op($operator)';
  @override
  List<Object> get props => [operator];
}

class Fun extends Obj {
  const Fun(this.function) : super(_Obj.Fun);
  final Function function;
  double run(a) {
    switch (function) {
      case Function.SquareRoot:
        print('sqrt($a)');
        return sqrt(a);
      case Function.Sin:
        print('sin($a)');
        return sin(a);
      case Function.Cos:
        print('cos($a)');
        return cos(a);
      case Function.Tan:
        print('tan($a)');
        return tan(a);
    }
    return 0;
  }

  @override
  String toString() => 'Fun($function)';
  @override
  List<Object> get props => [function];
}

class ParL extends Obj {
  const ParL() : super(_Obj.ParL);
  @override
  String toString() => '(';
}

class ParR extends Obj {
  const ParR() : super(_Obj.ParR);
  @override
  String toString() => ')';
}

class Undefined extends Obj {
  const Undefined() : super(_Obj.Undefined);
  @override
  String toString() => 'Undefined()';
}