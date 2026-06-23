import 'package:flutter/widgets.dart';
import 'min_toast_action.dart';
import 'min_toast_overlay_manager.dart';
import 'min_toast_position.dart';
import 'min_toast_type.dart';

/// API pública para mostrar notificaciones tipo toast.
///
/// Ejemplo de uso:
/// ```dart
/// MinToast.show(
///   context: context,
///   title: 'Operación exitosa',
///   message: 'Los cambios se guardaron correctamente.',
///   type: MinToastType.success,
/// );
/// ```
class MinToast {
  MinToast._();

  static int _counter = 0;

  /// Muestra un toast en la pantalla.
  ///
  /// [context] debe tener acceso a un [Overlay] (generalmente el context raíz
  /// de la aplicación). [title] es obligatorio, [message] opcional.
  /// [type] define el color e ícono por defecto. [duration] controla cuánto
  /// tiempo permanece visible. [position] define dónde aparece. [maxVisible]
  /// limita la cantidad de toasts visibles en el mismo grupo de posición.
  /// [onDismissed] se llama cuando el toast se descarta.
  static void show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? icon,
    MinToastAction? action,
    MinToastType type = MinToastType.info,
    Duration duration = const Duration(seconds: 4),
    MinToastPosition? position,
    int maxVisible = 3,
    VoidCallback? onDismissed,
  }) {
    final id = 'toast_${_counter++}';
    MinToastOverlayManager().show(
      context: context,
      id: id,
      title: title,
      message: message,
      icon: icon,
      action: action,
      type: type,
      duration: duration,
      position: position,
      maxVisible: maxVisible,
      onDismissed: onDismissed,
    );
  }

  /// Descarta todos los toasts visibles inmediatamente.
  static void dismissAll(BuildContext context) {
    MinToastOverlayManager().dismissAll();
  }

  /// Descarta un toast específico por su [id].
  static void dismissById(BuildContext context, String id) {
    MinToastOverlayManager().dismissById(id);
  }

  /// Limpia el estado interno del overlay manager.
  ///
  /// Útil en tests para evitar fugas de timers entre pruebas.
  static void reset() {
    MinToastOverlayManager().reset();
  }
}
