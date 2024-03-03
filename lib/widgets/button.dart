import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/checker.dart';

class Button extends StatelessWidget {
  final String token;
  final Function(String token) onButtonTap;
  const Button({super.key, required this.token, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () => onButtonTap(token),
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
            color: checkIsOperator(token) || token == '='
                ? Colors.blue[100]
                : Colors.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: token == 'CE'
                ? const Icon(
                    Icons.cancel_presentation_outlined,
                    size: 30,
                  )
                : Text(
                    token,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
