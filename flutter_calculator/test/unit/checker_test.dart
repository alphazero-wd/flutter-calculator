import 'package:flutter_calculator/utils/checker.dart';
import 'package:test/test.dart';

void main() {
  group('Test checkIsDigit', () {
    test('should be true if the given token is a digit', () {
      expect(checkIsDigit('0'), true);
      expect(checkIsDigit('9'), true);
    });

    test("should be false if the given token isn't a digit", () {
      expect(checkIsDigit('-'), false);
      expect(checkIsDigit('%'), false);
      expect(checkIsDigit('.'), false);
    });
  });

  group('Test checkIsSpaceOrOpenParenthesis', () {
    test('should be true in the following cases', () {
      expect(checkIsSpaceOrOpenParenthesis(' '), true);
      expect(checkIsSpaceOrOpenParenthesis('('), true);
    });

    test('should be false in the following cases', () {
      expect(checkIsSpaceOrOpenParenthesis('%'), false);
      expect(checkIsSpaceOrOpenParenthesis('.'), false);
      expect(checkIsSpaceOrOpenParenthesis('9'), false);
    });
  });

  group('Test checkIsDotOrPercentOrCloseParenthesis', () {
    test('should be true in the following cases', () {
      expect(checkIsDotOrPercentOrCloseParenthesis('.'), true);
      expect(checkIsDotOrPercentOrCloseParenthesis('%'), true);
      expect(checkIsDotOrPercentOrCloseParenthesis(')'), true);
    });

    test('should be false in the following cases', () {
      expect(checkIsDotOrPercentOrCloseParenthesis('('), false);
      expect(checkIsDotOrPercentOrCloseParenthesis('+'), false);
      expect(checkIsDotOrPercentOrCloseParenthesis('9'), false);
    });
  });

  group('Test checkIsOperator', () {
    test('should be true if the given token is an operator', () {
      expect(checkIsOperator('+'), true);
      expect(checkIsOperator('-'), true);
      expect(checkIsOperator('×'), true);
      expect(checkIsOperator('÷'), true);
    });
    test("should be false if the given token isn't an operator", () {
      expect(checkIsOperator('9'), false);
      expect(checkIsOperator('.'), false);
      expect(checkIsOperator('%'), false);
      expect(checkIsOperator('='), false);
    });
  });

  group('Test checkCannotPutOperator', () {
    test("should be true in the following cases", () {
      expect(checkCannotPutOperator('', '+'), true);
      expect(checkCannotPutOperator('12 - (', '+'), true);
      expect(checkCannotPutOperator('-8 × ', '+'), true);
      expect(checkCannotPutOperator('8 + -', '÷'), true);
      expect(checkCannotPutOperator('9 ÷ -', '-'), true);
    });

    test("should be false in the following cases", () {
      expect(checkCannotPutOperator('', '-'), false);
      expect(checkCannotPutOperator('3 × 4 - (', '-'), false);
      expect(checkCannotPutOperator('-8 × ', '-'), false);
      expect(checkCannotPutOperator('8 + 7', '÷'), false);
      expect(checkCannotPutOperator('(8 + 3)', '÷'), false);
      expect(checkCannotPutOperator('13 × 25%', '-'), false);
    });
  });

  group('Test checkToAddWhiteSpace', () {
    test('should be true in the following cases', () {
      expect(checkToAddWhiteSpace('8 + 7', '-'), true);
      expect(checkToAddWhiteSpace('(9 × -11)', '+'), true);
      expect(checkToAddWhiteSpace('23 - 70%', '÷'), true);
    });

    test('should be false in the following cases', () {
      expect(checkToAddWhiteSpace('', '-'), false);
      expect(checkToAddWhiteSpace('12 + (', '-'), false);
      expect(checkToAddWhiteSpace('30 × ', '-'), false);
    });
  });

  group('Test checkToAddClosingParenthesis', () {
    test('should be false in the following cases', () {
      expect(checkToAddClosingParenthesis(''), false);
      expect(checkToAddClosingParenthesis('12 - '), false);
      expect(checkToAddClosingParenthesis('(36 + ('), false);
    });

    test('should be true in the following cases', () {
      expect(checkToAddClosingParenthesis('(3 + 7'), true);
      expect(checkToAddClosingParenthesis('27 - 9%'), true);
      expect(checkToAddClosingParenthesis('(48 - (9% × 7)'), true);
    });
  });

  group('Test checkCannotAddPercent', () {
    test('should be false in the following cases', () {
      expect(checkCannotAddPercent('8', '+'), false);
      expect(checkCannotAddPercent('3', '%'), false);
      expect(checkCannotAddPercent('12 - 9%', '%'), false);
      expect(checkCannotAddPercent('(3 + 8)', '%'), false);
    });

    test('should be true in the following cases', () {
      expect(checkCannotAddPercent('', '%'), true);
      expect(checkCannotAddPercent('27 - ', '%'), true);
      expect(checkCannotAddPercent('(48 - (9% ×', '%'), true);
    });
  });

  group('Test checkCannotAddDecimalPoint', () {
    test('should be false in the following cases', () {
      expect(checkCannotAddDecimalPoint('18', '+'), false);
      expect(checkCannotAddDecimalPoint('', '.'), false);
      expect(checkCannotAddDecimalPoint('(', '.'), false);
      expect(checkCannotAddDecimalPoint('27 - ', '.'), false);
      expect(checkCannotAddDecimalPoint('3', '.'), false);
    });

    test('should be true in the following cases', () {
      expect(checkCannotAddDecimalPoint('48%', '.'), true);
      expect(checkCannotAddDecimalPoint('(3 + 8)', '.'), true);
      expect(checkCannotAddDecimalPoint('4.', '.'), true);
      expect(checkCannotAddDecimalPoint('(23 - 123.75', '.'), true);
    });
  });

  group('Test checkToAddZeroBeforeDecimalPoint', () {
    test('should be true in the following cases', () {
      expect(checkToAddZeroBeforeDecimalPoint('', '.'), true);
      expect(checkToAddZeroBeforeDecimalPoint('(', '.'), true);
      expect(checkToAddZeroBeforeDecimalPoint('27 - ', '.'), true);
    });

    test('should be false in the following cases', () {
      expect(checkToAddZeroBeforeDecimalPoint('', '+'), false);
      expect(checkToAddZeroBeforeDecimalPoint('3', '.'), false);
      expect(checkToAddZeroBeforeDecimalPoint('8 - 7', '.'), false);
    });
  });
}
