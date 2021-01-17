///formats the input into a more readable format
///
///

String format(double input) {
  if (input.remainder(1) != 0.0) {
    //input is decimal
    //skip everything
    return input.toString();
  }
  // 1234567 ->  <String>[7,6,5,4,3,2,1]
  var list = input.toInt().toString().split('').reversed.toList();
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
