part of 'solver.dart';

Obj _functionFromString(String input) {
  switch (input) {
    case 'sqrt':
      return Fun(Function.SquareRoot);
    case 'sin':
      return Fun(Function.Sin);
    case 'cos':
      return Fun(Function.Cos);
    case 'tan':
      return Fun(Function.Tan);
    default:
      return Undefined();
  }
}

Obj _operatorFromString(String char) {
  switch (char) {
    case '(':
      return ParL();
    case ')':
      return ParR();
    case '-':
      return Op(Operator.Substract);
    case '+':
      return Op(Operator.Add);
    case '*':
      return Op(Operator.Multiply);
    case '/':
      return Op(Operator.Divide);
    case '^':
      return Op(Operator.Exponent);
    default:
      return Undefined();
  }
}
