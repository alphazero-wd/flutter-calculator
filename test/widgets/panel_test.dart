import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets/panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Panel displays an expression and result correctly',
      (tester) async {
    // Create the widget by telling the tester to build it.
    const String expression = '((3.14 + 8%%) × (-5% - 3.92)) + 5.61 ÷ 3';
    const double result = -10.598976;
    await tester.pumpWidget(
      const MaterialApp(home: Panel(expression: expression, result: result)),
    );

    final expressionFinder = find.text(expression);
    final resultFinder = find.text(result.toString());

    expect(expressionFinder, findsOneWidget);
    expect(resultFinder, findsOneWidget);
  });

  testWidgets("Panel truncates the .0 in the result if it's an integer",
      (tester) async {
    // Create the widget by telling the tester to build it.
    const double result = -23.0;
    await tester.pumpWidget(
      const MaterialApp(home: Panel(expression: '', result: result)),
    );

    final resultFinder = find.text('-23');

    expect(resultFinder, findsOne);
  });

  testWidgets(
      'Panel should show Error if the result is Infinity (zero division)',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      const MaterialApp(home: Panel(expression: '', result: double.infinity)),
    );

    final resultFinder = find.text('Error');

    expect(resultFinder, findsOne);
  });

  testWidgets(
      'Panel should show Error if the result is not a number (invalid expression)',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      const MaterialApp(home: Panel(expression: '', result: double.nan)),
    );

    final resultFinder = find.text('Error');

    expect(resultFinder, findsOne);
  });
}
