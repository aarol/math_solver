part of math_solver;

class Token extends Equatable {
  const Token(this.value, {this.precedence, this.associativity});
  final String value;
  final int precedence;
  final String associativity;

  //Equatable override for equality
  //Allows comparing Tokens by only the value string.
  @override
  List<Object> get props => [value];

  static bool containsOperator(String string) {
    return operators.contains(Token(string));
  }

  static Token findOperator(String string) {
    return operators.singleWhere((e) => e == Token(string));
  }

  static Token findFunction(String string) {
    return functions.singleWhere((e) => e == Token(string));
  }

  static const List<Token> operators = [
    Token('^', precedence: 4, associativity: assocRight),
    Token('/', precedence: 3, associativity: assocLeft),
    Token('*', precedence: 3, associativity: assocLeft),
    Token('+', precedence: 2, associativity: assocLeft),
    Token('-', precedence: 2, associativity: assocLeft),
  ];
  static const List<Token> functions = [
    Token('sqrt', precedence: 4),
    Token('sin', precedence: 3),
    Token('cos', precedence: 3),
    Token('tan', precedence: 3),
  ];
  static const assocLeft = 'leftAssociative';
  static const assocRight = 'rightAssociative';
}
