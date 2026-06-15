/// Strings localizables de la librería mini_ui_flutter.
///
/// Contiene todas las cadenas de texto que los componentes muestran
/// al usuario. Incluye traducciones built-in para español (default)
/// e inglés.
///
/// ### Override personalizado
/// ```dart
/// MinLocalizations(
///   locale: Locale('es'),
///   overrides: MinLocale(
///     selectPlaceholder: 'Elegir...',
///   ),
///   child: MyApp(),
/// )
/// ```
class MinLocale {
  const MinLocale({
    required this.selectPlaceholder,
    required this.selectSearchPlaceholder,
    required this.datePickerPlaceholder,
    required this.monthNames,
    required this.monthNamesShort,
    required this.dayHeaders,
    required this.today,
    required this.months,
    required this.prevMonth,
    required this.nextMonth,
    required this.closeDrawerLabel,
  });

  /// Placeholder por defecto de [MinSelect] cuando no hay selección.
  final String selectPlaceholder;

  /// Placeholder del campo de búsqueda dentro de [MinSelect] searchable.
  final String selectSearchPlaceholder;

  /// Placeholder por defecto de [MinDatePicker] cuando no hay fecha.
  final String datePickerPlaceholder;

  /// Nombres completos de los 12 meses.
  final List<String> monthNames;

  /// Nombres abreviados de los 12 meses (3-4 letras).
  final List<String> monthNamesShort;

  /// Encabezados de los días de la semana (una letra).
  final List<String> dayHeaders;

  /// Texto del botón "Hoy" en el date picker.
  final String today;

  /// Texto del botón "Meses" en el date picker.
  final String months;

  /// Label de accesibilidad del botón de mes anterior.
  final String prevMonth;

  /// Label de accesibilidad del botón de mes siguiente.
  final String nextMonth;

  /// Label de accesibilidad del overlay del drawer.
  final String closeDrawerLabel;

  // ---------------------------------------------------------------------------
  // Built-in: Español
  // ---------------------------------------------------------------------------

  /// Localización por defecto: español.
  static const es = MinLocale(
    selectPlaceholder: 'Seleccionar...',
    selectSearchPlaceholder: 'Buscar...',
    datePickerPlaceholder: 'Seleccionar fecha',
    monthNames: [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ],
    monthNamesShort: [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ],
    dayHeaders: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    today: 'Hoy',
    months: 'Meses',
    prevMonth: 'Mes anterior',
    nextMonth: 'Mes siguiente',
    closeDrawerLabel: 'Cerrar menú',
  );

  // ---------------------------------------------------------------------------
  // Built-in: Inglés
  // ---------------------------------------------------------------------------

  /// Localización en inglés.
  static const en = MinLocale(
    selectPlaceholder: 'Select...',
    selectSearchPlaceholder: 'Search...',
    datePickerPlaceholder: 'Pick a date',
    monthNames: [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    monthNamesShort: [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
    dayHeaders: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    today: 'Today',
    months: 'Months',
    prevMonth: 'Previous month',
    nextMonth: 'Next month',
    closeDrawerLabel: 'Close menu',
  );
}
