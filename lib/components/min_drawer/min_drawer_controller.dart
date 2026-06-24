part of 'min_drawer.dart';

/// Controlador de visibilidad de los paneles de [MinDrawer].
///
/// Permite abrir, cerrar y alternar los drawers de inicio y final
/// de programación. Notifica a los listeners cuando el estado cambia.
///
/// ```dart
/// final controller = MinDrawerController();
/// controller.openDrawer();    // Abre el drawer izquierdo
/// controller.openEndDrawer(); // Abre el drawer derecho
/// controller.closeAll();      // Cierra ambos
/// ```
class MinDrawerController extends ChangeNotifier {
  bool _isDrawerOpen = false;
  bool _isEndDrawerOpen = false;

  bool get isDrawerOpen => _isDrawerOpen;
  bool get isEndDrawerOpen => _isEndDrawerOpen;

  void openDrawer() {
    _isDrawerOpen = true;
    _isEndDrawerOpen = false;
    notifyListeners();
  }

  void closeDrawer() {
    if (!_isDrawerOpen) return;
    _isDrawerOpen = false;
    notifyListeners();
  }

  void toggleDrawer() {
    if (_isDrawerOpen) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  void openEndDrawer() {
    _isEndDrawerOpen = true;
    _isDrawerOpen = false;
    notifyListeners();
  }

  void closeEndDrawer() {
    if (!_isEndDrawerOpen) return;
    _isEndDrawerOpen = false;
    notifyListeners();
  }

  void toggleEndDrawer() {
    if (_isEndDrawerOpen) {
      closeEndDrawer();
    } else {
      openEndDrawer();
    }
  }

  void closeAll() {
    if (!_isDrawerOpen && !_isEndDrawerOpen) return;
    _isDrawerOpen = false;
    _isEndDrawerOpen = false;
    notifyListeners();
  }
}
