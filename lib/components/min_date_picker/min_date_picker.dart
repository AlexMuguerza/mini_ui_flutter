import 'package:flutter/widgets.dart';

import '../../locals/min_localizations.dart';
import '../../theme/tokens.dart';
import '../min_card.dart';
import '../min_popover.dart';

part 'min_date_picker_panel.dart';
part 'min_date_picker_trigger.dart';
part 'min_day_cell.dart';
part 'min_month_selector.dart';
part 'min_year_list.dart';
part 'min_header_icon_button.dart';
part 'min_date_picker_painters.dart';

/// Selector de fecha con popover, calendario mensual y selector de meses.
///
/// Muestra un trigger con la fecha seleccionada o un placeholder.
/// El popover contiene un calendario con navegación mensual, un botón
/// "Hoy" para ir a la fecha actual, y un botón "Meses" para cambiar
/// al selector de meses. Al seleccionar un mes se vuelve al calendario.
///
/// Se adapta automáticamente al tema claro/oscuro.
class MinDatePicker extends StatefulWidget {
  /// Crea un selector de fecha.
  const MinDatePicker({
    super.key,
    this.value,
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.disabled = false,
    this.placeholder,
    this.semanticLabel,
  });

  /// Fecha seleccionada actualmente.
  final DateTime? value;

  /// Callback cuando se selecciona una fecha.
  final ValueChanged<DateTime> onChanged;

  /// Fecha inicial mostrada en el calendario al abrir.
  final DateTime? initialDate;

  /// Fecha mínima seleccionable.
  final DateTime? firstDate;

  /// Fecha máxima seleccionable.
  final DateTime? lastDate;

  /// Si es `true`, el selector está deshabilitado y no responde a taps.
  final bool disabled;

  /// Texto mostrado cuando no hay fecha seleccionada.
  final String? placeholder;

  /// Etiqueta accesibilidad del componente.
  final String? semanticLabel;

  @override
  State<MinDatePicker> createState() => _MinDatePickerState();
}

class _MinDatePickerState extends State<MinDatePicker> {
  DateTime? _selected;
  late DateTime _displayMonth;
  final Object _floatingGroupId = Object();

  DateTime get _minDate =>
      _normalizeDate(widget.firstDate ?? DateTime(1900, 1, 1));
  DateTime get _maxDate =>
      _normalizeDate(widget.lastDate ?? DateTime(2100, 12, 31));

  DateTime? get _effectiveSelected {
    final value = widget.value;
    if (value != null) {
      return _clampDate(_normalizeDate(value), _minDate, _maxDate);
    }
    final selected = _selected;
    if (selected == null) {
      return null;
    }
    return _clampDate(selected, _minDate, _maxDate);
  }

  DateTime? get _referenceDate {
    final initial = widget.initialDate;
    if (initial == null) {
      return null;
    }
    return _clampDate(_normalizeDate(initial), _minDate, _maxDate);
  }

  @override
  void initState() {
    super.initState();
    final now = _normalizeDate(DateTime.now());
    if (widget.value != null) {
      _selected = _clampDate(_normalizeDate(widget.value!), _minDate, _maxDate);
    } else {
      _selected = null;
    }

    final seed = _clampDate(
      _normalizeDate(widget.initialDate ?? now),
      _minDate,
      _maxDate,
    );
    _displayMonth = DateTime(seed.year, seed.month);
  }

  @override
  void didUpdateWidget(covariant MinDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != null && widget.value == null) {
      _selected = null;
      final now = _clampDate(
        _normalizeDate(DateTime.now()),
        _minDate,
        _maxDate,
      );
      _displayMonth = DateTime(now.year, now.month);
    }

    final selected = _effectiveSelected;

    if (widget.value != null && selected != null) {
      _displayMonth = DateTime(selected.year, selected.month);
    }

    if (oldWidget.firstDate != widget.firstDate ||
        oldWidget.lastDate != widget.lastDate) {
      if (_selected != null) {
        _selected = _clampDate(_selected!, _minDate, _maxDate);
        _displayMonth = DateTime(_selected!.year, _selected!.month);
      } else {
        final now = _clampDate(
          _normalizeDate(DateTime.now()),
          _minDate,
          _maxDate,
        );
        _displayMonth = DateTime(now.year, now.month);
      }
    }
  }

  void _pickDate(DateTime date) {
    final normalized = _clampDate(_normalizeDate(date), _minDate, _maxDate);
    setState(() => _selected = normalized);
    widget.onChanged(normalized);
  }

  void _setDisplayMonth(DateTime month) {
    setState(() => _displayMonth = DateTime(month.year, month.month));
  }

  void _nextMonth() {
    final next = DateTime(_displayMonth.year, _displayMonth.month + 1);
    final limit = DateTime(_maxDate.year, _maxDate.month);
    if (_monthIndex(next) <= _monthIndex(limit)) {
      _setDisplayMonth(next);
    }
  }

  void _prevMonth() {
    final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
    final limit = DateTime(_minDate.year, _minDate.month);
    if (_monthIndex(prev) >= _monthIndex(limit)) {
      _setDisplayMonth(prev);
    }
  }

  bool _canGoNext() {
    final next = DateTime(_displayMonth.year, _displayMonth.month + 1);
    return _monthIndex(next) <=
        _monthIndex(DateTime(_maxDate.year, _maxDate.month));
  }

  bool _canGoPrev() {
    final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
    return _monthIndex(prev) >=
        _monthIndex(DateTime(_minDate.year, _minDate.month));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final selected = _effectiveSelected;
    final referenceDate = _referenceDate;

    return MinPopover(
      enabled: !widget.disabled,
      closeOnTapOutside: true,
      closeOnScroll: false,
      groupId: _floatingGroupId,
      content: (context, controller) {
        return _MinDatePickerPanel(
          groupId: _floatingGroupId,
          selected: selected,
          referenceDate: referenceDate,
          displayMonth: _displayMonth,
          minDate: _minDate,
          maxDate: _maxDate,
          canGoNext: _canGoNext(),
          canGoPrev: _canGoPrev(),
          onNextMonth: _nextMonth,
          onPrevMonth: _prevMonth,
          onSelectYear: (year) {
            _setDisplayMonth(DateTime(year, _displayMonth.month));
          },
          onSelectMonth: (month) {
            _setDisplayMonth(DateTime(_displayMonth.year, month));
          },
          onSelectDay: (date) {
            _pickDate(date);
            controller.hide();
          },
          onToday: () {
            final now = _normalizeDate(DateTime.now());
            final clamped = _clampDate(now, _minDate, _maxDate);
            _pickDate(clamped);
            controller.hide();
          },
        );
      },
      child: _MinDatePickerTrigger(
        selected: selected,
        placeholder: widget.placeholder ??
            context.minLocale.datePickerPlaceholder,
        disabled: widget.disabled,
        semanticLabel: widget.semanticLabel,
        style: theme.typography.body,
      ),
    );
  }
}

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
  if (value.isBefore(min)) {
    return min;
  }
  if (value.isAfter(max)) {
    return max;
  }
  return value;
}

int _monthIndex(DateTime value) => value.year * 12 + value.month;

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return '$d/$m/$y';
}
