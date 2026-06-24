part of 'min_button.dart';

class _MinButtonSpinner extends StatefulWidget {
  const _MinButtonSpinner({
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.duration,
  });

  final double size;
  final double strokeWidth;
  final Color color;
  final Duration duration;

  @override
  State<_MinButtonSpinner> createState() => _MinButtonSpinnerState();
}

class _MinButtonSpinnerState extends State<_MinButtonSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * 4,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _MinButtonSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration * 4;
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * math.pi * 2,
            child: CustomPaint(
              painter: _SpinnerPainter(
                color: widget.color,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = size.shortestSide;
    final radius = (shortest / 2) - strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.35, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
