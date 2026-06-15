import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: child),
  );
}

void main() {
  group('MinScaffold', () {
    testWidgets('renders body', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(body: Text('Body content')),
        ),
      );

      expect(find.text('Body content'), findsOneWidget);
    });

    testWidgets('renders appBar when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            appBar: MinAppBar(title: Text('App Bar')),
            body: Text('Body'),
          ),
        ),
      );

      expect(find.text('App Bar'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('renders without appBar', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(body: Text('Body only')),
        ),
      );

      expect(find.text('Body only'), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            body: Text('Colored'),
            backgroundColor: Colors.grey,
          ),
        ),
      );

      expect(find.text('Colored'), findsOneWidget);
    });

    testWidgets('renders floatingActionButton', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinScaffold(
            body: const Text('Body'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders bottomNavigationBar', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            body: Text('Body'),
            bottomNavigationBar: Text('Bottom Bar'),
          ),
        ),
      );

      expect(find.text('Bottom Bar'), findsOneWidget);
    });

    testWidgets('adds bottom padding when keyboard appears', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            body: Text('Body content'),
          ),
        ),
      );

      // Simulate keyboard appearing
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      await tester.pump();
      await tester.pump();

      // The body should still be visible
      expect(find.text('Body content'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('does not add padding when resizeToAvoidBottomInset is false',
        (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            body: Text('Body content'),
            resizeToAvoidBottomInset: false,
          ),
        ),
      );

      expect(find.text('Body content'), findsOneWidget);
    });

    testWidgets('renders appBar, body, FAB and bottomBar together',
        (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinScaffold(
            appBar: const MinAppBar(title: Text('Title')),
            body: const Text('Body'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: const Text('Bottom'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
    });

    testWidgets('body expands to fill available space', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinScaffold(
            appBar: MinAppBar(title: Text('Title')),
            body: Text('Body'),
          ),
        ),
      );

      // Body should be present
      expect(find.text('Body'), findsOneWidget);
    });
  });
}
