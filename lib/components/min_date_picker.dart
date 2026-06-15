import 'package:flutter/widgets.dart';

import '../locals/min_localizations.dart';
import '../theme/tokens.dart';
import 'min_card.dart';
import 'min_popover.dart';

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
        placeholder: widget.placeholder ?? context.minLocale.datePickerPlaceholder,
        disabled: widget.disabled,
        semanticLabel: widget.semanticLabel,
        style: theme.typography.body,
      ),
    );
  }
}

class _MinDatePickerPanel extends StatefulWidget {
  const _MinDatePickerPanel({
    required this.groupId,
    required this.selected,
    required this.referenceDate,
    required this.displayMonth,
    required this.minDate,
    required this.maxDate,
    required this.canGoNext,
    required this.canGoPrev,
    required this.onNextMonth,
    required this.onPrevMonth,
    required this.onSelectYear,
    required this.onSelectMonth,
    required this.onSelectDay,
    required this.onToday,
  });

  final Object groupId;
  final DateTime? selected;
  final DateTime? referenceDate;
  final DateTime displayMonth;
  final DateTime minDate;
  final DateTime maxDate;
  final bool canGoNext;
  final bool canGoPrev;
  final VoidCallback onNextMonth;
  final VoidCallback onPrevMonth;
  final ValueChanged<int> onSelectYear;
  final ValueChanged<int> onSelectMonth;
  final ValueChanged<DateTime> onSelectDay;
  final VoidCallback onToday;

  @override
  State<_MinDatePickerPanel> createState() => _MinDatePickerPanelState();
}

