import 'package:math_solver/math_solver.dart';
import 'package:test/test.dart';

void main() {
  group('temp', () {
    print(Solver.solve('5-(9+5)'));
  });
  group('solver unit test', () {
    var testValues = {
      '6*6': '36',
      '-6+(3*4)': '6',
      '2*sqrt(9)': '6',
      '3+4*2/(1-5)^2^3': '3.0001220703125',
      '((10-4*2)^3)^2': '64',
    };
    for (var entry in testValues.entries) {
      test(entry.key, () {
        expect(Solver.solve(entry.key), entry.value);
      });
    }
  });
  group('format output', () {
    var testValues = {
      '1633418654': '1 633 418 654',
      '31415': '31 415',
      '155': '155',
      '0.04': '0.04',
      '2000.04': '2 000.04',
      '164534.0006534': '164 534.0006534',
    };
    for (var entry in testValues.entries) {
      test(entry.key, () {
        expect(Solver.format(entry.key), entry.value);
      });
    }
  });
}
