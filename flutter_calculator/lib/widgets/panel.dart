import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/calculator.dart';
import 'package:flutter_calculator/widgets/buttons.dart';

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  String expression = '';
  double result = 0;
  Calculator calculator = Calculator();
  void _onEqual() {
    setState(() {
      result = calculator.calculateResult(expression);
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
      bool isParenthesisClosed =
          calculator.checkUnclosedParenthesis(expression);
      expression += isParenthesisClosed ? '(' : ')';
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
    setState(() {
      bool hasInvalidOperatorAfterParenthesis =
          calculator.hasInvalidOperatorAfter(expression, token);
      String whiteSpace =
          (!hasInvalidOperatorAfterParenthesis && calculator.isSign(token))
              ? " "
              : "";
      expression += whiteSpace + token + whiteSpace;
    });
  }

  void _onButtonTap(String token) {
    bool hasTwoConsecutiveOperators =
        calculator.hasTwoConsecutiveOperators(expression, token);
    if (hasTwoConsecutiveOperators) return;

    bool hasInvalidOperatorAfter =
        calculator.hasInvalidOperatorAfter(expression, token);

    if (hasInvalidOperatorAfter && token != '-') {
      return;
    }

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
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      expression,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: (40 - expression.length * 2)
                            .clamp(30, 40)
                            .toDouble(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      result.isNaN
                          ? 'Error'
                          : result.toString().endsWith('.0')
                              ? result.toStringAsFixed(0)
                              : result.toString(),
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: (80 - result.toString().length * 2)
                            .clamp(40, 80)
                            .toDouble(),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Buttons(
            onButtonTap: _onButtonTap,
          ),
        ],
      ),
    );
  }
}
