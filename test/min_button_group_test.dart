import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ui_flutter/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

enum TestColor { red, green, blue }

void main() {
  group('MinButtonGroup', () {
    testWidgets('renders all option labels', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green),
              MinButtonGroupOption(value: TestColor.blue),
            ],
            value: null,
            onChanged: (_) {},
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      expect(find.text('red'), findsOneWidget);
      expect(find.text('green'), findsOneWidget);
      expect(find.text('blue'), findsOneWidget);
    });

    testWidgets('calls onChanged when option is tapped', (tester) async {
      TestColor? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green),
              MinButtonGroupOption(value: TestColor.blue),
            ],
            value: selected,
            onChanged: (c) => selected = c,
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      await tester.tap(find.text('green'));
      expect(selected, TestColor.green);
    });

    testWidgets('does not call onChanged for disabled option', (tester) async {
      TestColor? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green, enabled: false),
              MinButtonGroupOption(value: TestColor.blue),
            ],
            value: selected,
            onChanged: (c) => selected = c,
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      await tester.tap(find.text('green'));
      expect(selected, isNull);
    });

    testWidgets('renders in vertical direction', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            direction: Axis.vertical,
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green),
            ],
            value: null,
            onChanged: (_) {},
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      expect(find.text('red'), findsOneWidget);
      expect(find.text('green'), findsOneWidget);
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinButtonSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinButtonGroup<TestColor>(
              size: size,
              options: const [
                MinButtonGroupOption(value: TestColor.red),
                MinButtonGroupOption(value: TestColor.green),
              ],
              value: null,
              onChanged: (_) {},
              labelBuilder: (c) => Text(c.name),
            ),
          ),
        );

        expect(find.text('red'), findsOneWidget);
      }
    });

    testWidgets('renders all variants without error', (tester) async {
      for (final variant in MinButtonVariant.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinButtonGroup<TestColor>(
              variant: variant,
              options: const [
                MinButtonGroupOption(value: TestColor.red),
                MinButtonGroupOption(value: TestColor.green),
              ],
              value: null,
              onChanged: (_) {},
              labelBuilder: (c) => Text(c.name),
            ),
          ),
        );

        expect(find.text('red'), findsOneWidget);
      }
    });

    testWidgets('no selection when value is null', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green),
            ],
            value: null,
            onChanged: (_) {},
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      expect(find.text('red'), findsOneWidget);
      expect(find.text('green'), findsOneWidget);
    });

    testWidgets('tapping same option triggers onChanged', (tester) async {
      TestColor? selected = TestColor.red;

      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<TestColor>(
            options: const [
              MinButtonGroupOption(value: TestColor.red),
              MinButtonGroupOption(value: TestColor.green),
            ],
            value: selected,
            onChanged: (c) => selected = c,
            labelBuilder: (c) => Text(c.name),
          ),
        ),
      );

      await tester.tap(find.text('red'));
      expect(selected, TestColor.red);
    });

    testWidgets('works with String type', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<String>(
            options: const [
              MinButtonGroupOption(value: 'left'),
              MinButtonGroupOption(value: 'center'),
              MinButtonGroupOption(value: 'right'),
            ],
            value: selected,
            onChanged: (v) => selected = v,
            labelBuilder: (v) => Text(v),
          ),
        ),
      );

      await tester.tap(find.text('center'));
      expect(selected, 'center');
    });

    testWidgets('works with int type', (tester) async {
      int? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinButtonGroup<int>(
            options: const [
              MinButtonGroupOption(value: 1),
              MinButtonGroupOption(value: 2),
              MinButtonGroupOption(value: 3),
            ],
            value: selected,
            onChanged: (v) => selected = v,
            labelBuilder: (v) => Text('$v'),
          ),
        ),
      );

      await tester.tap(find.text('3'));
      expect(selected, 3);
    });
  });
}
