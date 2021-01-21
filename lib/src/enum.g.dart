// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Num _$NumFromJson(Map<String, dynamic> json) {
  return Num(
    (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$NumToJson(Num instance) => <String, dynamic>{
      'value': instance.value,
    };

BigNum _$BigNumFromJson(Map<String, dynamic> json) {
  return BigNum(
    json['value'] == null ? null : BigInt.parse(json['value'] as String),
  );
}

Map<String, dynamic> _$BigNumToJson(BigNum instance) => <String, dynamic>{
      'value': instance.value?.toString(),
    };

Op _$OpFromJson(Map<String, dynamic> json) {
  return Op(
    _$enumDecodeNullable(_$OperatorEnumMap, json['operator']),
  );
}

Map<String, dynamic> _$OpToJson(Op instance) => <String, dynamic>{
      'operator': _$OperatorEnumMap[instance.operator],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$OperatorEnumMap = {
  Operator.Add: 'Add',
  Operator.Substract: 'Substract',
  Operator.Multiply: 'Multiply',
  Operator.Divide: 'Divide',
  Operator.Exponent: 'Exponent',
};

Fun _$FunFromJson(Map<String, dynamic> json) {
  return Fun(
    _$enumDecodeNullable(_$FunctionEnumMap, json['function']),
  );
}

Map<String, dynamic> _$FunToJson(Fun instance) => <String, dynamic>{
      'function': _$FunctionEnumMap[instance.function],
    };

const _$FunctionEnumMap = {
  Function.SquareRoot: 'SquareRoot',
  Function.Sin: 'Sin',
  Function.Tan: 'Tan',
  Function.Cos: 'Cos',
};

ParL _$ParLFromJson(Map<String, dynamic> json) {
  return ParL();
}

Map<String, dynamic> _$ParLToJson(ParL instance) => <String, dynamic>{};

ParR _$ParRFromJson(Map<String, dynamic> json) {
  return ParR();
}

Map<String, dynamic> _$ParRToJson(ParR instance) => <String, dynamic>{};

Undefined _$UndefinedFromJson(Map<String, dynamic> json) {
  return Undefined(
    json['from'] as String,
  );
}

Map<String, dynamic> _$UndefinedToJson(Undefined instance) => <String, dynamic>{
      'from': instance.from,
    };
