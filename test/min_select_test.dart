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
  group('MinSelect', () {
    testWidgets('renders placeholder when no value selected', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: selected,
            onChanged: (v) => selected = v,
            placeholder: 'Choose one',
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      expect(find.text('Choose one'), findsOneWidget);
    });

    testWidgets('renders selected option label', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: 'b',
            onChanged: (_) {},
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('opens dropdown on tap', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: selected,
            onChanged: (v) => selected = v,
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsWidgets);
      expect(find.text('Beta'), findsWidgets);
    });

    testWidgets('calls onChanged when option is tapped', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: selected,
            onChanged: (v) => selected = v,
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(selected, 'b');
    });

    testWidgets('closes dropdown after selecting an option', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) {
              return MinSelect<String>(
                value: selected,
                onChanged: (v) => setState(() => selected = v),
                options: const [
                  MinSelectOption(value: 'a', label: 'Alpha'),
                  MinSelectOption(value: 'b', label: 'Beta'),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      // Dropdown should close — only the trigger label remains
      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('shows checkmark for selected option', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: 'a',
            onChanged: (_) {},
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      // The selected option tile should show a checkmark
      expect(find.text('✓'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            disabled: true,
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      // Dropdown should not open — "Alpha" should not appear at all
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('does not call onChanged for disabled option', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: selected,
            onChanged: (v) => selected = v,
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha', enabled: false),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      expect(selected, isNull);
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinSelectSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinSelect<String>(
              value: null,
              onChanged: (_) {},
              size: size,
              options: const [
                MinSelectOption(value: 'a', label: 'Alpha'),
              ],
            ),
          ),
        );

        expect(find.text('Select...'), findsOneWidget);
      }
    });

    testWidgets('shows leading widget in trigger', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: 'a',
            onChanged: (_) {},
            options: const [
              MinSelectOption(
                value: 'a',
                label: 'Alpha',
                leading: Icon(Icons.star),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('shows leading and trailing in option tiles', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            options: const [
              MinSelectOption(
                value: 'a',
                label: 'Alpha',
                leading: Icon(Icons.star),
                trailing: Icon(Icons.info),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsWidgets);
      expect(find.byIcon(Icons.info), findsWidgets);
    });

    testWidgets('shows section headers in dropdown', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            options: const [
              MinSelectSection(label: 'Group 1'),
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectSection(label: 'Group 2'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      expect(find.text('Group 1'), findsOneWidget);
      expect(find.text('Group 2'), findsOneWidget);
    });

    testWidgets('searchable shows search input', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            searchable: true,
            searchPlaceholder: 'Search...',
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('default placeholder is Select...', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
            ],
          ),
        ),
      );

      expect(find.text('Select...'), findsOneWidget);
    });

    testWidgets('renders with pre-selected value', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: 'b',
            onChanged: (_) {},
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Select...'), findsNothing);
    });

    testWidgets('multiple selects have independent state', (tester) async {
      String? val1;
      String? val2;

      await tester.pumpWidget(
        wrapInApp(
          Column(
            children: [
              MinSelect<String>(
                value: val1,
                onChanged: (v) => val1 = v,
                options: const [
                  MinSelectOption(value: 'a', label: 'Alpha'),
                ],
              ),
              MinSelect<String>(
                value: val2,
                onChanged: (v) => val2 = v,
                options: const [
                  MinSelectOption(value: 'x', label: 'X-Ray'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Select...'), findsNWidgets(2));

      // Select in first dropdown
      await tester.tap(find.text('Select...').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      expect(val1, 'a');
      expect(val2, isNull);
    });

    testWidgets('searchable filters options as user types', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: selected,
            onChanged: (v) => selected = v,
            searchable: true,
            searchPlaceholder: 'Search...',
            options: const [
              MinSelectOption(value: 'mx', label: 'México'),
              MinSelectOption(value: 'ar', label: 'Argentina'),
              MinSelectOption(value: 'co', label: 'Colombia'),
              MinSelectOption(value: 'cl', label: 'Chile'),
            ],
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      // All 4 options visible
      expect(find.text('México'), findsWidgets);
      expect(find.text('Argentina'), findsWidgets);
      expect(find.text('Colombia'), findsWidgets);
      expect(find.text('Chile'), findsWidgets);

      // Tap the EditableText to focus, then type
      final searchField = find.byType(EditableText);
      await tester.tap(searchField);
      await tester.enterText(searchField, 'col');
      await tester.pumpAndSettle();

      // Only "Colombia" should remain
      expect(find.text('Colombia'), findsWidgets);
      expect(find.text('México'), findsNothing);
      expect(find.text('Argentina'), findsNothing);
      expect(find.text('Chile'), findsNothing);
    });

    testWidgets('searchable selects filtered option', (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapInApp(
          StatefulBuilder(
            builder: (context, setState) {
              return MinSelect<String>(
                value: selected,
                onChanged: (v) => setState(() => selected = v),
                searchable: true,
                options: const [
                  MinSelectOption(value: 'mx', label: 'México'),
                  MinSelectOption(value: 'ar', label: 'Argentina'),
                  MinSelectOption(value: 'co', label: 'Colombia'),
                ],
              );
            },
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      // Tap the EditableText to focus, then type "arg" to filter
      final searchField = find.byType(EditableText);
      await tester.tap(searchField);
      await tester.enterText(searchField, 'arg');
      await tester.pumpAndSettle();

      // Only Argentina visible
      expect(find.text('Argentina'), findsWidgets);
      expect(find.text('México'), findsNothing);
      expect(find.text('Colombia'), findsNothing);

      // Select the filtered option
      await tester.tap(find.text('Argentina'));
      await tester.pumpAndSettle();

      expect(selected, 'ar');
    });

    testWidgets('clearing search restores all options', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinSelect<String>(
            value: null,
            onChanged: (_) {},
            searchable: true,
            options: const [
              MinSelectOption(value: 'a', label: 'Alpha'),
              MinSelectOption(value: 'b', label: 'Beta'),
              MinSelectOption(value: 'c', label: 'Charlie'),
            ],
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(MinSelect<String>));
      await tester.pumpAndSettle();

      // Tap the EditableText to focus, then type "al" to filter
      final searchField = find.byType(EditableText);
      await tester.tap(searchField);
      await tester.enterText(searchField, 'al');
      await tester.pumpAndSettle();

      // Only Alpha visible
      expect(find.text('Alpha'), findsWidgets);
      expect(find.text('Beta'), findsNothing);
      expect(find.text('Charlie'), findsNothing);

      // Clear search
      await tester.enterText(searchField, '');
      await tester.pumpAndSettle();

      // All options restored
      expect(find.text('Alpha'), findsWidgets);
      expect(find.text('Beta'), findsWidgets);
      expect(find.text('Charlie'), findsWidgets);
    });
  });
}
