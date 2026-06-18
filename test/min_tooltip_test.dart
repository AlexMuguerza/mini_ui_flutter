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
  group('MinTooltip', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinTooltip(
            message: 'Help text',
            child: Text('Hover me'),
          ),
        ),
      );
      expect(find.text('Hover me'), findsOneWidget);
    });

    testWidgets('tooltip message not visible by default', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinTooltip(
            message: 'Hidden message',
            child: Text('Target'),
          ),
        ),
      );
      expect(find.text('Hidden message'), findsNothing);
    });

    testWidgets('accepts custom side placement', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinTooltip(
            message: 'Above tooltip',
            side: MinUiAnchorSide.above(),
            child: Text('Target'),
          ),
        ),
      );
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('accepts zero delay for instant trigger', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinTooltip(
            message: 'Instant',
            delay: Duration.zero,
            child: Text('Target'),
          ),
        ),
      );
      expect(find.text('Target'), findsOneWidget);
    });

    testWidgets('accepts custom styling', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinTooltip(
            message: 'Styled',
            backgroundColor: Color(0xFF000000),
            padding: EdgeInsets.all(16),
            child: Text('Target'),
          ),
        ),
      );
      expect(find.text('Target'), findsOneWidget);
    });
  });
}
