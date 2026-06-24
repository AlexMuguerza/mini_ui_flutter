part of 'min_checkbox.dart';

class _CheckboxStyle {
  const _CheckboxStyle({
    required this.size,
    required this.radius,
    required this.iconSize,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.checkColor,
    required this.shadows,
  });

  final double size;
  final double radius;
  final double iconSize;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color checkColor;
  final List<BoxShadow> shadows;

  static _CheckboxStyle resolve({
    required MinThemeData theme,
    required MinCheckboxSize size,
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool checked,
    Color? side,
    Color? checkColor,
  }) {
    final sizeStyle = _CheckboxSizeStyle.resolve(theme, size);

    Color backgroundColor;
    Color borderColor;
    Color resolvedCheckColor;
    List<BoxShadow> shadows = const [];

    if (!enabled) {
      backgroundColor = checked ? theme.colors.muted : theme.colors.muted;
      borderColor = side ?? theme.colors.input;
      resolvedCheckColor = theme.colors.mutedForeground;
    } else if (checked) {
      backgroundColor = theme.colors.primary;
      borderColor = theme.colors.primary;
      resolvedCheckColor = checkColor ?? theme.colors.primaryForeground;
    } else if (hovered) {
      backgroundColor = theme.colors.muted;
      borderColor = side ?? theme.colors.ring;
      resolvedCheckColor = theme.colors.foreground;
    } else {
      backgroundColor = const Color(0x00000000);
      borderColor = side ?? theme.colors.border;
      resolvedCheckColor = theme.colors.foreground;
    }

    if (focused && enabled) {
      shadows = [
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(70),
        ),
      ];
    }

    return _CheckboxStyle(
      size: sizeStyle.size,
      radius: sizeStyle.radius,
      iconSize: sizeStyle.iconSize,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: sizeStyle.borderWidth,
      checkColor: resolvedCheckColor,
      shadows: shadows,
    );
  }
}

class _CheckboxSizeStyle {
  const _CheckboxSizeStyle({
    required this.size,
    required this.radius,
    required this.iconSize,
    required this.borderWidth,
  });

  final double size;
  final double radius;
  final double iconSize;
  final double borderWidth;

  static _CheckboxSizeStyle resolve(MinThemeData theme, MinCheckboxSize size) {
    switch (size) {
      case MinCheckboxSize.sm:
        return const _CheckboxSizeStyle(
          size: 18,
          radius: 3,
          iconSize: 14,
          borderWidth: 1.5,
        );
      case MinCheckboxSize.md:
        return const _CheckboxSizeStyle(
          size: 22,
          radius: 4,
          iconSize: 18,
          borderWidth: 2,
        );
      case MinCheckboxSize.lg:
        return const _CheckboxSizeStyle(
          size: 26,
          radius: 5,
          iconSize: 20,
          borderWidth: 3,
        );
    }
  }
}
