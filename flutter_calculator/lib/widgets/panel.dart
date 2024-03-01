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
  void _onButtonTap(String token) {
    if (token == '=') {
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
    bool isSign = calculator.isSign(token);
    if (isSign &&
        expression.isNotEmpty &&
        expression[expression.length - 1] == ' ') {
      return;
    }
    bool cannotPutOperatorAfter =
        (expression.isEmpty || expression[expression.length - 1] == '(');
    if (cannotPutOperatorAfter && isSign && token != '-') {
      return;
    }
    setState(() {
      if (token == 'AC') {
        expression = '';
        result = 0;
      } else if (token == '()') {
        bool isParenthesisClosed =
            calculator.checkUnclosedParenthesis(expression);
        expression += isParenthesisClosed ? '(' : ')';
      } else if (expression.isNotEmpty && token == 'CE') {
        bool endWithWhiteSpace = expression[expression.length - 1] == ' ';
        expression = expression.substring(
          0,
          expression.length - (endWithWhiteSpace ? 3 : 1),
        );
      } else {
        String whiteSpace = (!cannotPutOperatorAfter && isSign) ? " " : "";
        expression += whiteSpace + token + whiteSpace;
      }
    });
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
