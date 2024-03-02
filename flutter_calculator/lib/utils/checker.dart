bool checkIfSign(String token) {
  return token == '+' || token == '-' || token == '×' || token == '÷';
}

bool checkUnclosedParenthesis(String expression) {
  int size = expression.length;
  bool isParenthesisClosed = true;
  for (int i = 0; i < size; i++) {
    if (expression[i] == '(') isParenthesisClosed = false;
    if (expression[i] == ')') isParenthesisClosed = true;
  }
  return isParenthesisClosed;
}

bool checkTwoConsecutiveOperators(String expression, String tokenToPut) {
  return checkIfSign(tokenToPut) &&
      expression.isNotEmpty &&
      (expression[expression.length - 1] == ' ' ||
          expression[expression.length - 1] == '-');
}

bool checkHasInvalidOperatorAfter(String expression, String tokenToPut) {
  return checkIfSign(tokenToPut) &&
      (expression.isEmpty || expression[expression.length - 1] == '(');
}
