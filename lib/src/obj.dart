import 'package:equatable/equatable.dart';
import 'dart:math' as math;

import 'util.dart';

enum _Obj {
  Num,
  Op,
  Fun,
  ParL,
  ParR,
  Undefined,
}

enum Operator { Add, Substract, Multiply, Divide, Exponent }

enum Function { SquareRoot, Sin, Tan, Cos }

enum Assoc { Left, Right }

abstract class Obj extends Equatable {
  const Obj(this._type);

  //Uses private enum to match
  final _Obj _type;

  void when<R extends Obj>({
    void Function(Num)? number,
    void Function(Op)? op,
    void Function(Fun)? fun,
    void Function()? parL,
    void Function()? parR,
    void Function()? undefined,
  }) {
    switch (_type) {
      case _Obj.Num:
        return number!(this as Num);
      case _Obj.Op:
        return op!(this as Op);
      case _Obj.Fun:
        return fun!(this as Fun);
      case _Obj.ParL:
        return parL!();
      case _Obj.ParR:
        return parR!();
      default:
        return undefined!();
    }
  }

  @override
  List<Object> get props => [_type];
}

class Num extends Obj {
  const Num(this.value) : super(_Obj.Num);
  final double value;

  @override
  bool get stringify => true;
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

  static Obj from(String char) {
    switch (char) {
      case '+':
        return Op(Operator.Add);
      case '-':
        return Op(Operator.Substract);
      case '*':
        return Op(Operator.Multiply);
      case '/':
        return Op(Operator.Divide);
      case '^':
        return Op(Operator.Exponent);
      case '(':
        return ParL();
      case ')':
        return ParR();
      default:
        return Undefined(char);
    }
  }

  double operation(double a, double b) {
    switch (operator) {
      case Operator.Add:
        return b + a;
      case Operator.Substract:
        return b - a;
      case Operator.Multiply:
        return b * a;
      case Operator.Divide:
        if (a == 0) throw Exception('Division by zero');
        return b / a;
      case Operator.Exponent:
        return math.pow(b, a) as double;
      default:
        return 0;
    }
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [operator];
}

class Fun extends Obj {
  const Fun(this.function) : super(_Obj.Fun);
  final Function function;

  static Obj from(String char) {
    switch (char) {
      case 'sin':
        return Fun(Function.Sin);
      case 'cos':
        return Fun(Function.Cos);
      case 'tan':
        return Fun(Function.Tan);
      case 'sqrt':
        return Fun(Function.SquareRoot);
      default:
        return Undefined(char);
    }
  }

  double use(double a) {
    switch (function) {
      case Function.SquareRoot:
        return math.sqrt(a);
      case Function.Sin:
        return math.sin(a * degrees2Radians);
      case Function.Cos:
        return math.cos(a * degrees2Radians);
      case Function.Tan:
        return math.tan(a * degrees2Radians);
      default:
        return 0;
    }
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [function];
}

class ParL extends Obj {
  const ParL() : super(_Obj.ParL);

  @override
  String toString() => 'Par(';
}

class ParR extends Obj {
  const ParR() : super(_Obj.ParR);
  @override
  String toString() => 'Par)';
}

class Undefined extends Obj {
  const Undefined(this.from) : super(_Obj.Undefined);
  final String from;
  @override
  String toString() => 'Undefined($from)';
}
