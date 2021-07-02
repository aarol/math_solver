import 'package:math_solver/math_solver.dart';
import 'dart:math' as math;

import 'package:math_solver/src/util.dart';

abstract class Functions {
  const Functions();

  static SquareRoot get squareRoot => const SquareRoot();
  static Sin get sin => const Sin();
  static Cos get cos => const Cos();
  static Tan get tan => const Tan();

  Rational call(Rational a);
}

class SquareRoot extends Functions {
  const SquareRoot();

  @override
  Rational call(Rational a) {
    var sqrt = math.sqrt(a.toDouble());
    return Rational.parse(sqrt.toString());
  }
}

class Sin extends Functions {
  const Sin();

  @override
  Rational call(Rational a) {
    var sin = math.sin(a.toDouble() * degrees2Radians);
    return Rational.parse(sin.toString());
  }
}

class Cos extends Functions {
  const Cos();

  @override
  Rational call(Rational a) {
    var cos = math.cos(a.toDouble() * degrees2Radians);
    return Rational.parse(cos.toString());
  }
}

class Tan extends Functions {
  const Tan();

  @override
  Rational call(Rational a) {
    var tan = math.tan(a.toDouble() * degrees2Radians);
    return Rational.parse(tan.toString());
  }
}
