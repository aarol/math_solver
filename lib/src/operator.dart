// enum Operator { add, substract, multiply, divide, exponent }

import 'package:rational/rational.dart';

abstract class Operators {
  const Operators();
  static Add get add => const Add();
  static Substract get substract => const Substract();
  static Multiply get multiply => const Multiply();
  static Divide get divide => const Divide();
  static Exponent get exponent => const Exponent();

  int get precedence;

  Rational call(Rational a, Rational b);
}

class Add extends Operators {
  const Add();

  @override
  Rational call(Rational a, Rational b) => b + a;

  @override
  int get precedence => 2;
}

class Substract extends Operators {
  const Substract();

  @override
  Rational call(Rational a, Rational b) => b - a;

  @override
  int get precedence => 2;
}

class Multiply extends Operators {
  const Multiply();
  @override
  Rational call(Rational a, Rational b) => b * a;

  @override
  int get precedence => 3;
}

class Divide extends Operators {
  const Divide();
  @override
  Rational call(Rational a, Rational b) {
    if (a == Rational.zero) {
      throw IntegerDivisionByZeroException();
    }
    return b / a;
  }

  @override
  int get precedence => 3;
}

class Exponent extends Operators {
  const Exponent();
  @override
  Rational call(Rational a, Rational b) => b.pow(a.toInt());

  @override
  int get precedence => 4;
}
