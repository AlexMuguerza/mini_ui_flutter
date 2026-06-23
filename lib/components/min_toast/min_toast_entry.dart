import 'dart:async';
import 'package:flutter/widgets.dart';
import 'min_toast_action.dart';
import 'min_toast_type.dart';
import 'min_toast_position.dart';

/// Modelo interno que representa un toast en la cola del overlay.
class MinToastEntry {
  MinToastEntry({
    required this.id,
    required this.type,
    required this.title,
    this.message,
    this.action,
    this.icon,
    required this.duration,
    this.position,
    this.maxVisible,
    this.onDismissed,
  });

  /// Identificador único del toast.
  final String id;

  /// Tipo semántico (define color e ícono por defecto).
  final MinToastType type;

  /// Título del toast.
  final String title;

  /// Mensaje opcional.
  final String? message;

  /// Acción opcional que se muestra como botón.
  final MinToastAction? action;

  /// Ícono personalizado (reemplaza el ícono por defecto del tipo).
  final Widget? icon;

  /// Duración antes de ocultarse automáticamente.
  final Duration duration;

  /// Posición en pantalla.
  final MinToastPosition? position;

  /// Máximo de toasts visibles en el mismo grupo de posición.
  final int? maxVisible;

  /// Callback al descartar el toast.
  final VoidCallback? onDismissed;

  /// Controlador de la animación de entrada/salida.
  AnimationController? enterController;

  /// Controlador de la animación de la barra de tiempo.
  AnimationController? timerController;

  /// Timer para el auto-dismiss.
  Timer? autoDismissTimer;

  /// Indica si el temporizador está pausado (mouse hover).
  bool isPaused = false;

  /// Indica si el toast está en proceso de descarte.
  bool isDismissing = false;

  /// Tiempo restante estimado basado en el progreso del [timerController].
  Duration get remainingDuration {
    if (timerController == null) return duration;
    return duration * (1.0 - timerController!.value);
  }
}
