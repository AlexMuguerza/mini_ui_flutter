part of 'min_checkbox.dart';

class _DefaultCheckmarkPainter extends CustomPainter {
  _DefaultCheckmarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(size.width * 0.25, size.height * 0.55);
    path.lineTo(size.width * 0.45, size.height * 0.75);
    path.lineTo(size.width * 0.8, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DefaultCheckmarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
