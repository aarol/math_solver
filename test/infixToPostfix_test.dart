import 'package:math_solver/src/infixToPostfix.dart';
import 'package:math_solver/src/obj.dart';
import 'package:math_solver/src/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  final infixPostfix = DefaultInfixToPostfix();
  final tokenizer = DefaultTokenizer();

  final tokenize = (str) => tokenizer.tokenize(str);

  final map = <List<Obj>, List<Obj>>{
    tokenize('2+1'): tokenize('2 1 +'),
    tokenize('2^2/2-2'): tokenize('2 2 ^ 2 / 2 -'),
    tokenize('12/(2+2*2)'): tokenize('12 2 2 2 * + /'),
    tokenize('sin(tan(cos(5)))'): tokenize('5 cos tan sin'),
    tokenize('(1)-634*(1-42)'): tokenize('1 634 1 42 - * -'),
  };

  for (var entry in map.entries) {
    test(entry.key, () {
      expect(infixPostfix.infixToPostfix(entry.key), entry.value);
    });
  }
}
