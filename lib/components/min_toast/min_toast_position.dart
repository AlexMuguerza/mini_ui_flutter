import 'package:flutter/widgets.dart';

/// Define la posición en pantalla donde se muestra un toast.
///
/// Cada instancia combina valores de distancia desde los bordes (`top`,
/// `bottom`, `left`, `right`) y una alineación ([Alignment]) para controlar
/// el anclaje del toast.
class MinToastPosition {
  const MinToastPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.alignment = Alignment.bottomCenter,
  });

  /// Distancia desde el borde superior de la pantalla.
  final double? top;

  /// Distancia desde el borde inferior de la pantalla.
  final double? bottom;

  /// Distancia desde el borde izquierdo de la pantalla.
  final double? left;

  /// Distancia desde el borde derecho de la pantalla.
  final double? right;

  /// Alineación del toast dentro del área definida por los bordes.
  final Alignment alignment;

  /// Centrado abajo.
  static const bottomCenter = MinToastPosition(
    bottom: 16,
    alignment: Alignment.bottomCenter,
  );

  /// Esquina superior derecha.
  static const topRight = MinToastPosition(
    top: 16,
    right: 16,
    alignment: Alignment.topRight,
  );

  /// Esquina superior izquierda.
  static const topLeft = MinToastPosition(
    top: 16,
    left: 16,
    alignment: Alignment.topLeft,
  );

  /// Esquina inferior izquierda.
  static const bottomLeft = MinToastPosition(
    bottom: 16,
    left: 16,
    alignment: Alignment.bottomLeft,
  );

  /// Esquina inferior derecha.
  static const bottomRight = MinToastPosition(
    bottom: 16,
    right: 16,
    alignment: Alignment.bottomRight,
  );

  /// Centrado arriba.
  static const topCenter = MinToastPosition(
    top: 16,
    alignment: Alignment.topCenter,
  );

  /// Clave única que identifica esta posición para agrupar toasts.
  String get positionKey => '${top}_${bottom}_${left}_${right}_$alignment';

  /// Indica si esta es la posición por defecto para web (sin uso actual).
  static bool get isDefaultWeb => false;
}
