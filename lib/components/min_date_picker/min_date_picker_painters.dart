part of 'min_date_picker.dart';

class _CalendarPainter extends CustomPainter {
  const _CalendarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.15,
        size.width * 0.84,
        size.height * 0.78,
      ),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(frame, stroke);

    final lineY = size.height * 0.35;
    canvas.drawLine(
      Offset(size.width * 0.08, lineY),
      Offset(size.width * 0.92, lineY),
      stroke,
    );

    final dot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.33, size.height * 0.22),
      size.width * 0.05,
      dot,
    );
    canvas.drawCircle(
      Offset(size.width * 0.67, size.height * 0.22),
      size.width * 0.05,
      dot,
    );
  }

  @override
  bool shouldRepaint(covariant _CalendarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
