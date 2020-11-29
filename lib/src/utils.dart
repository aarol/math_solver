part of math_solver;

extension StringExt on String {
  bool get isNum {
    return double.tryParse(this) is double;
  }

  double parseDouble() {
    return double.tryParse(this);
  }

  bool get isOperator {
    return Token.operators.contains(Token(this));
  }

  bool get isFunc {
    return Token.functions.contains(Token(this));
  }
}
