part of 'min_button.dart';

class _MinButtonStyle {
  const _MinButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.textStyle,
    required this.shadows,
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.radius,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final TextStyle textStyle;
  final List<BoxShadow> shadows;
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double radius;

  static _MinButtonStyle resolve({
    required MinThemeData theme,
    required MinButtonVariant variant,
    required MinButtonSize size,
    required bool hovered,
    required bool pressed,
    required bool focused,
    required bool enabled,
  }) {
    final transparent = theme.colors.background.withAlpha(0);
    final bool interactive = enabled;

    Color background;
    Color foreground;
    Color border;
    List<BoxShadow> shadows = const [];

    switch (variant) {
      case MinButtonVariant.primary:
        background = !interactive
            ? theme.colors.primary.withAlpha(50)
            : pressed
            ? theme.colors.primary.withAlpha(200)
            : hovered
            ? theme.colors.primary.withAlpha(230)
            : theme.colors.primary;
        foreground = theme.colors.primaryForeground;
        border = background;
        shadows = hovered || focused ? theme.shadows.sm : const [];
      case MinButtonVariant.secondary:
        background = !interactive
            ? theme.colors.muted
            : pressed
            ? theme.colors.accent
            : hovered
            ? theme.colors.accent
            : theme.colors.secondary;
        foreground = theme.colors.secondaryForeground;
        border = theme.colors.border;
      case MinButtonVariant.outline:
        background = !interactive
            ? transparent
            : pressed
            ? theme.colors.muted
            : hovered
            ? theme.colors.secondary
            : transparent;
        foreground = theme.colors.foreground;
        border = !interactive
            ? theme.colors.muted
            : theme.colors.border;
      case MinButtonVariant.ghost:
        background = !interactive
            ? transparent
            : pressed
            ? theme.colors.accent
            : hovered
            ? theme.colors.accent
            : transparent;
        foreground = !interactive
            ? theme.colors.mutedForeground
            : theme.colors.foreground;
        border = transparent;
    }

    if (focused && interactive) {
      shadows = <BoxShadow>[
        ...shadows,
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(90),
        ),
      ];
    }

    final sizeStyle = _ButtonSizeStyle.resolve(theme, size);

    return _MinButtonStyle(
      background: background,
      foreground: foreground,
      border: border,
      textStyle: sizeStyle.textStyle,
      shadows: shadows,
      height: sizeStyle.height,
      horizontalPadding: sizeStyle.horizontalPadding,
      iconSize: sizeStyle.iconSize,
      radius: sizeStyle.radius,
    );
  }
}

class _ButtonSizeStyle {
  const _ButtonSizeStyle({
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.textStyle,
    required this.radius,
  });

  final double height;
  final double horizontalPadding;
  final double iconSize;
  final TextStyle textStyle;
  final double radius;

  static _ButtonSizeStyle resolve(MinThemeData theme, MinButtonSize size) {
    switch (size) {
      case MinButtonSize.sm:
        return _ButtonSizeStyle(
          height: theme.spacing.s10 - theme.spacing.s1,
          horizontalPadding: theme.spacing.s3,
          iconSize: theme.spacing.s4 - theme.spacing.px,
          textStyle: theme.typography.small,
          radius: theme.radius.sm,
        );
      case MinButtonSize.md:
        return _ButtonSizeStyle(
          height: theme.spacing.s10,
          horizontalPadding: theme.spacing.s4,
          iconSize: theme.spacing.s4,
          textStyle: theme.typography.body,
          radius: theme.radius.md,
        );
      case MinButtonSize.lg:
        return _ButtonSizeStyle(
          height: theme.spacing.s10 + theme.spacing.s2,
          horizontalPadding: theme.spacing.s5,
          iconSize: theme.spacing.s4 + theme.spacing.px,
          textStyle: theme.typography.h3,
          radius: theme.radius.lg,
        );
    }
  }
}
