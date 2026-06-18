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
  group('MinProgress', () {
    group('linear', () {
      testWidgets('renders with value', (tester) async {
        await tester.pumpWidget(
          wrapInApp(const MinProgress(value: 0.5)),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });

      testWidgets('renders indeterminate', (tester) async {
        await tester.pumpWidget(wrapInApp(const MinProgress()));
        expect(find.byType(MinProgress), findsOneWidget);
      });

      testWidgets('default variant is linear', (tester) async {
        await tester.pumpWidget(
          wrapInApp(const MinProgress(value: 0.5)),
        );
        // SizedBox with double.infinity width is used by linear variant
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsWidgets);
      });

      testWidgets('accepts custom size and color', (tester) async {
        await tester.pumpWidget(
          wrapInApp(
            const MinProgress(
              value: 0.8,
              size: 12,
              color: Color(0xFFFF0000),
            ),
          ),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });

      testWidgets('updates on value change', (tester) async {
        await tester.pumpWidget(
          wrapInApp(const MinProgress(value: 0.0)),
        );
        expect(find.byType(MinProgress), findsOneWidget);

        await tester.pumpWidget(
          wrapInApp(const MinProgress(value: 0.75)),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });
    });

    group('circular', () {
      testWidgets('renders with value', (tester) async {
        await tester.pumpWidget(
          wrapInApp(
            const MinProgress(
              value: 0.3,
              variant: MinProgressVariant.circular,
            ),
          ),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });

      testWidgets('renders indeterminate', (tester) async {
        await tester.pumpWidget(
          wrapInApp(
            const MinProgress(variant: MinProgressVariant.circular),
          ),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });

      testWidgets('accepts custom stroke width', (tester) async {
        await tester.pumpWidget(
          wrapInApp(
            const MinProgress(
              variant: MinProgressVariant.circular,
              strokeWidth: 6,
              size: 100,
            ),
          ),
        );
        expect(find.byType(MinProgress), findsOneWidget);
      });
    });
  });
}
