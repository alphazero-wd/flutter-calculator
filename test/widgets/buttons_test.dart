import 'package:flutter/material.dart';
import 'package:flutter_calculator/data/tokens.dart';
import 'package:flutter_calculator/widgets/buttons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Buttons should render all token buttons', (tester) async {
    await tester.binding.setSurfaceSize(const Size(2400, 1080));
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Column(
          children: [
            Expanded(
              child: Buttons(
                onButtonTap: (String _) {},
              ),
            )
          ],
        ),
      ),
    );
    for (final String token in tokens) {
      if (token == 'CE') {
        final clearEntryIconButtonFinder =
            find.byIcon(Icons.cancel_presentation_outlined);
        expect(clearEntryIconButtonFinder, findsOne);
      } else {
        // Scroll until the item to be found appears.
        final tokenButtonFinder = find.text(token);
        expect(tokenButtonFinder, findsOne);
      }
    }
  });

  testWidgets('Each button within should trigger tap callback', (tester) async {
    await tester.binding.setSurfaceSize(const Size(2400, 1080));
    // Create the widget by telling the tester to build it.
    String tappedToken = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Column(
          children: [
            Expanded(
              child: Buttons(
                onButtonTap: (String token) {
                  tappedToken = token;
                },
              ),
            )
          ],
        ),
      ),
    );
    for (final String token in tokens) {
      if (token == 'CE') {
        final clearEntryIconButtonFinder =
            find.byIcon(Icons.cancel_presentation_outlined);
        await tester.ensureVisible(clearEntryIconButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(clearEntryIconButtonFinder);
      } else {
        final tokenButtonFinder = find.text(token);
        await tester.ensureVisible(tokenButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(tokenButtonFinder);
      }
      expect(tappedToken, token);
    }
  });
}
