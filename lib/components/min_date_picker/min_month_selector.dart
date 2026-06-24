part of 'min_date_picker.dart';

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
