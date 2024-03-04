import 'package:flutter_calculator/utils/calculator.dart';
import 'package:test/test.dart';

void main() {
  group("special cases", () {
    test('the result should be 0 if the expression is empty', () {
      expect(calculateResult(''), 0);
    });
    test('the result should be the input if there is only one number', () {
      expect(calculateResult('-8.5'), -8.5);
    });

    test('the result is correct when multiple %s are placed after a number',
        () {
      expect(calculateResult('8%%'), 8e-4);
    });

    group("when the expression is invalid", () {
      test('the result is still returned even if lacking operand', () {
        expect(calculateResult('3 + '), 3);
        expect(calculateResult('-'), 0);
      });

      test('the result should be NaN if division by 0', () {
        expect(calculateResult('8 ÷ 0'), double.infinity);
      });

      test('the result is still returned if missing closing parenthesis', () {
        expect(calculateResult('7 - 8 × ('), 7);
        expect(calculateResult('((7 - 8) × (3 - 8.5)'), 5.5);
      });
    });

    group('basic expression', () {
      test('should evaluate correctly with + operator', () {
        expect(calculateResult('3 + 5'), 8);
      });
      test('should evaluate correctly with - operator', () {
        expect(calculateResult('1 - 9'), -8);
      });

      test('should evaluate correctly with × operator', () {
        expect(calculateResult('-8 × -7'), 56);
      });

      test('should evaluate correctly with ÷ operator', () {
        expect(calculateResult('1 ÷ 4'), 0.25);
      });
    });

    group('check for precedence', () {
      test('should prioritize correctly without parentheses', () {
        expect(calculateResult('3 + 8 × -5'), -37);
        expect(calculateResult('1 ÷ -4 + 10'), 9.75);
      });

      test('should prioritize correctly with parentheses', () {
        expect(calculateResult('(3 + 8) × -5'), -55);
        expect(calculateResult('66 ÷ (-4 + 10)'), 11);
      });
    });

    group('testing complex expressions', () {
      String complexExpression = '(-(3 - -5.3) ÷ 2) - -(3 × 8)';
      test('should invert the sign correctly', () {
        expect(calculateResult(complexExpression), 19.85);
      });
      test('should evaluate with percents and decimal points', () {
        String complexExpression = '((3.14 + 8%%) × (-5% - 3.92)) + 5.61 ÷ 3';
        expect(calculateResult(complexExpression), -10.598976);
      });
    });
  });
}
