import 'dart:collection';
import 'dart:math' as math;

import 'package:meta/meta.dart';

import 'obj.dart';
import 'util.dart';

abstract class Tokenizer {
  List<Obj> tokenize(String input, [Map<String, dynamic>? replace]);
}

class DefaultTokenizer implements Tokenizer {
  const DefaultTokenizer();
  @override
  List<Obj> tokenize(String input, [Map<String, dynamic>? toReplace]) {
    var replaced = replace(input, toReplace);
    final result = _tokenize(replaced);
    return _clean(result);
  }

  @visibleForTesting
  String replace(String input, Map<String, dynamic>? replace) {
    if (replace == null || replace.isEmpty) return input;
    var list = input.split('');
    for (var i = 0; i < list.length; i++) {
      var possibleValue = replace[list[i]];
      if (possibleValue != null) {
        list[i] = possibleValue;
      }
    }
    return list.join();
  }

  List<Obj> _tokenize(String input) {
    final res = Queue<Obj>();
    final stack = Queue<String>();

    void clear() {
      if (stack.isEmpty) {
        return;
      }
      // construct number from items in stack
      final parsedNum = double.tryParse(stack.join());
      Obj obj;
      if (parsedNum != null) {
        obj = Num(parsedNum);
      } else {
        // num failed to parse, must be a function
        obj = Fun.from(stack.join());
      }
      stack.clear();
      res.add(obj);
    }

    void addStack(String char) {
      // check if char shares type with other items in stack
      if (stack.isNotEmpty) {
        final inputNum = char.isNumeric;
        final stackNum = stack.first.isNumeric;
        // if not, then clear
        if (inputNum && !stackNum || !inputNum && stackNum) clear();
      }
      stack.add(char);
    }

    for (var char in input.split('')) {
      // number or function might be longer than 1 char
      // add to stack
      if (char.isNumeric || char.isFunctional) {
        addStack(char);
      } else if (char == 'π') {
        clear();
        res.add(Num(math.pi));
      } else if (char == ' ') {
        // empty space means separation of values
        // used in postfix form
        // clear stack
        clear();
      } else {
        // is operator, clear stack
        clear();
        res.add(Op.from(char));
      }
    }
    // clear stack to add possible last item
    clear();
    return res.toList();
  }

  List<Obj> _clean(List<Obj> input) {
    for (var i = 0; i < input.length; i++) {
      // first item of the list
      // -=-=-=-=-
      // ^
      if (i == 0) {
        //Remove '-' at start of input and reverse value
        //- 2 + 5 -> -2 + 5
        if (input[0] == Op(Operator.substract)) {
          var val = Num(-(input[1] as Num).value);
          input[1] = val;
          input.removeAt(0);

          //+ 2 + 5 -> 2 + 5
        } else if (input[0] == Op(Operator.add)) {
          input.removeAt(0);
        }
        // rest of the list
        // -=-=-=-=-
        //  ^^^^^^^^
      } else {
        //2( -> 2*(
        if (input[i - 1] is Num && input[i] == ParL()) {
          input.insert(i, Op(Operator.multiply));
        }
        // 2π -> 2*π
        // should only happen with pi
        if (input[i - 1] is Num && input[i] == Num(math.pi)) {
          input.insert(i, Op(Operator.multiply));
        }
        if (input[i - 1] == Num(math.pi) && input[i] is Num) {
          input.insert(i, Op(Operator.multiply));
        }
        // 2sqrt(9) -> 2*sqrt(9)
        if (input[i - 1] is Num && input[i] is Fun) {
          input.insert(i, Op(Operator.multiply));
        }
        // sqrt 1 / 2 -> sqrt(1)/2
        if (input[i - 1] is Fun && input[i] is Num) {
          // sqrt 1
          //       ^
          input.insert(i + 1, ParR());
          // sqrt 1 )
          //     ^
          input.insert(i, ParL());
        }
      }
    }
    return input;
  }
}
