import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ui_flutter/miniui.dart';

Widget wrapInApp(Widget child) {
  return MinTheme(
    data: MinThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('MinColors', () {
    test('light has correct values', () {
      const colors = MinColors.light;
      expect(colors.background, const Color(0xFFFFFFFF));
      expect(colors.foreground, const Color(0xFF0F172A));
      expect(colors.primary, const Color(0xFF171717));
      expect(colors.primaryForeground, const Color(0xFFFAFAFA));
      expect(colors.secondary, const Color(0xFFF5F5F5));
      expect(colors.muted, const Color(0xFFF5F5F5));
      expect(colors.accent, const Color(0xFFF5F5F5));
      expect(colors.destructive, const Color(0xFFEF4444));
      expect(colors.border, const Color(0xFFE5E5E5));
      expect(colors.ring, const Color(0xFF171717));
    });

    test('dark has correct values', () {
      const colors = MinColors.dark;
      expect(colors.background, const Color(0xFF0A0A0A));
      expect(colors.foreground, const Color(0xFFFAFAFA));
      expect(colors.primary, const Color(0xFFFAFAFA));
      expect(colors.primaryForeground, const Color(0xFF0A0A0A));
      expect(colors.secondary, const Color(0xFF262626));
      expect(colors.muted, const Color(0xFF262626));
      expect(colors.accent, const Color(0xFF262626));
      expect(colors.destructive, const Color(0xFFDC2626));
      expect(colors.border, const Color(0xFF262626));
      expect(colors.ring, const Color(0xFFD4D4D4));
    });

    test('copyWith returns new instance with overrides', () {
      const original = MinColors.light;
      final modified = original.copyWith(
        primary: const Color(0xFFFF0000),
        background: const Color(0xFF000000),
      );

      expect(modified.primary, const Color(0xFFFF0000));
      expect(modified.background, const Color(0xFF000000));
      expect(modified.foreground, original.foreground);
      expect(modified.secondary, original.secondary);
    });

    test('equality works correctly', () {
      const a = MinColors.light;
      const b = MinColors.light;
      final c = a.copyWith(primary: const Color(0xFFFF0000));

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('MinThemeData', () {
    test('light factory creates theme with light colors', () {
      final theme = MinThemeData.light();
      expect(theme.colors, equals(MinColors.light));
      expect(theme.typography, isNotNull);
      expect(theme.radius, equals(MinRadiusScale.defaults));
      expect(theme.spacing, equals(MinSpacing.defaults));
      expect(theme.shadows, equals(MinShadows.defaults));
      expect(theme.motion, equals(MinMotion.defaults));
    });

    test('dark factory creates theme with dark colors', () {
      final theme = MinThemeData.dark();
      expect(theme.colors, equals(MinColors.dark));
    });

    test('copyWith preserves unmodified fields', () {
      final original = MinThemeData.light();
      final modified = original.copyWith(colors: MinColors.dark);

      expect(modified.colors, equals(MinColors.dark));
      expect(modified.radius, equals(original.radius));
      expect(modified.spacing, equals(original.spacing));
      expect(modified.shadows, equals(original.shadows));
      expect(modified.motion, equals(original.motion));
    });

    test('equality works correctly', () {
      final a = MinThemeData.light();
      final b = MinThemeData.light();
      final c = a.copyWith(colors: MinColors.dark);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('MinTheme InheritedWidget', () {
    testWidgets('provides theme data to descendants', (tester) async {
      late MinThemeData receivedTheme;
      final theme = MinThemeData.light();

      await tester.pumpWidget(
        MinTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              receivedTheme = context.theme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(receivedTheme, equals(theme));
    });

    testWidgets('context.themeMaybe returns null when not in tree', (
      tester,
    ) async {
      MinThemeData? receivedTheme;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            receivedTheme = context.themeMaybe;
            return const SizedBox();
          },
        ),
      );

      expect(receivedTheme, isNull);
    });
  });

  group('MinRadiusScale', () {
    test('defaults have correct values', () {
      const radius = MinRadiusScale.defaults;
      expect(radius.none, 0);
      expect(radius.sm, 6);
      expect(radius.md, 8);
      expect(radius.lg, 10);
      expect(radius.xl, 12);
      expect(radius.full, 9999);
    });

    test('copyWith works correctly', () {
      const original = MinRadiusScale.defaults;
      final modified = original.copyWith(sm: 4, lg: 12);

      expect(modified.sm, 4);
      expect(modified.lg, 12);
      expect(modified.md, original.md);
    });
  });

  group('MinSpacing', () {
    test('defaults have correct values', () {
      const spacing = MinSpacing.defaults;
      expect(spacing.px, 1);
      expect(spacing.s1, 4);
      expect(spacing.s2, 8);
      expect(spacing.s3, 12);
      expect(spacing.s4, 16);
      expect(spacing.s5, 20);
      expect(spacing.s6, 24);
      expect(spacing.s8, 32);
      expect(spacing.s10, 40);
      expect(spacing.s12, 48);
    });
  });
}
