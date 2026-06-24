part of 'min_select.dart';

class _MinSelectOptionTile<T> extends StatefulWidget {
  const _MinSelectOptionTile({
    required this.option,
    required this.isSelected,
    required this.isActive,
    required this.onHover,
    required this.onTap,
  });

  final MinSelectOption<T> option;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  State<_MinSelectOptionTile<T>> createState() =>
      _MinSelectOptionTileState<T>();
}

class _MinSelectOptionTileState<T> extends State<_MinSelectOptionTile<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final enabled = widget.option.enabled;
    final highlighted = widget.isActive || _hovered;

    final background =
        highlighted ? theme.colors.accent : theme.colors.popover;
    final foreground =
        enabled ? theme.colors.popoverForeground : theme.colors.mutedForeground;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hovered = true);
        if (enabled) widget.onHover();
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: theme.motion.fast,
          curve: theme.motion.curve,
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.s3,
            vertical: theme.spacing.s2,
          ),
          color: background,
          child: Row(
            children: [
              if (widget.option.leading != null) ...[
                widget.option.leading!,
                SizedBox(width: theme.spacing.s2),
              ],
              Expanded(
                child: Text(
                  widget.option.label,
                  style: theme.typography.body.copyWith(color: foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.option.trailing != null) ...[
                SizedBox(width: theme.spacing.s2),
                widget.option.trailing!,
              ],
              if (widget.isSelected) ...[
                SizedBox(width: theme.spacing.s2),
                Text(
                  '✓',
                  style: theme.typography.body.copyWith(
                    color: theme.colors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
