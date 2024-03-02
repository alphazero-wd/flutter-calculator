bool checkIsDigit(String token) {
  return token.contains(RegExp(r'[0-9]'));
}

bool checkIsOperator(String token) {
  return token == '+' || token == '-' || token == '×' || token == '÷';
}

bool checkTwoConsecutiveOperators(String expression, String tokenToPut) {
  if (expression.isEmpty || !checkIsOperator(tokenToPut)) return false;
  bool isNotUnaryMinus =
      tokenToPut != '-' && expression[expression.length - 1] == ' ';
  return isNotUnaryMinus || expression[expression.length - 1] == '-';
}

bool checkToAddWhiteSpace(String expression, String tokenToPut) {
  return expression.isNotEmpty &&
      checkIsOperator(tokenToPut) &&
      (checkIsDigit(expression[expression.length - 1]) ||
          expression[expression.length - 1].contains(RegExp(r'[\)%]')));
}

bool checkPreviousToken(String expression, String tokenToPut) {
  return expression.isNotEmpty &&
      !checkIsDigit(tokenToPut) &&
      tokenToPut == expression[expression.length - 1];
}

bool checkCannotAddPercent(String expression, String tokenToPut) {
  return tokenToPut == '%' &&
      (expression.isEmpty || !checkIsDigit(expression[expression.length - 1]));
}
