import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('MinCheckbox', () {
    testWidgets('toggles value on tap', (tester) async {
      var value = false;

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) {
              return MinCheckbox(
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(MinCheckbox));
      expect(value, isTrue);

      await tester.pump();
      await tester.tap(find.byType(MinCheckbox));
      expect(value, isFalse);
    });

    testWidgets('does not toggle when disabled', (tester) async {
      var value = false;

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) {
              return MinCheckbox(
                value: value,
                disabled: true,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(MinCheckbox));
      expect(value, isFalse);
    });

    testWidgets('does not toggle when onChanged is null', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinCheckbox(value: false, onChanged: null),
        ),
      );

      // Should not throw
      await tester.tap(find.byType(MinCheckbox));
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinCheckboxSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinCheckbox(
              value: false,
              size: size,
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(MinCheckbox), findsOneWidget);
      }
    });

    testWidgets('custom checkIcon is shown when checked', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinCheckbox(
            value: true,
            onChanged: (_) {},
            checkIcon: const Icon(Icons.check),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
