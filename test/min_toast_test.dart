import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ui_flutter/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

class _ToastOpener extends StatelessWidget {
  const _ToastOpener({required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: const Text('Open'),
    );
  }
}

extension on WidgetTester {
  Future<void> pumpToast() async {
    await pump();
    await pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('MinToast', () {
    testWidgets('shows title', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          _ToastOpener(
            onOpen: () {
              MinToast.show(
                context: tester.element(find.byType(_ToastOpener)),
                title: 'Operación exitosa',
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(_ToastOpener));
      await tester.pumpToast();
      expect(find.text('Operación exitosa'), findsOneWidget);
      MinToast.reset();
    });

    testWidgets('shows message', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          _ToastOpener(
            onOpen: () {
              MinToast.show(
                context: tester.element(find.byType(_ToastOpener)),
                title: 'Info',
                message: 'Este es un mensaje de prueba',
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(_ToastOpener));
      await tester.pumpToast();
      expect(find.text('Este es un mensaje de prueba'), findsOneWidget);
      MinToast.reset();
    });

    testWidgets('renders action button', (tester) async {
      bool actionCalled = false;
      await tester.pumpWidget(
        wrapInApp(
          _ToastOpener(
            onOpen: () {
              MinToast.show(
                context: tester.element(find.byType(_ToastOpener)),
                title: 'Guardado',
                message: 'Archivo guardado',
                action: MinToastAction(
                  label: 'Deshacer',
                  onPressed: () => actionCalled = true,
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(_ToastOpener));
      await tester.pumpToast();
      expect(find.text('Deshacer'), findsOneWidget);

      await tester.tap(find.text('Deshacer'));
      await tester.pumpToast();
      expect(actionCalled, isTrue);
      MinToast.reset();
    });

    testWidgets('renders all types without error', (tester) async {
      for (final type in [MinToastType.info, MinToastType.success, MinToastType.warning, MinToastType.error]) {
        await tester.pumpWidget(
          wrapInApp(
            _ToastOpener(
              onOpen: () {
                MinToast.show(
                  context: tester.element(find.byType(_ToastOpener)),
                  title: 'Test $type',
                  type: type,
                );
              },
            ),
          ),
        );
        await tester.tap(find.byType(_ToastOpener));
        await tester.pumpToast();
        expect(find.text('Test $type'), findsOneWidget);
        MinToast.reset();
      }
    });

    testWidgets('accepts custom icon widget', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          _ToastOpener(
            onOpen: () {
              MinToast.show(
                context: tester.element(find.byType(_ToastOpener)),
                title: 'Custom Icon',
                icon: const Text('★'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(_ToastOpener));
      await tester.pumpToast();
      expect(find.text('★'), findsOneWidget);
      MinToast.reset();
    });

    testWidgets('supports maxVisible', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          _ToastOpener(
            onOpen: () {
              final ctx = tester.element(find.byType(_ToastOpener));
              MinToast.show(
                context: ctx,
                title: 'First',
                maxVisible: 2,
              );
              MinToast.show(
                context: ctx,
                title: 'Second',
                maxVisible: 2,
              );
              MinToast.show(
                context: ctx,
                title: 'Third',
                maxVisible: 2,
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(_ToastOpener));
      await tester.pumpToast();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
      MinToast.reset();
    });
  });
}
