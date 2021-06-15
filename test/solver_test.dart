import 'package:math_solver/math_solver.dart';
import 'package:test/test.dart';

void main() {
  final solver = Solver();

  group('solver', () {
    group('simple', () {
      final map = <String, String>{
        '2+1': '3',
        '100*100': '10 000',
        '2^8': '256',
      };

      for (var entry in map.entries) {
        test(entry.key, () {
          expect(solver.solve(entry.key), entry.value);
        });
      }
    });

    group('advanced', () {
      final map = <String, String>{
        '1.5*3^2': '13.5',
        '10sqrt(81)': '90',
        '2^8': '256',
      };

      for (var entry in map.entries) {
        test(entry.key, () {
          expect(solver.solve(entry.key), entry.value);
        });
      }
    });
  });
}
