String format(double input) {
  if (input.remainder(1) != 0.0) {
    //input is decimal
    //skip everything
    return input.toString();
  }
  var list = input.toInt().toString().split('').reversed.toList();
  final length = list.length;
  var added = 0;
  for (var i = 0; i < length; i++) {
    if (i != 0 && i % 3 == 0) {
      list.insert(i + added, ' ');
      added++;
    }
  }
  return list.reversed.join();
}