class _MinDatePickerPanelState extends State<_MinDatePickerPanel> {
  bool _showMonthSelector = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: theme.spacing.s12 * 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showMonthSelector) ...[
            _MinMonthSelector(
              selectedMonth: widget.displayMonth.month,
              onSelectMonth: (month) {
                widget.onSelectMonth(month);
                setState(() => _showMonthSelector = false);
              },
            ),
          ] else ...[
            Row(
              children: [
                _MinHeaderIconButton(
                  enabled: widget.canGoPrev,
                  direction: _ChevronDirection.left,
                  onTap: widget.onPrevMonth,
                ),
                SizedBox(width: theme.spacing.s2),
                Expanded(
                  child: _MinYearPopoverButton(
                    groupId: widget.groupId,
                    monthName: context.minLocale.monthNames[widget.displayMonth.month - 1],
                    year: widget.displayMonth.year,
                    minYear: widget.minDate.year,
                    maxYear: widget.maxDate.year,
                    onSelectYear: widget.onSelectYear,
                  ),
                ),
                SizedBox(width: theme.spacing.s2),
                _MinHeaderIconButton(
                  enabled: widget.canGoNext,
                  direction: _ChevronDirection.right,
                  onTap: widget.onNextMonth,
                ),
              ],
            ),
            SizedBox(height: theme.spacing.s3),
            _buildCalendar(theme),
          ],
          SizedBox(height: theme.spacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                button: true,
                label: context.minLocale.today,
                child: GestureDetector(
                  onTap: widget.onToday,
                  child: Text(
                    context.minLocale.today,
                    style: theme.typography.body.copyWith(
                      color: theme.colors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: theme.spacing.s4),
              Semantics(
                button: true,
                label: context.minLocale.months,
                child: GestureDetector(
                  onTap: () => setState(() => _showMonthSelector = true),
                  child: Text(
                    context.minLocale.months,
                    style: theme.typography.body.copyWith(
                      color: theme.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(MinThemeData theme) {
    final firstOfMonth = DateTime(
      widget.displayMonth.year,
      widget.displayMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      widget.displayMonth.year,
      widget.displayMonth.month + 1,
      0,
    ).day;
    final leadingBlanks = (firstOfMonth.weekday + 6) % 7;
    final totalCellsRaw = leadingBlanks + daysInMonth;
    final totalCells = totalCellsRaw <= 35 ? 35 : 42;
    final trailingBlanks = (7 - (totalCells % 7)) % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingBlanks));

    final dayHeaders = context.minLocale.dayHeaders;

    return Column(
      children: [
        Row(
          children: [
            for (final header in dayHeaders)
              Expanded(
                child: Center(
                  child: Text(
                    header,
                    style: theme.typography.small.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: 0,
          runSpacing: 0,
          children: [
            for (var i = 0; i < totalCells + trailingBlanks; i++)
              _DayCell(
                date: gridStart.add(Duration(days: i)),
                isCurrentMonth:
                    gridStart.add(Duration(days: i)).month ==
                    widget.displayMonth.month,
                selected: widget.selected,
                referenceDate: widget.referenceDate,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onTap: widget.onSelectDay,
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Month selector (grid of 12 months)
// ---------------------------------------------------------------------------

class _MinMonthSelector extends StatelessWidget {
  const _MinMonthSelector({
    required this.selectedMonth,
    required this.onSelectMonth,
  });

  final int selectedMonth;
  final ValueChanged<int> onSelectMonth;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final locale = context.minLocale;
    final months = locale.monthNamesShort;

    return Wrap(
      spacing: theme.spacing.s1,
      runSpacing: theme.spacing.s1,
      children: List.generate(12, (i) {
        final month = i + 1;
        final isSelected = month == selectedMonth;
        return Semantics(
          label: locale.monthNames[month - 1],
          button: true,
          selected: isSelected,
          child: GestureDetector(
            onTap: () => onSelectMonth(month),
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: theme.motion.curve,
              width: (theme.spacing.s12 * 6 - theme.spacing.s1 * 11) / 6,
              height: theme.spacing.s6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? theme.colors.primary : theme.colors.card,
                borderRadius: BorderRadius.circular(theme.radius.sm),
              ),
              child: Text(
                months[i],
                style: theme.typography.small.copyWith(
                  color: isSelected
                      ? theme.colors.primaryForeground
                      : theme.colors.cardForeground,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MinYearPopoverButton extends StatelessWidget {
  const _MinYearPopoverButton({
    required this.groupId,
    required this.monthName,
    required this.year,
    required this.minYear,
    required this.maxYear,
    required this.onSelectYear,
  });

  final Object groupId;
  final String monthName;
  final int year;
  final int minYear;
  final int maxYear;
  final ValueChanged<int> onSelectYear;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return MinPopover(
      width: theme.spacing.s12 * 2.5,
      closeOnScroll: false,
      groupId: groupId,
      content: (context, controller) {
        return _YearList(
          minYear: minYear,
          maxYear: maxYear,
          selectedYear: year,
          onSelectYear: (selectedYear) {
            onSelectYear(selectedYear);
            controller.hide();
          },
        );
      },
      child: MinCard(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.s2),
        height: theme.spacing.s10 - theme.spacing.s1,
        backgroundColor: theme.colors.card,
        borderColor: theme.colors.border,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              monthName,
              style: theme.typography.body.copyWith(
                color: theme.colors.cardForeground,
              ),
            ),
            SizedBox(width: theme.spacing.s2),
            Text(
              '$year',
              style: theme.typography.body.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearList extends StatefulWidget {
  const _YearList({
    required this.minYear,
    required this.maxYear,
    required this.selectedYear,
    required this.onSelectYear,
  });

  final int minYear;
  final int maxYear;
  final int selectedYear;
  final ValueChanged<int> onSelectYear;

  @override
  State<_YearList> createState() => _YearListState();
}

class _YearListState extends State<_YearList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedYear());
  }

  @override
  void didUpdateWidget(covariant _YearList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYear != widget.selectedYear ||
        oldWidget.minYear != widget.minYear ||
        oldWidget.maxYear != widget.maxYear) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _centerSelectedYear(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _centerSelectedYear() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }

    final theme = context.theme;
    final itemExtent = theme.spacing.s10 - theme.spacing.s1;
    final viewportHeight = theme.spacing.s12 * 4;
    final total = (widget.maxYear - widget.minYear) + 1;
    final selectedIndex = (widget.maxYear - widget.selectedYear).clamp(
      0,
      total - 1,
    );

    final target =
        (selectedIndex * itemExtent) - ((viewportHeight - itemExtent) / 2);
    final offset = target.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final itemExtent = theme.spacing.s10 - theme.spacing.s1;
    final height = theme.spacing.s12 * 4;
    final count = (widget.maxYear - widget.minYear) + 1;

    return SizedBox(
      height: height,
      child: ListView.builder(
        controller: _scrollController,
        primary: false,
        padding: EdgeInsets.zero,
        itemCount: count,
        itemExtent: itemExtent,
        itemBuilder: (context, index) {
          final year = widget.maxYear - index;
          return _YearItem(
            year: year,
            selected: year == widget.selectedYear,
            itemHeight: itemExtent,
            onTap: () => widget.onSelectYear(year),
          );
        },
      ),
    );
  }
}

class _YearItem extends StatefulWidget {
  const _YearItem({
    required this.year,
    required this.selected,
    required this.itemHeight,
    required this.onTap,
  });

  final int year;
  final bool selected;
  final double itemHeight;
  final VoidCallback onTap;

  @override
  State<_YearItem> createState() => _YearItemState();
}

class _YearItemState extends State<_YearItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bg = widget.selected || _hovered
        ? theme.colors.accent
        : theme.colors.card;

    return Semantics(
      label: '${widget.year}',
      button: true,
      selected: widget.selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: theme.motion.fast,
            curve: theme.motion.curve,
            height: widget.itemHeight,
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.s3),
            color: bg,
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.year}',
              style: theme.typography.body.copyWith(
                color: theme.colors.cardForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MinDatePickerTrigger extends StatefulWidget {
  const _MinDatePickerTrigger({
    required this.selected,
    required this.placeholder,
    required this.disabled,
    required this.semanticLabel,
    required this.style,
  });

  final DateTime? selected;
  final String placeholder;
  final bool disabled;
  final String? semanticLabel;
  final TextStyle style;

  @override
  State<_MinDatePickerTrigger> createState() => _MinDatePickerTriggerState();
}

class _MinDatePickerTriggerState extends State<_MinDatePickerTrigger> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final label = widget.selected == null ? '' : _formatDate(widget.selected!);
    final bg = _hovered ? theme.colors.accent : theme.colors.background;

    return Semantics(
      button: true,
      enabled: !widget.disabled,
      label: widget.semanticLabel,
      child: Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: MouseRegion(
          cursor: widget.disabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: theme.motion.normal,
            curve: theme.motion.curve,
            height: theme.spacing.s10,
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.s4),
            decoration: BoxDecoration(
              color: widget.disabled ? theme.colors.muted : bg,
              borderRadius: BorderRadius.circular(theme.radius.md),
              border: Border.all(
                color: _focused ? theme.colors.ring : theme.colors.border,
                width: _focused ? 2 : theme.spacing.px,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.isEmpty ? widget.placeholder : label,
                  style: widget.style.copyWith(
                    color: widget.disabled
                        ? theme.colors.mutedForeground
                        : theme.colors.foreground,
                  ),
                ),
                SizedBox(width: theme.spacing.s2),
                SizedBox(
                  width: theme.spacing.s4,
                  height: theme.spacing.s4,
                  child: CustomPaint(
                    painter: _CalendarPainter(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.selected,
    required this.referenceDate,
    required this.minDate,
    required this.maxDate,
    required this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final DateTime? selected;
  final DateTime? referenceDate;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onTap;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final today = _normalizeDate(DateTime.now());
    final enabled =
        !widget.date.isBefore(widget.minDate) &&
        !widget.date.isAfter(widget.maxDate);
    final isSelected =
        widget.selected != null && _isSameDay(widget.date, widget.selected!);
    final isReference =
        widget.referenceDate != null &&
        _isSameDay(widget.date, widget.referenceDate!);
    final isToday = _isSameDay(widget.date, today);

    Color bg;
    Color fg;
    Color border;

    if (isSelected) {
      bg = theme.colors.primary;
      fg = theme.colors.primaryForeground;
      border = theme.colors.primary;
    } else if (!enabled) {
      bg = theme.colors.card;
      fg = theme.colors.mutedForeground;
      border = theme.colors.card;
    } else if (isReference) {
      bg = theme.colors.accent;
      fg = theme.colors.cardForeground;
      border = theme.colors.ring;
    } else if (!widget.isCurrentMonth) {
      bg = theme.colors.card;
      fg = theme.colors.mutedForeground;
      border = theme.colors.card;
    } else if (_hovered) {
      bg = theme.colors.accent;
      fg = theme.colors.cardForeground;
      border = theme.colors.accent;
    } else {
      bg = theme.colors.card;
      fg = theme.colors.cardForeground;
      border = isToday ? theme.colors.border : theme.colors.card;
    }

    return Semantics(
      label: '${context.minLocale.monthNames[widget.date.month - 1]} ${widget.date.day}',
      button: enabled,
      selected: isSelected,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => widget.onTap(widget.date) : null,
          child: Container(
            width: (theme.spacing.s12 * 6) / 7,
            height: theme.spacing.s10 - theme.spacing.s2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(theme.radius.sm),
              border: Border.all(
                color: border,
                width: isReference || isToday ? theme.spacing.px : 0,
              ),
            ),
            child: Text(
              '${widget.date.day}',
              style: theme.typography.small.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ChevronDirection { left, right }

class _MinHeaderIconButton extends StatefulWidget {
  const _MinHeaderIconButton({
    required this.enabled,
    required this.direction,
    required this.onTap,
  });

  final bool enabled;
  final _ChevronDirection direction;
  final VoidCallback onTap;

  @override
  State<_MinHeaderIconButton> createState() => _MinHeaderIconButtonState();
}

class _MinHeaderIconButtonState extends State<_MinHeaderIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bg = _hovered && widget.enabled
        ? theme.colors.accent
        : theme.colors.card;

    return Semantics(
      button: widget.enabled,
      label: widget.direction == _ChevronDirection.left
          ? context.minLocale.prevMonth
          : context.minLocale.nextMonth,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onTap : null,
          child: MinCard(
            width: theme.spacing.s10 - theme.spacing.s1,
            height: theme.spacing.s10 - theme.spacing.s1,
            backgroundColor: bg,
            padding: EdgeInsets.zero,
            child: Center(
              child: SizedBox(
                width: theme.spacing.s4,
                height: theme.spacing.s4,
                child: CustomPaint(
                  painter: _ChevronPainter(
                    color: widget.enabled
                        ? theme.colors.cardForeground
                        : theme.colors.mutedForeground,
                    direction: widget.direction,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color, required this.direction});

  final Color color;
  final _ChevronDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (direction == _ChevronDirection.right) {
      path
        ..moveTo(size.width * 0.3, size.height * 0.2)
        ..lineTo(size.width * 0.65, size.height * 0.5)
        ..lineTo(size.width * 0.3, size.height * 0.8);
    } else {
      path
        ..moveTo(size.width * 0.7, size.height * 0.2)
        ..lineTo(size.width * 0.35, size.height * 0.5)
        ..lineTo(size.width * 0.7, size.height * 0.8);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.direction != direction;
  }
}

class _CalendarPainter extends CustomPainter {
  const _CalendarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.15,
        size.width * 0.84,
        size.height * 0.78,
      ),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(frame, stroke);

    final lineY = size.height * 0.35;
    canvas.drawLine(
      Offset(size.width * 0.08, lineY),
      Offset(size.width * 0.92, lineY),
      stroke,
    );

    final dot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.33, size.height * 0.22),
      size.width * 0.05,
      dot,
    );
    canvas.drawCircle(
      Offset(size.width * 0.67, size.height * 0.22),
      size.width * 0.05,
      dot,
    );
  }

  @override
  bool shouldRepaint(covariant _CalendarPainter oldDelegate) {
    return oldDelegate.color != color;
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


