import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final String expression;
  final double result;
  const Panel({super.key, required this.expression, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            expression,
            key: const Key('expression'),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: (40 - expression.length * 2).clamp(30, 40).toDouble(),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            key: const Key('result'),
            (result.isNaN || result.isInfinite)
                ? 'Error'
                : result.toString().endsWith('.0')
                    ? result.toStringAsFixed(0)
                    : result.toString(),
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: (80 - result.toString().length * 2).clamp(40, 80).toDouble(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
