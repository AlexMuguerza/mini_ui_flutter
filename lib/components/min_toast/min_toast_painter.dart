import 'package:flutter/widgets.dart';

/// Ícono de información (círculo con "i").
class MinToastInfoPainter extends CustomPainter {
  MinToastInfoPainter({this.color = const Color(0xFF3B82F6)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, s / 2), s * 0.42, p);
    canvas.drawCircle(Offset(cx, s * 0.36), s * 0.04, Paint()..color = color);
    canvas.drawLine(
      Offset(cx, s * 0.46),
      Offset(cx, s * 0.7),
      p,
    );
  }

  @override
  bool shouldRepaint(MinToastInfoPainter old) => old.color != color;
}

/// Ícono de éxito (círculo con check).
class MinToastSuccessPainter extends CustomPainter {
  MinToastSuccessPainter({this.color = const Color(0xFF22C55E)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, s / 2), s * 0.42, p);
    final check = Path()
      ..moveTo(s * 0.27, s * 0.5)
      ..lineTo(s * 0.44, s * 0.65)
      ..lineTo(s * 0.73, s * 0.35);
    canvas.drawPath(check, p);
  }

  @override
  bool shouldRepaint(MinToastSuccessPainter old) => old.color != color;
}

/// Ícono de advertencia (triángulo con "!").
class MinToastWarningPainter extends CustomPainter {
  MinToastWarningPainter({this.color = const Color(0xFFF59E0B)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final tri = Path()
      ..moveTo(cx, s * 0.12)
      ..lineTo(s * 0.88, s * 0.8)
      ..lineTo(s * 0.12, s * 0.8)
      ..close();
    canvas.drawPath(tri, p);
    canvas.drawCircle(Offset(cx, s * 0.55), s * 0.035, Paint()..color = color);
    canvas.drawLine(Offset(cx, s * 0.3), Offset(cx, s * 0.47), p);
  }

  @override
  bool shouldRepaint(MinToastWarningPainter old) => old.color != color;
}

/// Ícono de error (círculo con X).
class MinToastErrorPainter extends CustomPainter {
  MinToastErrorPainter({this.color = const Color(0xFFEF4444)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, s / 2), s * 0.42, p);
    final m = s * 0.28;
    final M = s * 0.72;
    canvas.drawLine(Offset(m, m), Offset(M, M), p);
    canvas.drawLine(Offset(m, M), Offset(M, m), p);
  }

  @override
  bool shouldRepaint(MinToastErrorPainter old) => old.color != color;
}

/// Ícono de cerrar (X).
class MinToastClosePainter extends CustomPainter {
  MinToastClosePainter({this.color = const Color(0xFF9CA3AF)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.1
      ..strokeCap = StrokeCap.round;
    final m = s * 0.28;
    final M = s * 0.72;
    canvas.drawLine(Offset(m, m), Offset(M, M), p);
    canvas.drawLine(Offset(m, M), Offset(M, m), p);
  }

  @override
  bool shouldRepaint(MinToastClosePainter old) => old.color != color;
}

/// Pintor de la barra de progreso que indica el tiempo restante del toast.
class MinToastTimerPainter extends CustomPainter {
  MinToastTimerPainter({
    required this.progress,
    required this.color,
    this.backgroundColor = const Color(0x33000000),
  });

  /// Progreso de 0.0 a 1.0.
  final double progress;

  /// Color de la barra de progreso.
  final Color color;

  /// Color de fondo de la barra.
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final r = h / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(r)),
      Paint()..color = backgroundColor,
    );
    if (progress > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & Size(size.width * progress, h),
          Radius.circular(r),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(MinToastTimerPainter old) =>
      old.progress != progress || old.color != color;
}
