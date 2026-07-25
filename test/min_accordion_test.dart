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
  group('MinAccordion', () {
    testWidgets('renders all option headers', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header 1'),
              body: Text('Body 1'),
            ),
            MinAccordionOption(
              value: '2',
              header: Text('Header 2'),
              body: Text('Body 2'),
            ),
          ],
        ),
      ));

      expect(find.text('Header 1'), findsOneWidget);
      expect(find.text('Header 2'), findsOneWidget);
    });

    testWidgets('shows body when expanded', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header'),
              body: Text('Body'),
            ),
          ],
          value: {'1'},
        ),
      ));

      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('toggles on tap', (tester) async {
      Set<String>? selected;
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header'),
              body: Text('Body'),
            ),
          ],
          value: <String>{},
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Header'));
      expect(selected, {'1'});
    });

    testWidgets('collapses on second tap', (tester) async {
      Set<String>? selected;
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header'),
              body: Text('Body'),
            ),
          ],
          value: {'1'},
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Header'));
      expect(selected, <String>{});
    });

    testWidgets('multiple allows expanding several items', (tester) async {
      Set<String>? selected;
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header 1'),
              body: Text('Body 1'),
            ),
            MinAccordionOption(
              value: '2',
              header: Text('Header 2'),
              body: Text('Body 2'),
            ),
          ],
          multiple: true,
          value: {'1'},
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Header 2'));
      expect(selected, {'1', '2'});
    });

    testWidgets('does not toggle when disabled', (tester) async {
      Set<String>? selected;
      await tester.pumpWidget(wrapInApp(
        MinAccordion<String>(
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Header'),
              body: Text('Body'),
              disabled: true,
            ),
          ],
          value: <String>{},
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Header'));
      expect(selected, isNull);
    });
  });
}
