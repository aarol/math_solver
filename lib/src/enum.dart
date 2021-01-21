import 'package:equatable/equatable.dart';
import 'dart:math';
import 'utils.dart';

import 'package:json_annotation/json_annotation.dart';

part 'enum.g.dart';

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

  //Uses private enum to match and cast
  final _Obj _type;

  R when<R extends Obj>({
    R Function(Num) num,
    R Function(BigNum) bigNum,
    R Function(Op) op,
    R Function(Fun) fun,
    R Function() parL,
    R Function() parR,
    R Function() undefined,
  }) {
    switch (_type) {
      case _Obj.Num:
        return num(this as Num);
      case _Obj.BigNum:
        return bigNum(this as BigNum);
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
  List<Object> get props => [_type];

  Map<String, dynamic> toJson();

  Obj.fromJson(Map<String, dynamic> json, this._type);
}

@JsonSerializable()
class Num extends Obj {
  const Num(this.value) : super(_Obj.Num);
  final double value;
  @override
  bool get stringify => true;
  @override
  List<Object> get props => [value];

  @override
  Map<String, dynamic> toJson() => _$NumToJson(this);

  @override
  factory Num.fromJson(json) => _$NumFromJson(json);
}

@JsonSerializable()
class BigNum extends Obj {
  const BigNum(this.value) : super(_Obj.BigNum);
  final BigInt value;
  @override
  bool get stringify => true;
  @override
  List<Object> get props => [value];

  @override
  Obj fromJson(Map<String, dynamic> json) => _$BigNumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BigNumToJson(this);
}

@JsonSerializable()
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
  Obj fromJson(Map<String, dynamic> json) => _$OpFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpToJson(this);

  @override
  String toString() => 'Op($operator)';
  @override
  List<Object> get props => [operator];
}

@JsonSerializable()
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
  Obj fromJson(Map<String, dynamic> json) => _$FunFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FunToJson(this);

  @override
  String toString() => 'Fun($function)';
  @override
  List<Object> get props => [function];
}

@JsonSerializable()
class ParL extends Obj {
  const ParL() : super(_Obj.ParL);
  @override
  String toString() => 'Par(';

  @override
  Obj fromJson(Map<String, dynamic> json) => _$ParLFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ParLToJson(this);
}

@JsonSerializable()
class ParR extends Obj {
  const ParR() : super(_Obj.ParR);
  @override
  String toString() => 'Par)';

  @override
  Obj fromJson(Map<String, dynamic> json) => _$ParRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ParRToJson(this);
}

@JsonSerializable()
class Undefined extends Obj {
  const Undefined(this.from) : super(_Obj.Undefined);
  final String from;
  @override
  String toString() => 'Undefined($from)';

  @override
  Obj fromJson(Map<String, dynamic> json) => _$UndefinedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UndefinedToJson(this);
}
