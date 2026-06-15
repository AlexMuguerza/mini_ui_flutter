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
  group('MinButton', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButton(onPressed: () {}, child: const Text('Click me')),
        ),
      );

      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () => tapped = true,
            child: const Text('Tap'),
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () => tapped = true,
            disabled: true,
            child: const Text('Disabled'),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });

    testWidgets('does not call onPressed when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinButton(onPressed: null, child: Text('No action')),
        ),
      );

      // Should not throw
      await tester.tap(find.text('No action'));
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () => tapped = true,
            loading: true,
            child: const Text('Loading'),
          ),
        ),
      );

      await tester.tap(find.text('Loading'));
      expect(tapped, isFalse);
    });

    testWidgets('shows leading widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () {},
            leading: const Icon(Icons.add),
            child: const Text('With leading'),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows trailing widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () {},
            trailing: const Icon(Icons.arrow_forward),
            child: const Text('With trailing'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('does not show leading when loading', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButton(
            onPressed: () {},
            loading: true,
            leading: const Icon(Icons.add),
            child: const Text('Loading'),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('renders all variants without error', (tester) async {
      for (final variant in MinButtonVariant.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinButton(
              onPressed: () {},
              variant: variant,
              child: Text('Button $variant'),
            ),
          ),
        );

        expect(find.text('Button $variant'), findsOneWidget);
      }
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinButtonSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinButton(
              onPressed: () {},
              size: size,
              child: Text('Button $size'),
            ),
          ),
        );

        expect(find.text('Button $size'), findsOneWidget);
      }
    });
  });
}
