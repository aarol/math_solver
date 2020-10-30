//Funktiot
part of math_solver;

const _degToRad = 0.0174532925;

num plus(a, b) => b + a;
num minus(a, b) => b - a;
num multiply(a, b) => b * a;
num divide(a, b) => b / a;
num power(a, b) => math.pow(b, a);

num sqrt(x) => math.sqrt(x);
num sin(x) => math.sin(x * _degToRad);
num cos(x) => math.cos(x * _degToRad);
num tan(x) => math.tan(x * _degToRad);

Function stringToOperator(String token) {
  switch (token) {
    case '+':
      return plus;
    case '-':
      return minus;
    case '*':
      return multiply;
    case '/':
      return divide;
    case '^':
      return power;
  }
  throw Exception('Token operator not found: $token');
}

Function stringToFunction(String token) {
  switch (token) {
    case 'sqrt':
      return sqrt;
    case 'sin':
      return sin;
    case 'cos':
      return cos;
    case 'tan':
      return tan;
  }
  throw Exception('Token function not found: $token');
}
