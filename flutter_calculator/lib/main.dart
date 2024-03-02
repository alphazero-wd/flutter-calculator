import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/calculator.dart';
import 'package:flutter_calculator/utils/checker.dart';
import 'package:flutter_calculator/widgets/buttons.dart';
import 'package:flutter_calculator/widgets/panel.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String expression = '';
  double result = 0;
  void _onEqual() {
    setState(() {
      result = Calculator.calculateResult(expression);
      expression = result.isNaN
          ? ''
          : result.toString().endsWith('.0')
              ? result.toStringAsFixed(0)
              : result.toString();
    });
    return;
  }

  void _onClearAll() {
    setState(() {
      expression = '';
      result = 0;
    });
  }

  void _onParenthesis() {
    setState(() {
      expression += expression.isNotEmpty &&
              (checkIsDigit(expression[expression.length - 1]) ||
                  expression[expression.length - 1] == ')')
          ? ')'
          : '(';
    });
  }

  void _onRemoveLast() {
    if (expression.isEmpty) return;
    setState(() {
      bool endWithWhiteSpace = expression[expression.length - 1] == ' ';
      expression = expression.substring(
        0,
        expression.length - (endWithWhiteSpace ? 3 : 1),
      );
    });
  }

  void _onAddToken(String token) {
    bool hasTwoConsecutiveOperators =
        checkTwoConsecutiveOperators(expression, token);
    bool hasSameTokenWithPrevious = checkPreviousToken(expression, token);
    if (hasTwoConsecutiveOperators || hasSameTokenWithPrevious) return;

    setState(() {
      String whiteSpace = checkToAddWhiteSpace(expression, token) ? ' ' : '';
      expression += whiteSpace + token + whiteSpace;
    });
  }

  void _onButtonTap(String token) {
    switch (token) {
      case '=':
        _onEqual();
        break;
      case 'AC':
        _onClearAll();
        break;
      case '()':
        _onParenthesis();
        break;
      case 'CE':
        _onRemoveLast();
        break;
      default:
        _onAddToken(token);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calox",
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                  bottom: 25,
                  left: 20,
                  right: 20,
                ),
                child: Panel(
                  expression: expression,
                  result: result,
                ),
              ),
            ),
            Buttons(onButtonTap: _onButtonTap)
          ],
        ),
      ),
    );
  }
}
