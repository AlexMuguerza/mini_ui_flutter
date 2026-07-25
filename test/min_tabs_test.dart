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
  group('MinTabs', () {
    final options = const [
      MinTabsOption(value: 'tab1', label: Text('Tab 1')),
      MinTabsOption(value: 'tab2', label: Text('Tab 2')),
      MinTabsOption(value: 'tab3', label: Text('Tab 3')),
    ];

    testWidgets('renders all option labels', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          options: options,
          value: 'tab1',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('calls onChanged when tab is tapped', (tester) async {
      String? selected = 'tab1';
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          options: options,
          value: selected,
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Tab 2'));
      expect(selected, 'tab2');
    });

    testWidgets('renders with pill variant', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          options: options,
          value: 'tab1',
          onChanged: (_) {},
          variant: MinTabsVariant.pill,
        ),
      ));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinTabsSize.values) {
        await tester.pumpWidget(wrapInApp(
          MinTabs<String>(
            options: options,
            value: 'tab1',
            onChanged: (_) {},
            size: size,
          ),
        ));
        expect(find.text('Tab 1'), findsOneWidget);
      }
    });

    testWidgets('does not call onChanged for disabled tab', (tester) async {
      String? selected = 'tab1';
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          options: [
            const MinTabsOption(value: 'tab1', label: Text('Tab 1')),
            const MinTabsOption(
              value: 'tab2',
              label: Text('Tab 2'),
              disabled: true,
            ),
          ],
          value: selected,
          onChanged: (v) => selected = v,
        ),
      ));

      await tester.tap(find.text('Tab 2'));
      expect(selected, 'tab1');
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          options: const [
            MinTabsOption(
              value: 'tab1',
              label: Text('Tab 1'),
              icon: Icon(Icons.star),
            ),
          ],
          value: 'tab1',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders scrollable without error', (tester) async {
      await tester.pumpWidget(wrapInApp(
        MinTabs<String>(
          scrollable: true,
          options: options,
          value: 'tab1',
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });
  });
}
