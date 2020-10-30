import 'package:math_solver/math_solver.dart';
import 'package:test/test.dart';

void main() {
  group('solver unit test', () {
    test('6*6', () {
      expect(Solver.solve('6*6'), '36');
    });
    test('-6+(3*4)', () {
      expect(Solver.solve('-6+(3*4)'), '6');
    });
    test('2*sqrt(9)', () {
      expect(Solver.solve('2*sqrt(9)'), '6');
    });
    test('3+4*2/(1-5)^2^3', () {
      expect(Solver.solve('3+4*2/(1-5)^2^3'), '3.0001220703125');
    });
  });
  group('format output', () {
    test('633418654', () {
      expect(Solver.format('1633418654'), '1 633 418 654');
    });
    test('31415', () {
      expect(Solver.format('31415'), '31 415');
    });
    test('155', () {
      expect(Solver.format('155'), '155');
    });
    test('0.04', () {
      expect(Solver.format('0.04'), '0.04');
    });
    test('2000.04', () {
      expect(Solver.format('2000.04'), '2 000.04');
    });
    test('164534.0006534', () {
      expect(Solver.format('164534.0006534'), '164 534.0006534');
    });
  });
}
