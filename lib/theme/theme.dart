import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'motion.dart';
import 'radius.dart';
import 'shadows.dart';
import 'spacing.dart';
import 'typography.dart';

/// Datos del tema de MiniUI.
///
/// Contiene toda la configuración visual del sistema de diseño: colores,
/// tipografía, espaciado, radios de borde, sombras y animaciones.
///
/// ### Uso
/// ```dart
/// MinTheme(
///   data: MinThemeData.light(),
///   child: MyApp(),
/// )
/// ```
///
/// Para acceder al tema desde cualquier widget:
/// ```dart
/// final theme = context.theme;
/// Container(color: theme.colors.background)
/// ```
///
/// Paletas predefinidas: [MinThemeData.light] y [MinThemeData.dark].
class MinThemeData {
  const MinThemeData({
    required this.colors,
    required this.typography,
    this.radius = MinRadiusScale.defaults,
    this.spacing = MinSpacing.defaults,
    this.shadows = MinShadows.defaults,
    this.motion = MinMotion.defaults,
  });

  final MinColors colors;
  final MinTypography typography;
  final MinRadiusScale radius;
  final MinSpacing spacing;
  final MinShadows shadows;
  final MinMotion motion;

  factory MinThemeData.light({
    String? fontFamily,
    MinColors colors = MinColors.light,
    MinRadiusScale radius = MinRadiusScale.defaults,
    MinSpacing spacing = MinSpacing.defaults,
    MinShadows shadows = MinShadows.defaults,
    MinMotion motion = MinMotion.defaults,
  }) {
    return MinThemeData(
      colors: colors,
      typography: MinTypography.defaultSans(
        fontFamily: fontFamily,
        mutedColor: colors.mutedForeground,
      ),
      radius: radius,
      spacing: spacing,
      shadows: shadows,
      motion: motion,
    );
  }

  factory MinThemeData.dark({
    String? fontFamily,
    MinColors colors = MinColors.dark,
    MinRadiusScale radius = MinRadiusScale.defaults,
    MinSpacing spacing = MinSpacing.defaults,
    MinShadows shadows = MinShadows.defaults,
    MinMotion motion = MinMotion.defaults,
  }) {
    return MinThemeData(
      colors: colors,
      typography: MinTypography.defaultSans(
        fontFamily: fontFamily,
        mutedColor: colors.mutedForeground,
      ),
      radius: radius,
      spacing: spacing,
      shadows: shadows,
      motion: motion,
    );
  }

  MinThemeData copyWith({
    MinColors? colors,
    MinTypography? typography,
    MinRadiusScale? radius,
    MinSpacing? spacing,
    MinShadows? shadows,
    MinMotion? motion,
  }) {
    final nextColors = colors ?? this.colors;
    return MinThemeData(
      colors: nextColors,
      typography:
          typography ??
          this.typography.apply(mutedColor: nextColors.mutedForeground),
      radius: radius ?? this.radius,
      spacing: spacing ?? this.spacing,
      shadows: shadows ?? this.shadows,
      motion: motion ?? this.motion,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinThemeData &&
            other.colors == colors &&
            other.typography == typography &&
            other.radius == radius &&
            other.spacing == spacing &&
            other.shadows == shadows &&
            other.motion == motion;
  }

  @override
  int get hashCode =>
      Object.hash(colors, typography, radius, spacing, shadows, motion);
}

/// InheritedWidget que provee el [MinThemeData] a todos los descendientes.
///
/// Envuelve la raíz de tu app para que cualquier widget pueda acceder
/// al tema usando `context.theme`.
///
/// ```dart
/// MinTheme(
///   data: MinThemeData.light(),
///   child: MaterialApp(home: MyHome()),
/// )
/// ```
class MinTheme extends InheritedWidget {
  const MinTheme({super.key, required this.data, required super.child});

  final MinThemeData data;

  static MinThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    assert(theme != null, 'MinTheme not found in context');
    return theme ?? MinThemeData.light();
  }

  static MinThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MinTheme>()?.data;
  }

  @override
  bool updateShouldNotify(MinTheme oldWidget) {
    return oldWidget.data != data;
  }
}

/// Extensiones de [BuildContext] para acceder al tema de MiniUI.
///
/// ```dart
/// context.theme          // MinThemeData (lanza error si no hay MinTheme)
/// context.themeMaybe     // MinThemeData? (null si no hay MinTheme)
/// ```
extension MinThemeExtension on BuildContext {
  MinThemeData get theme => MinTheme.of(this);

  MinThemeData? get themeMaybe => MinTheme.maybeOf(this);
}
