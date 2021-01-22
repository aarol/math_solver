import 'package:equatable/equatable.dart';
import 'dart:math';
import 'utils.dart';

import 'package:json_annotation/json_annotation.dart';

part 'enum.g.dart';

enum ObjEnum {
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
  const Obj(this.type);

  //Uses enum to match and cast in utils.dart extension
  final ObjEnum type;

  @override
  List<Object> get props => [type];

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class Num extends Obj {
  const Num(this.value) : super(ObjEnum.Num);
  final double value;
  @override
  bool get stringify => true;
  @override
  List<Object> get props => [value];

  @override
  Map<String, dynamic> toJson() =>
      _$NumToJson(this)..addEntries([MapEntry('type', ObjEnum.Num)]);

  @override
  factory Num.fromJson(json) => _$NumFromJson(json);
}

@JsonSerializable()
class BigNum extends Obj {
  const BigNum(this.value) : super(ObjEnum.BigNum);

  final BigInt value;
  @override
  bool get stringify => true;
  @override
  List<Object> get props => [value];

  static Obj fromJson(Map<String, dynamic> json) => _$BigNumFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$BigNumToJson(this)..addEntries([MapEntry('type', ObjEnum.BigNum)]);
}

@JsonSerializable()
class Op extends Obj {
  const Op(this.operator) : super(ObjEnum.Op);
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

  static Obj fromJson(Map<String, dynamic> json) => _$OpFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$OpToJson(this)..addEntries([MapEntry('type', ObjEnum.Op)]);

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [operator];
}

@JsonSerializable()
class Fun extends Obj {
  const Fun(this.function) : super(ObjEnum.Fun);
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

  static Obj fromJson(Map<String, dynamic> json) => _$FunFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$FunToJson(this)..addEntries([MapEntry('type', ObjEnum.Fun)]);

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [function];
}

@JsonSerializable()
class ParL extends Obj {
  const ParL() : super(ObjEnum.ParL);

  @override
  String toString() => 'Par(';

  static Obj fromJson(Map<String, dynamic> json) => _$ParLFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ParLToJson(this)..addEntries([MapEntry('type', ObjEnum.ParL)]);
}

@JsonSerializable()
class ParR extends Obj {
  const ParR() : super(ObjEnum.ParR);
  @override
  String toString() => 'Par)';

  static Obj fromJson(Map<String, dynamic> json) => _$ParRFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ParRToJson(this)..addEntries([MapEntry('type', ObjEnum.ParR)]);
}

@JsonSerializable()
class Undefined extends Obj {
  const Undefined(this.from) : super(ObjEnum.Undefined);
  final String from;
  @override
  String toString() => 'Undefined($from)';

  static Obj fromJson(Map<String, dynamic> json) => _$UndefinedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UndefinedToJson(this)
    ..addEntries([MapEntry('type', ObjEnum.Undefined)]);
}
