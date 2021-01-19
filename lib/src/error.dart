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
  MissingParenthesisException({this.isLeft});
  final bool isLeft;
  @override
  String toString() => 'Missing parenthesis: ${isLeft ? 'left' : 'right'}';
}

class OverflowException implements Exception {
  OverflowException(this.value);
  double value;
  @override
  String toString() =>
      'OverflowException: Result greater than 2^64 (double.infinity)';
}
