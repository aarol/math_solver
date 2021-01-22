///formats the input into a more readable format
///
///

String format(String input) {
  if (input == null) return '';
  var value = double.tryParse(input);
  if (value == null) return '';
  if (value.remainder(1) != 0.0) {
    //value is decimal
    //skip everything
    return value.toString();
  }
  // 1234567 ->  <String>[7,6,5,4,3,2,1]
  var list = value.toInt().toString().split('').reversed.toList();
  final length = list.length;
  // count is added so the index moves as the list grows
  var count = 0;
  // --> [7, 6, 5,'',4,3,2,'',1]
  for (var i = 0; i < length; i++) {
    if (i != 0 && i % 3 == 0) {
      list.insert(i + count, ' ');
      count++;
    }
  }
  return list.reversed.join();
}

String formatNotation(BigInt input) {
  //smaller than 10 000 000 000 or 10 ^ 10
  //don't format
  if (input < BigInt.from(10000000000)) {
    return input.toString();
  } else {
    var bfr = StringBuffer();
    var str = input.toString();
    var pre = str[0] == '-' ? '-' : '+';
    var first = str.substring(0, 3).split('');
    bfr.write((first..insert(1, '.')).join());
    var rest = str.length - 1;
    bfr.write('e$pre$rest');
    return bfr.toString();
  }
}
