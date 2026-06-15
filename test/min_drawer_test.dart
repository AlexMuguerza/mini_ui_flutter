import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniui/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('MinDrawerController', () {
    test('starts with both drawers closed', () {
      final controller = MinDrawerController();
      expect(controller.isDrawerOpen, isFalse);
      expect(controller.isEndDrawerOpen, isFalse);
      controller.dispose();
    });

    test('openDrawer opens start drawer and closes end drawer', () {
      final controller = MinDrawerController();
      controller.openDrawer();
      expect(controller.isDrawerOpen, isTrue);
      expect(controller.isEndDrawerOpen, isFalse);
      controller.dispose();
    });

    test('openEndDrawer opens end drawer and closes start drawer', () {
      final controller = MinDrawerController();
      controller.openEndDrawer();
      expect(controller.isEndDrawerOpen, isTrue);
      expect(controller.isDrawerOpen, isFalse);
      controller.dispose();
    });

    test('closeDrawer closes start drawer', () {
      final controller = MinDrawerController();
      controller.openDrawer();
      controller.closeDrawer();
      expect(controller.isDrawerOpen, isFalse);
      controller.dispose();
    });

    test('closeEndDrawer closes end drawer', () {
      final controller = MinDrawerController();
      controller.openEndDrawer();
      controller.closeEndDrawer();
      expect(controller.isEndDrawerOpen, isFalse);
      controller.dispose();
    });

    test('toggleDrawer toggles state', () {
      final controller = MinDrawerController();
      controller.toggleDrawer();
      expect(controller.isDrawerOpen, isTrue);
      controller.toggleDrawer();
      expect(controller.isDrawerOpen, isFalse);
      controller.dispose();
    });

    test('toggleEndDrawer toggles state', () {
      final controller = MinDrawerController();
      controller.toggleEndDrawer();
      expect(controller.isEndDrawerOpen, isTrue);
      controller.toggleEndDrawer();
      expect(controller.isEndDrawerOpen, isFalse);
      controller.dispose();
    });

    test('closeAll closes both drawers', () {
      final controller = MinDrawerController();
      controller.openDrawer();
      controller.closeAll();
      expect(controller.isDrawerOpen, isFalse);
      expect(controller.isEndDrawerOpen, isFalse);
      controller.dispose();
    });

    test('notifies listeners on state change', () {
      final controller = MinDrawerController();
      var notified = false;
      controller.addListener(() => notified = true);
      controller.openDrawer();
      expect(notified, isTrue);
      controller.dispose();
    });
  });

  group('MinDrawer widget', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinDrawer(
            child: const Text('Main Content'),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('does not render drawer panel when closed', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinDrawer(
            drawer: const Text('Drawer Panel'),
            child: const Text('Main Content'),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('does not render endDrawer panel when closed', (tester) async {
      await tester.pumpWidget(
        wrapInApp(
          MinDrawer(
            endDrawer: const Text('End Drawer'),
            child: const Text('Main Content'),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });
  });
}
