import 'dart:math' as math;

import 'package:math_solver/src/obj/tables.dart';
import 'package:meta/meta.dart';
import 'package:rational/rational.dart';

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
    replace ??= {'π': math.pi};
    var list = input.split('');
    for (var i = 0; i < list.length; i++) {
      var possibleValue = replace[list[i]];
      if (possibleValue != null) {
        list[i] = possibleValue.toString();
      }
    }
    return list.join();
  }

  List<Obj> _tokenize(String input) {
    final output = <Obj>[];

    var numBuffer = '';
    var funcBuffer = '';

    void clearNumBuffer() {
      if (numBuffer.isNotEmpty) {
        try {
          var number = Rational.parse(numBuffer);
          output.add(Num(number));
        } on FormatException catch (_) {
          // TODO: Do something here
          return;
        }
        numBuffer = '';
      }
    }

    void clearFuncBuffer() {
      if (funcBuffer.isNotEmpty) {
        var obj = kParseTable[funcBuffer];
        if (obj != null) {
          output.add(obj);
        } else {
          throw Exception('Cannot tokenize $funcBuffer');
        }
        funcBuffer = '';
      }
    }

    var iter = input.runes.iterator;
    while (iter.moveNext()) {
      var char = iter.currentAsString;

      // is any 1-character-length operator
      if (kParseTable[char] != null) {
        clearNumBuffer();
        clearFuncBuffer();
        output.add(kParseTable[char]!);
        continue;
      }

      if (char.isNumeric) {
        // is part of a number
        var buffer = StringBuffer(numBuffer);
        buffer.write(char);
        clearFuncBuffer();
        numBuffer = buffer.toString();
      } else {
        if (char == ' ') {
          // empty characters should clear
          // this is because postfix inputs have spaces to separate numbers
          clearNumBuffer();
          clearFuncBuffer();
        } else {
          // has to be a part of a function
          var buffer = StringBuffer(funcBuffer);
          buffer.write(char);
          clearNumBuffer();
          funcBuffer = buffer.toString();
        }
      }
    }
    clearNumBuffer();
    clearFuncBuffer();
    return output;
  }

  List<Obj> _clean(List<Obj> input) {
    for (var i = 0; i < input.length; i++) {
      if (i == 0) {
        // first item of the list
        // -=-=-=-=-
        // ^

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
      } else {
        // rest of the list
        // -=-=-=-=-
        //  ^^^^^^^^

        //2( -> 2*(
        if (input[i - 1] is Num && input[i] == ParL()) {
          input.insert(i, Op(Operator.multiply));
        }
        // 2π -> 2*π
        // should only happen with pi
        if (input[i - 1] is Num && input[i] == Num(kRationalPi)) {
          input.insert(i, Op(Operator.multiply));
        }
        if (input[i - 1] == Num(kRationalPi) && input[i] is Num) {
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
