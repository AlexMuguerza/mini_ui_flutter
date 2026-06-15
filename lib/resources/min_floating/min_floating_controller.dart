import 'package:flutter/foundation.dart';

/// Controls the open/closed state of any floating component
/// (Popover, Tooltip, Dropdown, Sheet, Select, Dialog…).
///
/// Can be owned by the component itself or externally by the caller.
///
/// Usage:
/// ```dart
/// final controller = MiniFloatingController();
/// controller.show();
/// controller.hide();
/// controller.toggle();
///
/// // Listen to changes:
/// controller.addListener(() { ... });
///
/// // Read state:
/// if (controller.isOpen) { ... }
/// ```
class MinFloatingController extends ChangeNotifier {
  MinFloatingController({bool isOpen = false}) : _isOpen = isOpen;

  bool _isOpen;

  bool get isOpen => _isOpen;
  bool get isClosed => !_isOpen;

  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void toggle() => _isOpen ? hide() : show();

  void setOpen(bool open) {
    if (_isOpen == open) return;
    _isOpen = open;
    notifyListeners();
  }
}
