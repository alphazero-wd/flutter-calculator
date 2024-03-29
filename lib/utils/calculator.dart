import 'package:flutter_calculator/utils/checker.dart';

double calculateResult(String expression) {
  return _calculate(expression, 0).$1;
}

(double, int) _calculate(String expression, int index) {
  try {
    List<double> stack = [];
    String num = '0';
    String sign = '+';
    while (index < expression.length) {
      if (checkIsUnaryMinus(expression, index)) {
        num = expression[index];
      } else if (checkIsDigit(expression[index]) || expression[index] == '.') {
        num += expression[index];
      } else if (expression[index] == '%') {
        num = (double.parse(num) * 0.01).toString();
      } else if (checkIsOperator(expression[index])) {
        _pushToStack(stack, sign, double.parse(num));
        sign = expression[index];
        num = '0';
      } else if (expression[index] == '(') {
        (double, int) result = _calculate(expression, index + 1);
        if (num == '-') {
          num += result.$1.toString();
        } else {
          num = result.$1.toString();
        }
        index = result.$2;
      } else if (expression[index] == ')') {
        _pushToStack(stack, sign, double.parse(num));
        return (stack.reduce((sum, num) => sum + num), index);
      }
      index++;
    }
    _pushToStack(stack, sign, double.parse(num));
    return (stack.reduce((sum, num) => sum + num), expression.length);
  } catch (error) {
    return (double.nan, expression.length);
  }
}

void _pushToStack(List<double> stack, String sign, double num) {
  switch (sign) {
    case '+':
      stack.add(num);
      break;
    case '-':
      stack.add(-num);
      break;
    case '×':
      stack.add(stack.removeLast() * num);
      break;
    case '÷':
      stack.add(stack.removeLast() / num);
      break;
    default:
      throw ArgumentError(
        'Sign must be one of the following: +, -, ×, ÷ but got $sign',
      );
  }
}
