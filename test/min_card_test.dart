import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('MinCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinCard(child: Text('Card content')),
        ),
      );

      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('has card background by default', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinCard(child: SizedBox()),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );

      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.color, equals(MinColors.light.card));
    });

    testWidgets('uses custom backgroundColor when provided', (tester) async {
      const customColor = Color(0xFFFF0000);

      await tester.pumpWidget(
        wrapInApp(
          const MinCard(backgroundColor: customColor, child: SizedBox()),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );

      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.color, equals(customColor));
    });

    testWidgets('has default padding from theme spacing.s4', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinCard(child: Text('Content')),
        ),
      );

      final paddingWidget = tester.widget<Padding>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(Padding),
        ),
      );

      final theme = MinThemeData.light();
      expect(paddingWidget.padding, equals(EdgeInsets.all(theme.spacing.s4)));
    });

    testWidgets('applies custom padding when provided', (tester) async {
      const padding = EdgeInsets.all(24);

      await tester.pumpWidget(
        wrapInApp(
          const MinCard(
            padding: padding,
            child: Text('Padded'),
          ),
        ),
      );

      final paddingWidget = tester.widget<Padding>(
        find.ancestor(
          of: find.text('Padded'),
          matching: find.byType(Padding),
        ),
      );

      expect(paddingWidget.padding, equals(padding));
    });

    testWidgets('applies margin when provided', (tester) async {
      const margin = EdgeInsets.all(12);

      await tester.pumpWidget(
        wrapInApp(
          const MinCard(
            margin: margin,
            child: Text('With margin'),
          ),
        ),
      );

      // The margin wraps the entire card in a Padding widget.
      // Find the Padding that is NOT an ancestor of the text's inner padding
      // but rather wraps the DecoratedBox.
      final paddingWidgets = tester.widgetList<Padding>(
        find.byType(Padding),
      );

      expect(paddingWidgets.any((p) => p.padding == margin), isTrue);
    });

    testWidgets('applies custom border radius', (tester) async {
      final customRadius = BorderRadius.circular(20);

      await tester.pumpWidget(
        wrapInApp(
          MinCard(
            borderRadius: customRadius,
            child: const SizedBox(),
          ),
        ),
      );

      final clipRect = tester.widget<ClipRRect>(
        find.byType(ClipRRect),
      );

      expect(clipRect.borderRadius, equals(customRadius));
    });
  });
}
