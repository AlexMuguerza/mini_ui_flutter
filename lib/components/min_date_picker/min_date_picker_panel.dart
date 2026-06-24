part of 'min_date_picker.dart';

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
                    monthName: context
                        .minLocale.monthNames[widget.displayMonth.month - 1],
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
                  onTap: () =>
                      setState(() => _showMonthSelector = true),
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
