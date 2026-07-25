import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ui_flutter/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('MinBadge', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrapInApp(const MinBadge(label: Text('Nuevo'))));

      expect(find.text('Nuevo'), findsOneWidget);
    });

    testWidgets('renders all variants without error', (tester) async {
      for (final variant in MinBadgeVariant.values) {
        await tester.pumpWidget(wrapInApp(
          MinBadge(label: const Text('Badge'), variant: variant),
        ));
        expect(find.text('Badge'), findsOneWidget);
      }
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const MinBadge(
          label: Text('Con icono'),
          icon: Icon(Icons.star),
        ),
      ));

      expect(find.text('Con icono'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('uses custom decoration over variant defaults', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const MinBadge(
          label: Text('Custom'),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.purple);
      expect(decoration.borderRadius,
          const BorderRadius.all(Radius.circular(4)));
    });
  });

  group('MinBadgeWrapper', () {
    testWidgets('renders child and badge', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const MinBadgeWrapper(
          label: Text('3'),
          child: Text('Child'),
        ),
      ));

      expect(find.text('Child'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('passes decoration to internal MinBadge', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const MinBadgeWrapper(
          label: Text('Deco'),
          badgeDecoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Text('Child'),
        ),
      ));

      final containers = tester.widgetList<Container>(find.byType(Container));
      final badgeContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == Colors.orange,
      );
      expect(badgeContainer, isNotNull);
    });
  });
}
