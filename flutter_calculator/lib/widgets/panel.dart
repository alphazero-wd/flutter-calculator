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
  void _appendtoken(String token) {
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
    setState(() {
      if (token == 'AC') {
        expression = '';
        result = 0;
      } else if (expression.isNotEmpty && token == 'CE') {
        bool endWithWhiteSpace = expression[expression.length - 1] == ' ';
        expression = expression.substring(
          0,
          expression.length - (endWithWhiteSpace ? 3 : 1),
        );
      } else {
        String whiteSpace = (expression.isNotEmpty && isSign) ? " " : "";
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
                        fontSize: (expression.length - 40)
                            .clamp(-40, -30)
                            .abs()
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
                        fontSize: (result.toString().length - 80)
                            .clamp(-80, -40)
                            .abs()
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
            appendtoken: _appendtoken,
          ),
        ],
      ),
    );
  }
}
