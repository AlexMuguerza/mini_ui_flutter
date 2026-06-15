import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: Center(child: child))),
  );
}

void main() {
  group('MinSwitch', () {
    testWidgets('toggles value on tap', (tester) async {
      var value = false;

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) {
              return MinSwitch(
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(MinSwitch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinSwitchSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinSwitch(
              value: false,
              size: size,
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(MinSwitch), findsOneWidget);
      }
    });

    testWidgets('accepts tap when enabled', (tester) async {
      var changed = false;

      await tester.pumpWidget(
        wrapInApp(
          MinSwitch(
            value: false,
            onChanged: (_) => changed = true,
          ),
        ),
      );

      await tester.tap(find.byType(MinSwitch));
      await tester.pumpAndSettle();
      expect(changed, isTrue);
    });
  });
}
