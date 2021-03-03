import 'enum.dart';

class SolverException {
  final dynamic exception;
  final String debugInfo;
  const SolverException(this.exception, this.debugInfo);

  @override
  String toString() => 'SolverException: $exception \n $debugInfo';
}

class UndefinedObjectException implements Exception {
  const UndefinedObjectException(this.obj);
  final Undefined obj;
  @override
  String toString() => 'Invalid operator: ${obj.from}';
}

class MissingParenthesisException implements Exception {
  const MissingParenthesisException({this.isLeft});
  final bool? isLeft;
  @override
  String toString() => 'Missing parenthesis: ${isLeft! ? 'left' : 'right'}';
}

class TimeoutException implements Exception {
  const TimeoutException();
  @override
  String toString() => 'Calculation took too long to complete';
}

class DivideByZeroException implements Exception {
  const DivideByZeroException();
  @override
  String toString() => 'Cannot divide by zero';
}
