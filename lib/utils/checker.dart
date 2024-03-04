bool checkIsDigit(String token) {
  return token.contains(RegExp(r'[0-9]'));
}

bool checkIsSpaceOrOpenParenthesis(String token) {
  return token.contains(RegExp(r'[ \(]'));
}

bool checkIsUnaryMinus(String expression, int index) {
  return index + 1 < expression.length &&
      (checkIsDigit(expression[index + 1]) || expression[index + 1] == '(') &&
      expression[index] == '-';
}

bool checkIsDotOrPercentOrCloseParenthesis(String token) {
  return token.contains(RegExp(r'[\.%\)]'));
}

bool checkIsOperator(String token) {
  return token == '+' || token == '-' || token == '×' || token == '÷';
}

bool checkCannotPutOperator(String expression, String tokenToPut) {
  if (!checkIsOperator(tokenToPut)) return false;
  if (expression.isEmpty) {
    if (tokenToPut != '-') {
      return true;
    } else {
      return false;
    }
  } else {
    bool isNotUnaryMinus = tokenToPut != '-' &&
        checkIsSpaceOrOpenParenthesis(expression[expression.length - 1]);
    bool isPreviousUnaryMinus = expression[expression.length - 1] == '-';
    return isNotUnaryMinus || isPreviousUnaryMinus;
  }
}

bool checkToAddWhiteSpace(String expression, String tokenToPut) {
  return expression.isNotEmpty &&
      checkIsOperator(tokenToPut) &&
      (checkIsDigit(expression[expression.length - 1]) ||
          checkIsDotOrPercentOrCloseParenthesis(
              expression[expression.length - 1]));
}

bool checkToAddClosingParenthesis(String expression) {
  return expression.isNotEmpty &&
      (checkIsDigit(expression[expression.length - 1]) ||
          checkIsDotOrPercentOrCloseParenthesis(
              expression[expression.length - 1]));
}

bool checkCannotAddPercent(String expression, String tokenToPut) {
  return tokenToPut == '%' &&
      (expression.isEmpty ||
          (!checkIsDigit(expression[expression.length - 1]) &&
              !checkIsDotOrPercentOrCloseParenthesis(
                  expression[expression.length - 1])));
}

bool _checkMultipleDecimalPointsInNumber(String expression) {
  for (int i = expression.length - 1; i >= 0; i--) {
    if (checkIsSpaceOrOpenParenthesis(expression[i])) break;
    if (expression[i] == '.') return true;
  }
  return false;
}

bool checkCannotAddDecimalPoint(String expression, String tokenToPut) {
  if (tokenToPut != '.' || expression.isEmpty) return false;
  return _checkMultipleDecimalPointsInNumber(expression) ||
      (checkIsDotOrPercentOrCloseParenthesis(
              expression[expression.length - 1]) ||
          expression[expression.length - 1] == '.');
}

bool checkToAddZeroBeforeDecimalPoint(String expression, String tokenToPut) {
  return tokenToPut == '.' &&
      (expression.isEmpty ||
          expression[expression.length - 1] == '-' ||
          checkIsSpaceOrOpenParenthesis(expression[expression.length - 1]));
}
