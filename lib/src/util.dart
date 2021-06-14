import 'obj.dart';
import 'dart:math' as math;

const double radians2Degrees = 180.0 / math.pi;

const double degrees2Radians = math.pi / 180.0;

extension IsBool on String {
  bool get isNumeric {
    return '012345679.'.contains(this);
  }

  bool get isFunctional {
    return 'sincoqrat'.contains(this);
  }
}

/// returns if there is an operator [last] other than the left parenthesis at the top of the operator stack,
/// and either [current] is left-associative and its precedence is less or equal to that of [last],
/// or [last] is right-associative and its precedence is less than [current]
bool shouldPop(Op current, Obj last) {
  if (last == ParL()) {
    return false;
  }
  if (last is Op) {
    return current.precedence < last.precedence ||
        (current.precedence == last.precedence && current.assoc == Assoc.Left);
  }
  //functions always have precedence of 1
  if (last is Fun) {
    return current.precedence < 1 ||
        (current.precedence == 1 && current.assoc == Assoc.Left);
  }
  throw Exception('Cannot compare ${[current, last]}');
}
