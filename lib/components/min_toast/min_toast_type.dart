import 'package:flutter/painting.dart';

/// Tipo semántico del toast que define su color e ícono.
enum MinToastType {

  /// Informativo — azul.
  info,

  /// Advertencia — amarillo.
  warning,

  /// Éxito — verde.
  success,

  /// Error — rojo.
  error,
}

/// Extensión para obtener el color asociado a cada [MinToastType].
extension MinToastTypeColor on MinToastType {

  /// Color semántico del tipo de toast.
  Color get color {
    switch (this) {
      case MinToastType.info:
        return const Color(0xFF3B82F6);
      case MinToastType.warning:
        return const Color(0xFFF59E0B);
      case MinToastType.success:
        return const Color(0xFF22C55E);
      case MinToastType.error:
        return const Color(0xFFEF4444);
    }
  }
}
