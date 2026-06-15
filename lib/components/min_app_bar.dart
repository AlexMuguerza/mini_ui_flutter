import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Tamaños disponibles para [MinAppBar].
enum MinAppBarSize { sm, md, lg }

/// Barra de aplicación con leading, title y trailing.
///
/// Soporta tres tamaños, centro de título, elevación y padding del
/// sistema (status bar) configurable.
///
/// ### Uso básico
/// ```dart
/// MinAppBar(
///   title: Text('Mi App'),
///   leading: Icon(TablerIcons.menu),
/// )
/// ```
///
/// ### Tamaño grande con centro
/// ```dart
/// MinAppBar(
///   title: Text('Título centrado'),
///   size: MinAppBarSize.lg,
///   centerTitle: true,
/// )
/// ```
class MinAppBar extends StatelessWidget {
  const MinAppBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.size = MinAppBarSize.md,
    this.elevation = false,
    this.centerTitle = false,
    this.backgroundColor,
    this.borderColor,
    this.surfaceTintColor,
    this.height,
    this.includeSystemPadding = true,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final MinAppBarSize size;
  final bool elevation;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? surfaceTintColor;
  final double? height;
  final bool includeSystemPadding;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final mediaPadding = MediaQuery.of(context).padding;
    final sizeStyle = _AppBarSizeStyle.resolve(theme, size);
    final effectiveHeight = height ?? sizeStyle.height;
    final effectiveBackgroundColor = backgroundColor ?? theme.colors.background;
    final effectiveBorderColor = borderColor ?? theme.colors.border;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: includeSystemPadding ? mediaPadding.top : 0,
        left: theme.spacing.s2,
        right: theme.spacing.s2,
        bottom: theme.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: effectiveBorderColor,
            width: theme.spacing.px,
          ),
        ),
        boxShadow: elevation
            ? theme.shadows.sm
            : (surfaceTintColor != null
                  ? [
                      BoxShadow(
                        blurRadius: sizeStyle.shadowBlur,
                        offset: Offset(0, sizeStyle.shadowOffset),
                        color: surfaceTintColor!.withAlpha(26),
                      ),
                    ]
                  : null),
      ),
      child: IconTheme(
        data: IconThemeData(
          size: sizeStyle.iconSize,
          color: theme.colors.foreground,
        ),
        child: DefaultTextStyle(
          style: sizeStyle.titleStyle.copyWith(color: theme.colors.foreground),
          child: SizedBox(
            height: effectiveHeight,
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  if (title != null && !centerTitle)
                    SizedBox(width: theme.spacing.s3),
                ],
                if (title != null)
                  Expanded(
                    child: centerTitle
                        ? Center(child: title)
                        : Align(alignment: Alignment.centerLeft, child: title),
                  )
                else
                  const Spacer(),
                if (trailing != null) ...[
                  if (title != null) SizedBox(width: theme.spacing.s3),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarSizeStyle {
  const _AppBarSizeStyle({
    required this.height,
    required this.titleStyle,
    required this.iconSize,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  final double height;
  final TextStyle titleStyle;
  final double iconSize;
  final double shadowBlur;
  final double shadowOffset;

  static _AppBarSizeStyle resolve(MinThemeData theme, MinAppBarSize size) {
    switch (size) {
      case MinAppBarSize.sm:
        return _AppBarSizeStyle(
          height: theme.spacing.s8,
          titleStyle: theme.typography.small,
          iconSize: theme.spacing.s4,
          shadowBlur: 2,
          shadowOffset: 1,
        );
      case MinAppBarSize.md:
        return _AppBarSizeStyle(
          height: theme.spacing.s10,
          titleStyle: theme.typography.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
          iconSize: theme.spacing.s5,
          shadowBlur: 4,
          shadowOffset: 2,
        );
      case MinAppBarSize.lg:
        return _AppBarSizeStyle(
          height: theme.spacing.s12,
          titleStyle: theme.typography.h3,
          iconSize: theme.spacing.s6,
          shadowBlur: 6,
          shadowOffset: 3,
        );
    }
  }
}
