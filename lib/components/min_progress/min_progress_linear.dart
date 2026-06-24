part of 'min_progress.dart';

class _MinLinearProgress extends StatelessWidget {
  const _MinLinearProgress({
    required this.value,
    required this.size,
    required this.color,
    required this.trackColor,
    required this.motion,
    required this.radius,
    required this.spacing,
  });

  final double? value;
  final double size;
  final Color color;
  final Color trackColor;
  final MinMotion motion;
  final MinRadiusScale radius;
  final MinSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final radiusValue = BorderRadius.circular(radius.full);

    return ClipRRect(
      borderRadius: radiusValue,
      child: SizedBox(
        width: double.infinity,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: radiusValue,
          ),
          child: _indeterminate
              ? _IndeterminateLinearFill(
                  color: color,
                  motion: motion,
                  radius: radiusValue,
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value!.clamp(0.0, 1.0)),
                    duration: motion.slow * 2,
                    curve: motion.curve,
                    builder: (context, v, _) {
                      return FractionallySizedBox(
                        widthFactor: v,
                        heightFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: radiusValue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  bool get _indeterminate => value == null;
}

class _IndeterminateLinearFill extends StatefulWidget {
  const _IndeterminateLinearFill({
    required this.color,
    required this.motion,
    required this.radius,
  });

  final Color color;
  final MinMotion motion;
  final BorderRadius radius;

  @override
  State<_IndeterminateLinearFill> createState() =>
      _IndeterminateLinearFillState();
}

class _IndeterminateLinearFillState extends State<_IndeterminateLinearFill>
    with SingleTickerProviderStateMixin {
  static const double _barWidthFactor = 0.32;

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

        final x = -2.0 + 4.0 * t;

        return Align(
          alignment: Alignment(x, 0),
          child: FractionallySizedBox(
            widthFactor: _barWidthFactor,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: widget.radius,
              ),
            ),
          ),
        );
      },
    );
  }
}
