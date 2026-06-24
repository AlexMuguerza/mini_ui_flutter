part of 'min_date_picker.dart';

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
