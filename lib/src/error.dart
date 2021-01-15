import 'enum.dart';

class SolverException {
  final dynamic e;
  final String debugInfo;
  const SolverException(this.e, this.debugInfo);

  @override
  String toString() => 'SolverException: $e \n $debugInfo';
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
  const OverflowException();
  @override
  String toString() => 'OverflowException: Result greater than 2^64-1';
}
