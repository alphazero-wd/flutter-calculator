import 'dart:math';

class Calculator {
  RegExp signRegex = RegExp(r'(\s[\+\-×÷]\s)');
  List<String> tokens = [
    'AC',
    '()',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'CE',
    '=',
  ];

  bool isSign(String token) {
    return token == '+' || token == '-' || token == '×' || token == '÷';
  }

  double calculateResult(String expression) {
    return _calculate(expression, 0).$1;
  }

  (double, int) _calculate(String expression, int index) {
    try {
      List<double> stack = [];
      String num = '0';
      String sign = '+';
      while (index < expression.length) {
        if (expression[index].contains(RegExp(r'[0-9]')) ||
            expression[index] == '.') {
          num += expression[index];
        } else if (expression[index] == '%') {
          num = (double.parse(num) * 0.01).toString();
        } else if (isSign(expression[index])) {
          _pushToStack(stack, sign, double.parse(num));
          sign = expression[index];
          num = '0';
        } else if (expression[index] == '(') {
          (double, int) result = _calculate(expression, index + 1);
          num = result.$1.toString();
          index = result.$2;
        } else if (expression[index] == ')') {
          _pushToStack(stack, sign, double.parse(num));
          return (stack.reduce((sum, num) => sum + num), index);
        }
        index++;
      }
      _pushToStack(stack, sign, double.parse(num));
      return (stack.reduce((sum, num) => sum + num), expression.length - 1);
    } catch (error) {
      return (double.nan, expression.length - 1);
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
}
