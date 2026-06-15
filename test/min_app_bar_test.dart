import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: Column(children: [child, const Expanded(child: SizedBox())]))),
  );
}

void main() {
  group('MinAppBar', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(title: Text('My Title')),
        ),
      );

      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('renders leading widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(
            title: Text('Title'),
            leading: Icon(Icons.menu),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(
            title: Text('Title'),
            trailing: Icon(Icons.settings),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders without title', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(leading: Icon(Icons.menu)),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('renders all sizes without error', (tester) async {
      for (final size in MinAppBarSize.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinAppBar(
              title: Text('Title $size'),
              size: size,
            ),
          ),
        );

        expect(find.text('Title $size'), findsOneWidget);
      }
    });

    testWidgets('centerTitle centers the title', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(
            title: Text('Centered'),
            centerTitle: true,
          ),
        ),
      );

      expect(find.text('Centered'), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinAppBar(
            title: Text('Colored'),
            backgroundColor: Colors.red,
          ),
        ),
      );

      expect(find.text('Colored'), findsOneWidget);
    });
  });
}
