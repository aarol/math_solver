import 'package:equatable/equatable.dart';
import 'package:math_solver/src/obj/tables.dart';
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

  int get precedence => kOperatorPrecedenceTable[operator] ?? -1;

  Assoc get assoc => operator == Operator.Exponent ? Assoc.Right : Assoc.Left;

  static Obj from(String char) {
    return kObjParseTable[char] ?? Undefined(char);
  }

  double use(double a, double b) {
    var fun = kOperationTable[operator]?.call(a, b);
    if (fun != null) {
      return fun;
    } else {
      throw Exception('No operation found for $operator');
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
    return kFunctionTable[char] ?? Undefined(char);
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
