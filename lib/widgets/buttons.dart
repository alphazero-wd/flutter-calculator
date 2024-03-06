import 'package:flutter/material.dart';
import 'package:flutter_calculator/data/tokens.dart';
import 'package:flutter_calculator/widgets/button.dart';

class Buttons extends StatelessWidget {
  final Function(String token) onButtonTap;

  const Buttons({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: Button(token: tokens[index], onButtonTap: onButtonTap),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
    );
  }
}
