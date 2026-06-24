part of 'min_date_picker.dart';

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
    final label =
        widget.selected == null ? '' : _formatDate(widget.selected!);
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
