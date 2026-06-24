part of 'min_progress.dart';

class _MinCircularProgress extends StatefulWidget {
  const _MinCircularProgress({
    required this.value,
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.backgroundColor,
    required this.motion,
  });

  final double? value;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final Color backgroundColor;
  final MinMotion motion;

  @override
  State<_MinCircularProgress> createState() => _MinCircularProgressState();
}

class _MinCircularProgressState extends State<_MinCircularProgress> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.value != null
          ? _DeterminateCircular(
              value: widget.value!,
              strokeWidth: widget.strokeWidth,
              color: widget.color,
              trackColor: widget.trackColor,
              motion: widget.motion,
            )
          : _IndeterminateCircular(
              strokeWidth: widget.strokeWidth,
              color: widget.color,
              trackColor: widget.trackColor,
              motion: widget.motion,
            ),
    );
  }
}

class _DeterminateCircular extends StatelessWidget {
  const _DeterminateCircular({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.motion,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final MinMotion motion;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: motion.slow * 2,
      curve: motion.curve,
      builder: (context, v, _) {
        return CustomPaint(
          painter: _CircularProgressPainter(
            progress: v,
            strokeWidth: strokeWidth,
            color: color,
            trackColor: trackColor,
          ),
        );
      },
    );
  }
}

class _IndeterminateCircular extends StatefulWidget {
  const _IndeterminateCircular({
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.motion,
  });

  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final MinMotion motion;

  @override
  State<_IndeterminateCircular> createState() => _IndeterminateCircularState();
}

class _IndeterminateCircularState extends State<_IndeterminateCircular>
    with SingleTickerProviderStateMixin {
  static const double _minSweep = 0.06;
  static const double _maxSweep = 0.75;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.motion.slow * 4,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;

        final rotation = 2 * math.pi * t;

        final eased = (1 - math.cos(2 * math.pi * t)) / 2;
        final sweep = _minSweep + eased * (_maxSweep - _minSweep);

        return CustomPaint(
          painter: _CircularProgressPainter(
            progress: sweep,
            rotation: rotation,
            strokeWidth: widget.strokeWidth,
            color: widget.color,
            trackColor: widget.trackColor,
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    this.rotation = 0,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final double rotation;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = progress * math.pi * 2;
    if (sweepAngle > 0) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2 + rotation,
        sweepAngle,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) {
    return old.progress != progress ||
        old.rotation != rotation ||
        old.color != color ||
        old.trackColor != trackColor ||
        old.strokeWidth != strokeWidth;
  }
}
