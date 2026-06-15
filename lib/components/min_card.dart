import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Tarjeta reutilizable con fondo, borde y sombra predefinidos.
///
/// Usa los tokens `card` y `cardForeground` del tema por defecto.
/// Se adapta automáticamente al tema claro/oscuro.
///
/// ### Uso básico
/// ```dart
/// MinCard(
///   child: Text('Contenido de la tarjeta'),
/// )
/// ```
///
/// ### Con margin y padding personalizado
/// ```dart
/// MinCard(
///   margin: EdgeInsets.all(16),
///   padding: EdgeInsets.all(24),
///   child: Text('Tarjeta con espaciado personalizado'),
/// )
/// ```
///
/// ### Colors personalizados
/// ```dart
/// MinCard(
///   backgroundColor: theme.colors.primary,
///   borderColor: theme.colors.primary,
///   child: Text('Tarjeta con colores personalizados',
///     style: TextStyle(color: theme.colors.primaryForeground)),
/// )
/// ```
class MinCard extends StatelessWidget {
  const MinCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.shadows,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final radius =
        borderRadius ?? BorderRadius.circular(theme.radius.lg);

    Widget content = ClipRRect(
      borderRadius: radius,
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.spacing.s4),
        child: child,
      ),
    );

    if (width != null || height != null || constraints != null) {
      final boxConstraints = constraints ??
          BoxConstraints.tightFor(width: width, height: height);
      content = ConstrainedBox(
        constraints: boxConstraints,
        child: content,
      );
    }

    content = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.card,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? theme.colors.border,
          width: theme.spacing.px,
        ),
        boxShadow: shadows ?? theme.shadows.md,
      ),
      child: content,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
