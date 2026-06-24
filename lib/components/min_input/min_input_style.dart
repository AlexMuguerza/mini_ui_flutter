import 'package:flutter/widgets.dart';
import '../../theme/tokens.dart';

class MinInputStyle {
  const MinInputStyle({
    required this.idle,
    required this.focused,
    required this.error,
    required this.disabled,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.placeholderColor,
    this.contentPadding,
  });

  final BoxDecoration idle;
  final BoxDecoration focused;
  final BoxDecoration error;
  final BoxDecoration disabled;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? placeholderColor;
  final EdgeInsets? contentPadding;

  static MinInputStyle outline(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.border),
      ),
      focused: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.ring.withAlpha(50),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      error: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.destructive),
        boxShadow: [
          BoxShadow(
            color: colors.destructive.withAlpha(30),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      disabled: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.input),
      ),
    );
  }

  static MinInputStyle filled(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.muted),
      ),
      focused: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.ring),
        boxShadow: [
          BoxShadow(
            color: colors.ring.withAlpha(50),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      error: BoxDecoration(
        color: colors.destructive.withAlpha(12),
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.destructive),
        boxShadow: [
          BoxShadow(
            color: colors.destructive.withAlpha(30),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      disabled: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.muted),
      ),
      foregroundColor: colors.foreground,
      disabledForegroundColor: colors.mutedForeground,
    );
  }

  static MinInputStyle ghost(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: const BoxDecoration(
        color: Color(0x00000000),
      ),
      focused: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      error: BoxDecoration(
        color: colors.destructive.withAlpha(12),
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      disabled: const BoxDecoration(color: Color(0x00000000)),
      placeholderColor: colors.mutedForeground,
    );
  }

  static MinInputStyle underline(MinThemeData theme) {
    final colors = theme.colors;

    Border bottom(Color color, {double width = 1}) => Border(
      bottom: BorderSide(color: color, width: width),
    );

    return MinInputStyle(
      idle: BoxDecoration(border: bottom(colors.border)),
      focused: BoxDecoration(border: bottom(colors.ring, width: 2)),
      error: BoxDecoration(border: bottom(colors.destructive, width: 2)),
      disabled: BoxDecoration(border: bottom(colors.input)),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      disabledForegroundColor: colors.mutedForeground,
    );
  }
}
