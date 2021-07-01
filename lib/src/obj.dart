import 'package:equatable/equatable.dart';
import 'package:math_solver/src/obj/tables.dart';
import 'dart:math' as math;

import 'util.dart';

enum _Obj {
  num,
  op,
  fun,
  parL,
  parR,
  undefined,
}

enum Operator { add, substract, multiply, divide, exponent }

enum Function { squareRoot, sin, tan, cos }

enum Assoc { left, right }

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
      case _Obj.num:
        return number!(this as Num);
      case _Obj.op:
        return op!(this as Op);
      case _Obj.fun:
        return fun!(this as Fun);
      case _Obj.parL:
        return parL!();
      case _Obj.parR:
        return parR!();
      default:
        return undefined!();
    }
  }

  @override
  List<Object> get props => [_type];
}

class Num extends Obj {
  const Num(this.value) : super(_Obj.num);
  final double value;

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [value];
}

class Op extends Obj {
  const Op(this.operator) : super(_Obj.op);
  final Operator operator;

  int get precedence => kOperatorPrecedenceTable[operator] ?? -1;

  Assoc get assoc => operator == Operator.exponent ? Assoc.right : Assoc.left;

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
  const Fun(this.function) : super(_Obj.fun);
  final Function function;

  static Obj from(String char) {
    return kFunctionTable[char] ?? Undefined(char);
  }

  double use(double a) {
    switch (function) {
      case Function.squareRoot:
        return math.sqrt(a);
      case Function.sin:
        return math.sin(a * degrees2Radians);
      case Function.cos:
        return math.cos(a * degrees2Radians);
      case Function.tan:
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
  const ParL() : super(_Obj.parL);

  @override
  String toString() => 'Par(';
}

class ParR extends Obj {
  const ParR() : super(_Obj.parR);
  @override
  String toString() => 'Par)';
}

class Undefined extends Obj {
  const Undefined(this.from) : super(_Obj.undefined);
  final String from;
  @override
  String toString() => 'Undefined($from)';
}
