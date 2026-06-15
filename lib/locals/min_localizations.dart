import 'package:flutter/widgets.dart';

import 'min_locale.dart';

/// InheritedWidget que provee [MinLocale] a todos los widgets descendientes.
///
/// Envuelve la app una sola vez para que todos los componentes de mini_ui_flutter
/// usen las traducciones automáticamente.
///
/// ### Uso básico
/// ```dart
/// MinLocalizations(
///   child: MyApp(),
/// )
/// ```
///
/// ### Especificar idioma
/// ```dart
/// MinLocalizations(
///   locale: Locale('en'),
///   child: MyApp(),
/// )
/// ```
///
/// ### Override puntual
/// ```dart
/// MinLocalizations(
///   locale: Locale('es'),
///   overrides: MinLocale(
///     selectPlaceholder: 'Elegir...',
///     today: 'Ir a hoy',
///   ),
///   child: MyApp(),
/// )
/// ```
class MinLocalizations extends InheritedWidget {
  const MinLocalizations({
    super.key,
    required super.child,
    this.locale = const Locale('es'),
    this.overrides,
  });

  /// Locale activo. Determina qué traducciones built-in se usan
  /// cuando no se proporcionan [overrides].
  final Locale locale;

  /// Overrides personalizados de strings.
  ///
  /// Si se proporciona, tiene prioridad sobre las traducciones
  /// built-in del [locale].
  final MinLocale? overrides;

  /// Resuelve el [MinLocale] efectivo: overrides > built-in > español.
  MinLocale get localeData => overrides ?? _resolve(locale);

  static MinLocale _resolve(Locale locale) {
    if (locale.languageCode == 'en') return MinLocale.en;
    return MinLocale.es;
  }

  /// Obtiene el [MinLocale] más cercano del árbol de widgets.
  ///
  /// Si no hay un [MinLocalizations] en el árbol, devuelve [MinLocale.es]
  /// como fallback seguro.
  static MinLocale of(BuildContext context) {
    final loc = context.dependOnInheritedWidgetOfExactType<MinLocalizations>();
    return loc?.localeData ?? MinLocale.es;
  }

  @override
  bool updateShouldNotify(MinLocalizations old) =>
      locale != old.locale || overrides != old.overrides;
}

/// Extensión de conveniencia para acceder a las traducciones desde
/// cualquier [BuildContext].
///
/// ```dart
/// final locale = context.minLocale;
/// Text(locale.today)  // "Hoy" o "Today"
/// ```
extension MinLocaleContext on BuildContext {
  MinLocale get minLocale => MinLocalizations.of(this);
}
