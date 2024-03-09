import 'package:flutter/material.dart';
import 'package:flutter_calculator/data/tokens.dart';
import 'package:flutter_calculator/widgets/button.dart';

class Buttons extends StatelessWidget {
  final Function(String token) onButtonTap;

  const Buttons({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tokens.length,
        itemBuilder: (context, index) => Button(
          key: Key(tokens[index]),
          token: tokens[index],
          onButtonTap: onButtonTap,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
