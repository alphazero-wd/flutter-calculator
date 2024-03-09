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
      result = calculateResult(expression);
      expression = (result.isNaN || result.isInfinite)
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
      expression += checkToAddClosingParenthesis(expression) ? ')' : '(';
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
    bool hasTwoConsecutiveOperators = checkCannotPutOperator(expression, token);
    bool cannotAddPercent = checkCannotAddPercent(expression, token);
    bool cannotAddDecimalPoint = checkCannotAddDecimalPoint(expression, token);
    if (hasTwoConsecutiveOperators ||
        cannotAddPercent ||
        cannotAddDecimalPoint) {
      return;
    }

    setState(() {
      String whiteSpace = checkToAddWhiteSpace(expression, token) ? ' ' : '';
      String zeroBeforeDecimalPoint =
          checkToAddZeroBeforeDecimalPoint(expression, token) ? '0' : '';
      expression += whiteSpace + zeroBeforeDecimalPoint + token + whiteSpace;
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
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      title: "Calox",
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
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
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 500,
                color: Colors.grey.shade100,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Buttons(onButtonTap: _onButtonTap),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
