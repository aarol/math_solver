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

class Stack<T> {
  final ListQueue<T> _list = ListQueue();

  bool get isNotEmpty => _list.isNotEmpty;
  bool get isEmpty => _list.isEmpty;

  void push(T e) => _list.addLast(e);

  T pop() => _list.removeLast();

  T get top => _list.last;

  bool contains(T x) {
    for (var item in _list) {
      if (x == item) return true;
    }
    return false;
  }

  List<T> toList() {
    return _list.toList();
  }
}

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
