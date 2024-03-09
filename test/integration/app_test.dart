import 'package:flutter/material.dart';
import 'package:flutter_calculator/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('basic calculations', () {
    testWidgets('should display the expression according to what is tapped', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;

      expect(expression.data, '');

      await tester.tap(find.byKey(const Key('3')));
      await tester.pumpAndSettle();
      expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '3');

      await tester.tap(find.byKey(const Key('+')));
      await tester.pumpAndSettle();
      expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '3 + ');

      await tester.tap(find.byKey(const Key('5')));
      await tester.pumpAndSettle();
      expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '3 + 5');
    });

    testWidgets('should perform a calculation successfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '0');

      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(result.data, '8');
      expect(expression.data, '8');
    });

    testWidgets("should chain answer onto expression when result is calculated", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('8')));
      await tester.tap(find.byKey(const Key('-')));
      await tester.tap(find.byKey(const Key('9')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();

      expect(find.text('-1'), findsExactly(2));
      await tester.tap(find.byKey(const Key('÷')));
      await tester.tap(find.byKey(const Key('2')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      expect(find.text('-0.5'), findsExactly(2));
    });
  });

  group('test rounding results', () {
    testWidgets("should remove .0 for integers", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('-')));
      await tester.tap(find.byKey(const Key('4')));
      await tester.tap(find.byKey(const Key('0')));
      await tester.tap(find.byKey(const Key('÷')));
      await tester.tap(find.byKey(const Key('2')));
      await tester.tap(find.byKey(const Key('0')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      expect(find.text('-2'), findsExactly(2)); // expression + result
      expect(find.text('-2.0'), findsNothing);
    });

    testWidgets("should still show the decimal portions if the result is a decimal number", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('-')));
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('0')));
      await tester.tap(find.byKey(const Key('÷')));
      await tester.tap(find.byKey(const Key('2')));
      await tester.tap(find.byKey(const Key('0')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      expect(find.text('-1.5'), findsExactly(2));
      expect(find.text('-1'), findsNothing);
    });
  });

  group('test percent sign', () {
    testWidgets('should not allow to add percent there is no preceding operand', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('%')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '');
    });

    testWidgets('should allow multiple percent signs to chain after an operand', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('8')));
      await tester.tap(find.byKey(const Key('%')));
      await tester.tap(find.byKey(const Key('%')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '8%%');
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      Text result = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(result.data, '0.0008');
    });
  });

  group('test decimal sign', () {
    testWidgets('should not allow to add decimal point if there is already a preceding decimal point', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.pumpAndSettle();
      expect(find.text('3.'), findsOne);
    });

    testWidgets('should not allow to add decimal point if current number is already a decimal point', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('8')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '8.3');
    });

    testWidgets("should add 0. if the decimal point is added without a preceding number", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('.')));
      await tester.tap(find.byKey(const Key('1')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.tap(find.byKey(const Key('2')));
      await tester.pumpAndSettle();
      expect(find.text('0.1 + 0.2'), findsOne);
    });
  });

  group('test operators', () {
    testWidgets('should treat - as both an unary and binary operator', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      final minusSignButton = find.byKey(const Key('-'));
      await tester.tap(minusSignButton);
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(minusSignButton);
      await tester.tap(minusSignButton);
      await tester.tap(find.byKey(const Key('5')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '-3 - -5');

      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();

      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '2');
    });

    testWidgets("however, double negation is not allowed", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      final minusSignButton = find.byKey(const Key('-'));
      await tester.tap(minusSignButton);
      await tester.tap(minusSignButton);
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '-');
    });

    testWidgets('should not treat other operators as unary', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      List<String> symbols = ['+', '×', '÷'];
      for (final String symbol in symbols) {
        await tester.tap(find.byKey(Key(symbol)));
        await tester.pumpAndSettle();
        Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
        expect(expression.data, '');
      }

      for (final String symbol in symbols) {
        await tester.tap(find.byKey(const Key('CE')));
        await tester.tap(find.byKey(const Key('()')));
        await tester.tap(find.byKey(Key(symbol)));
        await tester.pumpAndSettle();
        Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
        expect(expression.data, '(');
      }
    });

    testWidgets('should treat other operators as binary only', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      List<String> symbols = ['+', '×', '÷'];
      for (final String symbol in symbols) {
        await tester.tap(find.byKey(const Key('AC')));
        await tester.tap(find.byKey(const Key('3')));
        await tester.tap(find.byKey(Key(symbol)));
        await tester.tap(find.byKey(const Key('8')));
        await tester.pumpAndSettle();
        Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
        expect(expression.data, '3 $symbol 8');
      }
    });
  });

  group('invalid expression handler', () {
    testWidgets('should show Error in the result if divided by 0', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('1')));
      await tester.tap(find.byKey(const Key('÷')));
      await tester.tap(find.byKey(const Key('0')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOne);
    });

    testWidgets('should compute normally if missing open parenthesis', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(find.byKey(const Key('()')));
      await tester.pumpAndSettle();
      expect(find.text('3 + 5)'), findsOne);
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '8');
    });

    testWidgets('should compute normally if missing close parenthesis', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('()')));
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.pumpAndSettle();
      expect(find.text('(3 + 5'), findsOne);
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '8');
    });

    testWidgets('should compute normally if no operand after an operator', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.pumpAndSettle();
      expect(find.text('3 + '), findsOne);
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '3');
    });

    testWidgets('should compute normally if no number after decimal point', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('.')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.pumpAndSettle();
      expect(find.text('3. + '), findsOne);
      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '3');
    });
  });

  group('special buttons testing', () {
    testWidgets("AC should clear the expression", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(find.byKey(const Key('AC')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '');
    });

    testWidgets("AC should clear the expression and set the result to 0", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(find.byKey(const Key('=')));
      await tester.tap(find.byKey(const Key('AC')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(expression.data, '');
      expect(result.data, '0');
    });

    testWidgets("CE should do nothing if the expression is empty", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('CE')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '');
    });

    testWidgets("CE should remove the last token or the white space and the operator altogether", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(find.byKey(const Key('CE')));
      await tester.pumpAndSettle();
      expect(find.text('3 + '), findsOne);
      await tester.tap(find.byKey(const Key('CE')));
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '3');
    });
  });

  group("test with complex expressions", () {
    testWidgets("should open and close parentheses accordingly", (tester) async {
      await tester.binding.setSurfaceSize(const Size(1020, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const App());
      final parenthesesButton = find.byKey(const Key('()'));
      await tester.tap(parenthesesButton);
      await tester.tap(parenthesesButton);
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('5')));
      await tester.tap(parenthesesButton);
      await tester.tap(find.byKey(const Key('×')));
      await tester.tap(find.byKey(const Key('9')));
      await tester.tap(parenthesesButton);
      await tester.tap(find.byKey(const Key('÷')));
      await tester.tap(parenthesesButton);
      await tester.tap(find.byKey(const Key('-')));
      await tester.tap(find.byKey(const Key('7')));
      await tester.tap(find.byKey(const Key('+')));
      await tester.tap(find.byKey(const Key('3')));
      await tester.tap(parenthesesButton);
      await tester.pumpAndSettle();
      Text expression = find.byKey(const Key('expression')).evaluate().single.widget as Text;
      expect(expression.data, '((3 + 5) × 9) ÷ (-7 + 3)');

      await tester.tap(find.byKey(const Key('=')));
      await tester.pumpAndSettle();

      Text result = find.byKey(const Key('result')).evaluate().single.widget as Text;
      expect(result.data, '-18');
    });
  });
}
