part of 'min_tabs.dart';

class _TabsStyle {
  const _TabsStyle({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.labelStyle,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle labelStyle;

  static _TabsStyle resolve({
    required MinThemeData theme,
    required MinTabsSize size,
  }) {
    final sizeStyle = _TabsSizeStyle.resolve(theme, size);
    return _TabsStyle(
      horizontalPadding: sizeStyle.horizontalPadding,
      verticalPadding: sizeStyle.verticalPadding,
      labelStyle: sizeStyle.labelStyle,
    );
  }
}

class _TabsSizeStyle {
  const _TabsSizeStyle({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.labelStyle,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle labelStyle;

  static _TabsSizeStyle resolve(MinThemeData theme, MinTabsSize size) {
    switch (size) {
      case MinTabsSize.sm:
        return _TabsSizeStyle(
          horizontalPadding: theme.spacing.s3,
          verticalPadding: theme.spacing.s1,
          labelStyle: theme.typography.small,
        );
      case MinTabsSize.md:
        return _TabsSizeStyle(
          horizontalPadding: theme.spacing.s4,
          verticalPadding: theme.spacing.s2,
          labelStyle: theme.typography.body,
        );
      case MinTabsSize.lg:
        return _TabsSizeStyle(
          horizontalPadding: theme.spacing.s5,
          verticalPadding: theme.spacing.s3,
          labelStyle: theme.typography.body.copyWith(fontSize: 18),
        );
    }
  }
}

class _TabItemStyle {
  const _TabItemStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  static _TabItemStyle resolve({
    required MinThemeData theme,
    required MinTabsVariant variant,
    required bool selected,
    required bool hovered,
    required bool focused,
    required bool disabled,
  }) {
    if (disabled) {
      return _TabItemStyle(
        background: const Color(0x00000000),
        foreground: theme.colors.mutedForeground.withAlpha(128),
      );
    }

    if (variant == MinTabsVariant.pill) {
      if (selected) {
        return _TabItemStyle(
          background: theme.colors.background,
          foreground: theme.colors.foreground,
        );
      }
      if (hovered) {
        return _TabItemStyle(
          background: const Color(0x00000000),
          foreground: theme.colors.foreground,
        );
      }
      return _TabItemStyle(
        background: const Color(0x00000000),
        foreground: theme.colors.mutedForeground,
      );
    }

    if (selected) {
      return _TabItemStyle(
        background: const Color(0x00000000),
        foreground: theme.colors.foreground,
      );
    }
    if (hovered) {
      return _TabItemStyle(
        background: theme.colors.accent,
        foreground: theme.colors.accentForeground,
      );
    }
    return _TabItemStyle(
      background: const Color(0x00000000),
      foreground: theme.colors.mutedForeground,
    );
  }
}
