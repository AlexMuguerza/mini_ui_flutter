import 'package:flutter/widgets.dart';

import '../../theme/tokens.dart';

/// Variante visual de [MinBadge].
enum MinBadgeVariant { primary, secondary, outline, destructive }

/// Etiqueta tipo badge inspirada en shadcn/ui.
///
/// Pequeño contenedor con fondo y texto coloreado según la [variant].
/// Ideal para estados, categorías o notificaciones.
class MinBadge extends StatelessWidget {
  const MinBadge({
    super.key,
    required this.label,
    this.variant = MinBadgeVariant.primary,
    this.icon,
    this.decoration,
  });

  /// Contenido principal del badge.
  final Widget label;

  /// Estilo visual.
  final MinBadgeVariant variant;

  /// Icono opcional mostrado antes del [label].
  final Widget? icon;

  /// Decoración personalizada. Si es `null` se usa la decoración por defecto
  /// según la [variant] (fondo, borde y border-radius completo).
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = _resolveColors(theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.s2,
        vertical: theme.spacing.px,
      ),
      decoration: decoration ??
          BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(theme.radius.full),
            border: variant == MinBadgeVariant.outline
                ? Border.all(color: colors.border)
                : null,
          ),
      child: IconTheme(
        data: IconThemeData(color: colors.foreground),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: theme.spacing.s1)],
            DefaultTextStyle(
              style: theme.typography.muted.copyWith(color: colors.foreground),
              child: label,
            ),
          ],
        ),
      ),
    );
  }

  _BadgeColors _resolveColors(MinThemeData theme) {
    switch (variant) {
      case MinBadgeVariant.primary:
        return _BadgeColors(
          background: theme.colors.primary,
          foreground: theme.colors.primaryForeground,
          border: theme.colors.primary,
        );
      case MinBadgeVariant.secondary:
        return _BadgeColors(
          background: theme.colors.secondary,
          foreground: theme.colors.secondaryForeground,
          border: theme.colors.secondary,
        );
      case MinBadgeVariant.outline:
        return _BadgeColors(
          background: const Color(0x00000000),
          foreground: theme.colors.foreground,
          border: theme.colors.border,
        );
      case MinBadgeVariant.destructive:
        return _BadgeColors(
          background: theme.colors.destructive,
          foreground: theme.colors.destructiveForeground,
          border: theme.colors.destructive,
        );
    }
  }
}

class _BadgeColors {
  const _BadgeColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

/// Posición del badge dentro de [MinBadgeWrapper].
///
/// El [MinBadgeWrapper.offset] controla la separación desde la esquina.
enum MinBadgePosition { topRight, topLeft, bottomRight, bottomLeft }

/// Envuelve un [child] y superpone un [MinBadge] en la [position] indicada.
///
/// Útil para notificaciones sobre íconos o avatares.
///
/// ```dart
/// MinBadgeWrapper(
///   label: const Text('3'),
///   variant: MinBadgeVariant.destructive,
///   position: MinBadgePosition.topRight,
///   child: MinButton(
///     variant: MinButtonVariant.ghost,
///     child: const Icon(TablerIcons.bell),
///     onPressed: () {},
///   ),
/// )
/// ```
class MinBadgeWrapper extends StatelessWidget {
  const MinBadgeWrapper({
    super.key,
    required this.label,
    required this.child,
    this.variant = MinBadgeVariant.primary,
    this.position = MinBadgePosition.topRight,
    this.offset,
    this.icon,
    this.badgeDecoration,
  });

  /// Contenido del badge superpuesto.
  final Widget label;

  /// Widget base sobre el que se posiciona el badge.
  final Widget child;

  /// Variante visual del badge.
  final MinBadgeVariant variant;

  /// Esquina donde se ubica el badge.
  final MinBadgePosition position;

  /// Desplazamiento adicional desde la esquina.
  ///
  /// Por defecto [Offset(4, 4)] para separar del borde.
  final Offset? offset;

  /// Icono opcional dentro del badge.
  final Widget? icon;

  /// Decoración personalizada para el badge superpuesto.
  ///
  /// Si es `null` se usa la decoración por defecto según la [variant].
  final BoxDecoration? badgeDecoration;

  @override
  Widget build(BuildContext context) {
    final effectiveOffset = offset ?? const Offset(4, 4);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: position == MinBadgePosition.topLeft ||
                  position == MinBadgePosition.topRight
              ? -effectiveOffset.dy
              : null,
          bottom: position == MinBadgePosition.bottomLeft ||
                  position == MinBadgePosition.bottomRight
              ? -effectiveOffset.dy
              : null,
          left: position == MinBadgePosition.topLeft ||
                  position == MinBadgePosition.bottomLeft
              ? -effectiveOffset.dx
              : null,
          right: position == MinBadgePosition.topRight ||
                  position == MinBadgePosition.bottomRight
              ? -effectiveOffset.dx
              : null,
          child: MinBadge(
            label: label,
            variant: variant,
            icon: icon,
            decoration: badgeDecoration,
          ),
        ),
      ],
    );
  }
}
