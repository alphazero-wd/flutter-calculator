import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets/button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      "Button text should be displayed according to the token it receives",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Button(token: '×', onButtonTap: (String _) {})),
    );
    final buttonFinder = find.text('×');
    expect(buttonFinder, findsOne);
  });

  testWidgets("Button icon should be displayed if token is CE", (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Button(token: 'CE', onButtonTap: (String _) {})),
    );
    final buttonFinder = find.byIcon(Icons.cancel_presentation_outlined);
    expect(buttonFinder, findsOne);
    expect(find.text('CE'), findsNothing);
  });

  testWidgets("Button callback should be invoked when tapping on it",
      (tester) async {
    String tappedToken = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Button(
          token: '+',
          onButtonTap: (String token) {
            tappedToken = token;
          },
        ),
      ),
    );
    final buttonFinder = find.text('+');
    await tester.tap(buttonFinder);
    expect(tappedToken, '+');
  });
}
