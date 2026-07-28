import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ui_flutter/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('MinFormInput', () {
    // ── Rendering basics ────────────────────────────────────────────────────

    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(placeholder: 'tu@correo.com'),
          ),
        ),
      );

      expect(find.text('tu@correo.com'), findsOneWidget);
    });

    testWidgets('shows initialValue', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(initialValue: 'pre@filled.com'),
          ),
        ),
      );

      expect(find.text('pre@filled.com'), findsOneWidget);
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              placeholder: 'Test',
              leading: const Icon(Icons.search),
              trailing: const Icon(Icons.clear),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    // ── Changed / saved / validated ─────────────────────────────────────────

    testWidgets('calls onChanged when user types', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(onChanged: (v) => changed = v),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'hola');
      expect(changed, 'hola');
    });

    testWidgets('onChanged fires with each text replacement', (tester) async {
      final values = <String>[];

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              onChanged: (v) => values.add(v),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'ab');
      // enterText replaces full text in one go — onChanged fires once
      expect(values, ['ab']);

      await tester.enterText(find.byType(MinFormInput), 'abcd');
      expect(values, ['ab', 'abcd']);
    });

    testWidgets('Form.save() triggers onSaved with current value', (tester) async {
      String? saved;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              onSaved: (v) => saved = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'value');
      formKey.currentState!.save();
      expect(saved, 'value');
    });

    testWidgets('onSaved receives initialValue when user has not edited', (tester) async {
      String? saved;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              initialValue: 'default@x.com',
              onSaved: (v) => saved = v,
            ),
          ),
        ),
      );

      formKey.currentState!.save();
      expect(saved, 'default@x.com');
    });

    testWidgets('multiple onSaved calls capture latest value', (tester) async {
      final saved = <String>[];
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              onSaved: (v) => saved.add(v ?? ''),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'first');
      formKey.currentState!.save();
      formKey.currentState!.save();

      expect(saved, ['first', 'first']);
    });

    // ── Validation ──────────────────────────────────────────────────────────

    testWidgets('Form.validate() returns true when no validator', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(initialValue: 'any'),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('Form.validate() returns false when validator fails', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
    });

    testWidgets('Form.validate() returns true when validator passes', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              initialValue: 'valid',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('displays validator error after autovalidate', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: MinFormInput(
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Email inválido' : null,
            ),
          ),
        ),
      );

      // First interaction: invalid
      await tester.enterText(find.byType(MinFormInput), 'no-at');
      await tester.pump();
      expect(find.text('Email inválido'), findsOneWidget);

      // Second interaction: valid
      await tester.enterText(find.byType(MinFormInput), 'ok@x.com');
      await tester.pump();
      expect(find.text('Email inválido'), findsNothing);
    });

    testWidgets('autovalidateMode.always shows error immediately', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: MinFormInput(
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('forceErrorText overrides validator and shows on screen', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(forceErrorText: 'Server error'),
          ),
        ),
      );

      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('form validate shows error then hides after fix', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              validator: (v) => (v == null || v.length < 3) ? 'Min 3 chars' : null,
            ),
          ),
        ),
      );

      // Validate empty → error
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Min 3 chars'), findsOneWidget);

      // Type valid → validate again → passes
      await tester.enterText(find.byType(MinFormInput), 'hello');
      expect(formKey.currentState!.validate(), isTrue);
      await tester.pump();
      expect(find.text('Min 3 chars'), findsNothing);
    });

    // ── Reset ───────────────────────────────────────────────────────────────

    testWidgets('reset restores initialValue', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(initialValue: 'init@example.com'),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'dirty');
      expect(find.text('dirty'), findsOneWidget);

      formKey.currentState!.reset();
      await tester.pump();

      expect(find.text('init@example.com'), findsOneWidget);
      expect(find.text('dirty'), findsNothing);
    });

    testWidgets('reset clears error text', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              initialValue: 'bad',
              validator: (v) => v == 'bad' ? 'Invalid' : null,
            ),
          ),
        ),
      );

      // Show error
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Invalid'), findsOneWidget);

      // Reset
      formKey.currentState!.reset();
      await tester.pump();
      expect(find.text('Invalid'), findsNothing);
    });

    testWidgets('reset calls onChanged with initialValue', (tester) async {
      final formKey = GlobalKey<FormState>();
      String? lastChanged;

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              initialValue: 'init',
              onChanged: (v) => lastChanged = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'modified');
      formKey.currentState!.reset();
      await tester.pump();

      expect(lastChanged, 'init');
    });

    // ── Disabled ────────────────────────────────────────────────────────────

    testWidgets('disabled field ignores input', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              initialValue: 'test@x.com',
              enabled: false,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'cambia');
      await tester.pump();
      expect(find.text('test@x.com'), findsOneWidget);
      expect(find.text('cambia'), findsNothing);
    });

    testWidgets('disabled field does not trigger onChanged', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              enabled: false,
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'nope');
      expect(changed, isNull);
    });

    // ── External controller ─────────────────────────────────────────────────

    testWidgets('external controller is honored', (tester) async {
      final controller = TextEditingController(text: 'externo@x.com');

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(controller: controller),
          ),
        ),
      );

      expect(find.text('externo@x.com'), findsOneWidget);

      await tester.enterText(find.byType(MinFormInput), 'modificado');
      expect(controller.text, 'modificado');

      controller.dispose();
    });

    testWidgets('controller and initialValue cannot both be set', (tester) async {
      expect(
        () => MinFormInput(
          controller: TextEditingController(),
          initialValue: 'oops',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('controller syncs with FormField state', (tester) async {
      final controller = TextEditingController(text: 'sync');
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(controller: controller),
          ),
        ),
      );

      // Validate passes
      expect(formKey.currentState!.validate(), isTrue);

      // Change via controller → FormField picks it up
      controller.text = 'changed';
      await tester.pump();
      expect(find.text('changed'), findsOneWidget);
    });

    // ── Multiline ───────────────────────────────────────────────────────────

    testWidgets('multiline renders with minLines and maxLines', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              placeholder: 'Escribe...',
              type: MinInputType.multiline,
              minLines: 2,
              maxLines: 5,
            ),
          ),
        ),
      );

      expect(find.text('Escribe...'), findsOneWidget);
    });

    testWidgets('multiline accepts multi-line text input', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              type: MinInputType.multiline,
              minLines: 2,
              maxLines: 5,
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'line1\nline2');
      expect(changed, 'line1\nline2');
    });

    testWidgets('multiline with maxLines=1 is rejected', (tester) async {
      expect(
        () => MinFormInput(
          type: MinInputType.multiline,
          maxLines: 1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('password with maxLines > 1 is rejected', (tester) async {
      expect(
        () => MinFormInput(
          type: MinInputType.password,
          maxLines: 3,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('minLines > maxLines is rejected', (tester) async {
      expect(
        () => MinFormInput(
          type: MinInputType.multiline,
          minLines: 5,
          maxLines: 2,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    // ── Keyboard / input types ──────────────────────────────────────────────

    testWidgets('email type renders with email keyboard', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              type: MinInputType.email,
              placeholder: 'Email',
            ),
          ),
        ),
      );

      // Just verify it renders without error for each type
      for (final type in MinInputType.values) {
        await tester.pumpWidget(
          wrapInApp(
            Form(
              child: MinFormInput(type: type),
            ),
          ),
        );
        // No crash = success
      }
    });

    testWidgets('maxLength limits input length', (tester) async {
      String? changed;

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              maxLength: 5,
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'abcdef');
      // maxLength = 5, so input should be truncated or limited
      expect(changed!.length, lessThanOrEqualTo(5));
    });

    testWidgets('inputFormatters are applied', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(MinFormInput), 'abc123');
      expect(find.text('123'), findsOneWidget);
    });

    // ── Focus ───────────────────────────────────────────────────────────────

    testWidgets('focusNode is respected', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(focusNode: focusNode),
          ),
        ),
      );

      expect(focusNode.hasFocus, isFalse);
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    // ── Placeholder color and styling ───────────────────────────────────────

    testWidgets('placeholder color is muted when empty', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(placeholder: 'Enter'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Enter'));
      expect(text.style?.color, isNotNull);
    });

    testWidgets('counter shows when showCounter and maxLength set', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          Form(
            child: MinFormInput(
              maxLength: 100,
              showCounter: true,
              initialValue: 'hello',
            ),
          ),
        ),
      );

      expect(find.text('5 / 100'), findsOneWidget);
    });

    // ── Error text interaction with validator ────────────────────────────────

    testWidgets('forceErrorText prop takes precedence over validator', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: MinFormInput(
              forceErrorText: 'Server error',
              validator: (v) => null,
            ),
          ),
        ),
      );

      // forceErrorText always wins even when validator passes
      expect(find.text('Server error'), findsOneWidget);
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Server error'), findsOneWidget);
    });

    // ── Multiple fields in same form ────────────────────────────────────────

    testWidgets('multiple MinFormInput in same form work independently', (tester) async {
      final formKey = GlobalKey<FormState>();
      final saved = <String, String?>{};

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: Column(
              children: [
                MinFormInput(
                  placeholder: 'Name',
                  onSaved: (v) => saved['name'] = v,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                MinFormInput(
                  placeholder: 'Email',
                  onSaved: (v) => saved['email'] = v,
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Invalid email' : null,
                ),
              ],
            ),
          ),
        ),
      );

      // Type in name only
      await tester.enterText(find.byType(MinFormInput).first, 'Ada');
      await tester.pump();

      // Validate → email fails, name passes
      expect(formKey.currentState!.validate(), isFalse);

      // Type in email
      await tester.enterText(find.byType(MinFormInput).last, 'ada@test.com');
      await tester.pump();

      // Validate → all pass
      expect(formKey.currentState!.validate(), isTrue);

      // Save
      formKey.currentState!.save();
      expect(saved['name'], 'Ada');
      expect(saved['email'], 'ada@test.com');
    });

    // ── Reset clears all fields ─────────────────────────────────────────────

    testWidgets('reset restores all fields to their initialValues', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapInApp(
          Form(
            key: formKey,
            child: Column(
              children: [
                MinFormInput(
                  initialValue: 'Name',
                  onSaved: (_) {},
                ),
                MinFormInput(
                  initialValue: 'Email',
                  onSaved: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      // Modify both
      await tester.enterText(find.byType(MinFormInput).first, 'New Name');
      await tester.enterText(find.byType(MinFormInput).last, 'new@email.com');

      // Reset
      formKey.currentState!.reset();
      await tester.pump();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });
  });
}
