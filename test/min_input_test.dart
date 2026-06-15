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
  group('MinInput', () {
    testWidgets('renders placeholder text', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(placeholder: 'Enter text'),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          MinInput(onChanged: (v) => changed = v),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'hello');
      expect(changed, 'hello');
    });

    testWidgets('does not allow input when disabled', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          MinInput(enabled: false, onChanged: (v) => changed = v),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'hello');
      expect(changed, isNull);
    });

    testWidgets('does not allow input when readOnly', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          MinInput(readOnly: true, onChanged: (v) => changed = v),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'hello');
      expect(changed, isNull);
    });

    testWidgets('shows errorText when provided', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(errorText: 'Field required'),
        ),
      );

      expect(find.text('Field required'), findsOneWidget);
    });

    testWidgets('renders leading widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(leading: Icon(Icons.search)),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(trailing: Icon(Icons.clear)),
        ),
      );

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('renders all input types without error', (tester) async {
      for (final type in MinInputType.values) {
        await tester.pumpWidget(
          wrapInApp(
            MinInput(type: type),
          ),
        );

        expect(find.byType(MinInput), findsOneWidget);
      }
    });

    testWidgets('password type obscures text', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(type: MinInputType.password),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'secret');
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.obscureText, isTrue);
    });

    testWidgets('text type does not obscure text', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(type: MinInputType.text),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'hello');
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.obscureText, isFalse);
    });

    testWidgets('applies custom height constraint', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          const MinInput(height: 60),
        ),
      );

      expect(find.byType(MinInput), findsOneWidget);
    });

    testWidgets('renders with custom controller', (tester) async {
      final controller = TextEditingController(text: 'initial');

      await tester.pumpWidget(
        wrapInApp(
          MinInput(controller: controller),
        ),
      );

      expect(find.text('initial'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('calls onSubmitted when text is submitted', (tester) async {
      String? submitted;

      await tester.pumpWidget(
        wrapInApp(
          MinInput(onSubmitted: (v) => submitted = v),
        ),
      );

      await tester.enterText(find.byType(MinInput), 'done');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'done');
    });
  });
}
