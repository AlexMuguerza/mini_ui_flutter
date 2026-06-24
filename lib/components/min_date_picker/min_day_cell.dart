part of 'min_date_picker.dart';

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
      label:
          '${context.minLocale.monthNames[widget.date.month - 1]} ${widget.date.day}',
      button: enabled,
      selected: isSelected,
      enabled: enabled,
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
