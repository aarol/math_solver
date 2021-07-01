import 'package:math_solver/math_solver.dart';
import 'package:rational/rational.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  var solver = Solver();

  group('solver', () {
    group('simple', () {
      final map = <String, Rational>{
        '2+1': r(3),
        '100*100': r(10000),
        '2^8': r(256),
      };

      for (var entry in map.entries) {
        test(entry.key, () {
          expect(solver.solve(entry.key), entry.value);
        });
      }
    });

    group('advanced', () {
      final map = <String, Rational>{
        '1.5*3^2': rs('13.5'),
        '3.5*sin(3^2*10)': rs('3.5'),
        '10sqrt(81)': rs('90'),
        '2^8': rs('256'),
        '2sin(90*2-3*30)-1.5': rs('0.5'),
      };

      for (var entry in map.entries) {
        test(entry.key, () {
          expect(solver.solve(entry.key), entry.value);
        });
      }
    });

    group('replace', () {
      final tReplaced = {
        '×': '*',
        '√': 'sqrt',
        '÷': '/',
      };

      solver = Solver(replace: tReplaced);
      final input = '√1×2÷8';
      var output = rs('0.25');
      test(input, () {
        expect(
          solver.solve(input),
          output,
        );
      });
    });
  });
}
