import 'package:flutter/widgets.dart';

/// Paleta de colores del sistema de diseño MiniUI.
///
/// Sigue la convención de tokens de [shadcn/ui](https://ui.shadcn.com/docs/theming),
/// donde cada token de color tiene un par foreground asociado para garantizar
/// el contraste necesario.
///
/// ### Tokens principales
///
/// | Token | Uso |
/// |---|---|
/// | `background` / `foreground` | Fondo principal de la app y texto sobre él. |
/// | `card` / `cardForeground` | Superficies de tarjetas ([MinCard]). |
/// | `popover` / `popoverForeground` | Paneles flotantes (dropdowns, popovers). |
/// | `primary` / `primaryForeground` | Acento principal (botones primarios). |
/// | `secondary` / `secondaryForeground` | Variante secundaria. |
/// | `muted` / `mutedForeground` | Fondos atenuados y texto secundario. |
/// | `accent` / `accentForeground` | Estados hover y selección. |
/// | `destructive` / `destructiveForeground` | Errores y acciones destructivas. |
/// | `border` | Color de bordes generales. |
/// | `input` | Color de bordes de campos de entrada. |
/// | `ring` | Color del ring de foco. |
///
/// ### Uso
/// ```dart
/// final colors = context.theme.colors;
/// Container(color: colors.card)
/// Text('Hola', style: TextStyle(color: colors.foreground))
/// ```
///
/// Paletas predefinidas: [MinColors.light] y [MinColors.dark].
class MinColors {
  const MinColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;

  MinColors copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
  }) {
    return MinColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinColors &&
            other.background == background &&
            other.foreground == foreground &&
            other.card == card &&
            other.cardForeground == cardForeground &&
            other.popover == popover &&
            other.popoverForeground == popoverForeground &&
            other.primary == primary &&
            other.primaryForeground == primaryForeground &&
            other.secondary == secondary &&
            other.secondaryForeground == secondaryForeground &&
            other.muted == muted &&
            other.mutedForeground == mutedForeground &&
            other.accent == accent &&
            other.accentForeground == accentForeground &&
            other.destructive == destructive &&
            other.destructiveForeground == destructiveForeground &&
            other.border == border &&
            other.input == input &&
            other.ring == ring;
  }

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
  );

  // ── Light theme (shadcn/ui default) ──────────────────────────────────────

  static const light = MinColors(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF0F172A),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0F172A),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF0F172A),
    primary: Color(0xFF171717),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFFF5F5F5),
    secondaryForeground: Color(0xFF171717),
    muted: Color(0xFFF5F5F5),
    mutedForeground: Color(0xFF737373),
    accent: Color(0xFFF5F5F5),
    accentForeground: Color(0xFF171717),
    destructive: Color(0xFFEF4444),
    destructiveForeground: Color(0xFFFAFAFA),
    border: Color(0xFFE5E5E5),
    input: Color(0xFFE5E5E5),
    ring: Color(0xFF171717),
  );

  // ── Dark theme (shadcn/ui default) ───────────────────────────────────────

  static const dark = MinColors(
    background: Color(0xFF0A0A0A),
    foreground: Color(0xFFFAFAFA),
    card: Color(0xFF0A0A0A),
    cardForeground: Color(0xFFFAFAFA),
    popover: Color(0xFF0A0A0A),
    popoverForeground: Color(0xFFFAFAFA),
    primary: Color(0xFFFAFAFA),
    primaryForeground: Color(0xFF0A0A0A),
    secondary: Color(0xFF262626),
    secondaryForeground: Color(0xFFFAFAFA),
    muted: Color(0xFF262626),
    mutedForeground: Color(0xFFA3A3A3),
    accent: Color(0xFF262626),
    accentForeground: Color(0xFFFAFAFA),
    destructive: Color(0xFFDC2626),
    destructiveForeground: Color(0xFFFAFAFA),
    border: Color(0xFF262626),
    input: Color(0xFF262626),
    ring: Color(0xFFD4D4D4),
  );
}

typedef MinColorsDefaults = MinColors;
