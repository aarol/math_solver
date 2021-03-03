import 'package:equatable/equatable.dart';
import 'dart:math';
import 'utils.dart';

enum _Obj {
  Num,
  BigNum,
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

  //Uses private enum to match and cas
  final _Obj _type;

  void when<R extends Obj>({
    Function(Num)? number,
    Function(BigNum)? bigNum,
    Function(Op)? op,
    Function(Fun)? fun,
    Function()? parL,
    Function()? parR,
    Function()? undefined,
  }) {
    switch (_type) {
      case _Obj.Num:
        return number!(this as Num);
      case _Obj.BigNum:
        return bigNum!(this as BigNum);
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

class BigNum extends Obj {
  const BigNum(this.value) : super(_Obj.BigNum);

  final BigInt value;
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

  dynamic operation(Obj first, Obj second) {
    if (first is Num && second is Num) {
      return doubleOperation(operator, first.value, second.value);
    }
    if (first is BigNum && second is BigNum) {
      return bigIntOperation(operator, first.value, second.value);
    }
    throw Exception('$first or $second is not a valid number');
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [operator];
}

class Fun extends Obj {
  const Fun(this.function) : super(_Obj.Fun);
  final Function function;
  dynamic run(Obj first) {
    if (first is Num) {
      var a = first.value;
      switch (function) {
        case Function.SquareRoot:
          return sqrt(a);
        case Function.Sin:
          return sin(a * degrees2Radians);
        case Function.Cos:
          return cos(a * degrees2Radians);
        case Function.Tan:
          return tan(a * degrees2Radians);
        default:
          return 0;
      }
    }
    if (first is BigNum) {
      var a = first.value.toDouble();
      switch (function) {
        case Function.SquareRoot:
          return BigInt.from(sqrt(a));
        case Function.Sin:
          return BigInt.from(sin(a * degrees2Radians));
        case Function.Cos:
          return BigInt.from(cos(a * degrees2Radians));
        case Function.Tan:
          return BigInt.from(tan(a * degrees2Radians));
        default:
          return 0;
      }
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
