import 'dart:collection';

import 'utils.dart';
import 'stack.dart';
import 'token.dart';
import 'fun.dart';

/**Solves an mathematical expression.
* 
*Examples:
*
*     Solver.solve('-8*(-10)');
*     Solver.solve('100/12.5');
*     Solver.solve('(5*4-10)^2');
*     Solver.solve('sqrt(18)');
*
*A map of <String, dynamic> is optional, it is used to remap certain values.
*
*Examples:
*
*     Solver.solve('√(36)', {'√': 'sqrt'} );
*     Solver.solve('2×5÷5)', {'×': '*', '÷': '/'});
*     Solver.solve('2×π)', {'×': '*', 'π': pi});
*
**/
abstract class Solver {
  static String solve(String input, [Map<String, dynamic>? valuesToRemap]) {
    var cleanInput = input;

    //Uses a HashMap to iterate through the entries only once
    if (valuesToRemap != null) {
      var inputList = cleanInput.split('');
      var hashMap = HashMap<String, dynamic>.from(valuesToRemap);
      for (var i = 0; i < input.length; i++) {
        //remove spaces
        if (inputList[i] == ' ') {
          inputList[i] == '';
        } else {
          var hashValue = hashMap.putIfAbsent(inputList[i], () => null);
          if (hashValue != null) {
            inputList[i] = hashValue.toString();
          }
        }
      }
      cleanInput = inputList.join('');
    } else {
      cleanInput = input.replaceAll(' ', '');
    }

    var postFix = _infixToPostfix(cleanInput);
    return _evaluate(postFix);
  }

  static String format(String input) {
    var cutString = '';
    var list = [];
    if (input.contains('.')) {
      cutString = input.substring(input.indexOf('.'), input.length);
      list = input.substring(0, input.indexOf('.')).split('').reversed.toList();
    } else {
      list = input.split('').reversed.toList();
    }
    var listLength = list.length;
    for (var i = 0; i < listLength; i++) {
      if (i != 0 && i % 3 == 0) {
        list.insert(i + i ~/ 3 - 1, ' ');
      }
    }
    return list.reversed.join() + cutString;
  }

  ///muuttaa input-stringin ('3.5*8') muotoon ['3.5', '*', '8']
  static List<String> _listFromString(String input) {
    var result = <String>[];
    var tempArray = <String>[];

    void clearTemp() {
      if (tempArray.isNotEmpty) {
        var join = tempArray.join();
        if (join.isNum) {
          result.add(_roundString(double.parse(join)));
        } else {
          result.add(join);
        }
        tempArray.clear();
      }
    }

    for (var i = 0; i < input.length; i++) {
      var current = input[i];
      if (current.isNum || current == '.') {
        //if tempArray isn't a number and doesn't have an unary minus
        if (!tempArray.join('').isNum &&
            (tempArray.isNotEmpty && !'+-'.contains(tempArray.first))) {
          clearTemp();
        }
        tempArray.add(current);
      } else if (current.isOperator || '()'.contains(current)) {
        //takes care of unary operations by checking if previous wasn't num
        if ('+-'.contains(current) && (i == 0 || !input[i - 1].isNum)) {
          tempArray.add(current);
        } else {
          //single character operators can't stack
          clearTemp();
          result.add(current);
        }
        //current must be a letter of a function
      } else {
        tempArray.add(current);
      }
    }
    clearTemp();
    return result;
  }

  static List<String> _infixToPostfix(String inputString) {
    var infix = _listFromString(inputString);

    var outputQueue = Stack<String>();
    var operatorStack = Stack<Token>();

    //while there are tokens to be read:
    for (var i = 0; i < infix.length; i++) {
      var token = infix[i];
      if (token.isNum) {
        outputQueue.push(token);
      } else if (token.isOperator) {
        var thisOperator = Token.findOperator(token);

        while (operatorStack.isNotEmpty) {
          //if lesser precedence || equal when lefAssoc.
          if (_shouldPop(thisOperator, operatorStack.top)) {
            //pop from operatorStack to queue
            outputQueue.push(operatorStack.pop().value);
          } else {
            //if can't pop then break
            break;
          }
        }
        //push operator to stack either way
        operatorStack.push(thisOperator);
        //if token is '('
      } else if (token == '(') {
        operatorStack.push(Token(token));
        //if token is ')'
      } else if (token == ')') {
        //loops through to find '('
        var foundMatching = false;
        while (operatorStack.isNotEmpty) {
          if (operatorStack.top != Token('(')) {
            //pops every op which isn't '('
            outputQueue.push(operatorStack.pop().value);
          } else {
            //if token is '('
            operatorStack.pop();
            foundMatching = true;
            break;
          }
        }
        //if operatorStack doesn't have '('
        if (!foundMatching) throw Exception('Mismatching parenthesis: "("');
      } else if (token.isFunc) {
        operatorStack.push(Token.findFunction(token));
      } else {
        //if isn't number, parenthesis, operator
        throw Exception('Symbol not identified: $token');
      }
    }
    //pop all items to outputQueue
    while (operatorStack.isNotEmpty) {
      var last = operatorStack.pop();
      if (last == Token('(')) throw Exception('Mismatching parenthesis: ")"');
      outputQueue.push(last.value);
    }
    return outputQueue.toList();
  }

  static bool _shouldPop(Token token, Token last) {
    return (last != Token('(') &&
        (token.precedence! < last.precedence! ||
            (token.precedence == last.precedence &&
                token.associativity == Token.assocLeft)));
  }

  ///solves each item in the postfix stack returned by infixToPostfix
  static String _evaluate(List<String> list) {
    var resultStack = Stack<double>();
    for (var i = 0; i < list.length; i++) {
      var token = list[i];
      if (token.isNum) {
        resultStack.push(token.parseDouble()!);
        //jos token on funktio
      } else if (token.isFunc) {
        var operation = stringToFunction(token);
        //ottaa yhden numeron
        var res = operation(resultStack.pop());
        resultStack.push(res);
        //jos operaattori
      } else if (token.isOperator) {
        var operation = stringToOperator(token);
        var res = operation(resultStack.pop(), resultStack.pop());
        resultStack.push(res);
      } else {
        throw Exception('Did not find type for $token');
      }
    }
    if (resultStack.isEmpty) throw Exception('resultStack is empty');

    //tarkistaa jos laskusta tulee infinity
    //tarkoitus on vaihtaa bigInt-classiin
    if (resultStack.top.toDouble() == double.infinity) {
      var bigStack = Stack<BigInt>();
      for (var i = 0; i < list.length; i++) {
        var token = list[i];
        if (token.isNum) {
          bigStack.push(BigInt.parse(token));
          //jos token on funktio
        } else if (token.isFunc) {
          var operation = stringToFunction(token);
          //ottaa yhden numeron
          var res = operation(bigStack.pop());
          bigStack.push(res);
          //jos operaattori
        } else if (token.isOperator) {
          var operation = stringToOperator(token);
          var res = operation(bigStack.pop(), bigStack.pop());
          bigStack.push(res);
        } else {
          throw Exception('Did not find type for $token');
        }
      }
      return bigStack.top.toString();
    }

    return _roundString(resultStack.top);
  }

  static String _roundString(dynamic input) {
    var number = input is List ? double.parse(input.join()) : input;
    return number % 1 == 0 ? number.toInt().toString() : number.toString();
  }
}
