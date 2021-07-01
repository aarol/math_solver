import 'package:rational/rational.dart';

// converts int or double to rational number
Rational r(num val) {
  if (num is int) {
    return Rational.fromInt(val as int);
  }
  return Rational.parse(val.toString());
}

Rational rs(String s) {
  return Rational.parse(s);
}
