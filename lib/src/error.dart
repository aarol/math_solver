import 'enum.dart';

class SolverException {
  final dynamic exception;
  final String debugInfo;
  const SolverException(this.exception, this.debugInfo);

  @override
  String toString() => 'SolverException: $exception \n $debugInfo';
}

class InvalidOperatorException implements Exception {
  const InvalidOperatorException(this.objs);
  final List<Obj> objs;
  @override
  String toString() => 'Invalid operator: $objs';
}

class MissingParenthesisException implements Exception {
  MissingParenthesisException(this.type);
  final Obj type;
  @override
  String toString() => 'Missing parenthesis: $type';
}

class OverflowException implements Exception {
  OverflowException(this.value);
  double value;
  @override
  String toString() => 'OverflowException: Result greater than 2^64 ($value)';
}
