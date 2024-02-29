import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/calculator.dart';

class Buttons extends StatelessWidget {
  final Function(String token) appendtoken;

  Buttons({super.key, required this.appendtoken});
  final Calculator calculator = Calculator();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[100],
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          itemCount: calculator.tokens.length,
          itemBuilder: (context, index) {
            bool isSign = calculator.isSign(calculator.tokens[index]);
            return GridTile(
              child: GestureDetector(
                onTap: () => appendtoken(calculator.tokens[index]),
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsetsDirectional.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(3, 0),
                      )
                    ],
                    color: isSign || calculator.tokens[index] == '='
                        ? Colors.blue[100]
                        : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      calculator.tokens[index],
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
        ),
      ),
    );
  }
}
