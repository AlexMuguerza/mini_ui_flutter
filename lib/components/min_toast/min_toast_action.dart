import 'package:flutter/widgets.dart';

/// Acción que puede ejecutar el usuario desde el toast.
class MinToastAction {
  const MinToastAction({
    required this.label,
    required this.onPressed,
  });

  /// Texto del botón de acción.
  final String label;

  /// Callback al presionar el botón.
  final VoidCallback onPressed;
}
