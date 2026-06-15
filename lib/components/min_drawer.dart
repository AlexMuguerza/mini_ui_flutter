import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

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

/// Layout con drawers izquierdo y derecho.
///
/// Soporta gestos de deslizamiento desde los bordes de la pantalla,
/// overlay que cierra el drawer al tocar, y modo persistente en
/// pantallas anchas (el drawer queda visible junto al contenido).
///
/// ### Uso básico
/// ```dart
/// MinDrawer(
///   drawer: Text('Menú lateral'),
///   child: Text('Contenido principal'),
/// )
/// ```
///
/// ### Con controller explícito
/// ```dart
/// final controller = MinDrawerController();
/// MinDrawer(
///   controller: controller,
///   drawer: Text('Menú'),
///   child: Text('Contenido'),
/// )
/// // controller.openDrawer() para abrir programáticamente
/// ```
class MinDrawer extends StatefulWidget {
  const MinDrawer({
    super.key,
    required this.child,
    this.drawer,
    this.endDrawer,
    this.controller,
    this.drawerWidth = 280,
    this.endDrawerWidth = 280,
    this.edgeDragWidth = 24,
    this.enableGestures = true,
    this.persistentOnWide = true,
    this.persistentBreakpoint = 960,
    this.overlayColor = const Color(0x52000000),
    this.drawerBackgroundColor,
    this.endDrawerBackgroundColor,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Widget? drawer;
  final Widget? endDrawer;
  final MinDrawerController? controller;
  final double drawerWidth;
  final double endDrawerWidth;
  final double edgeDragWidth;
  final bool enableGestures;
  final bool persistentOnWide;
  final double persistentBreakpoint;
  final Color overlayColor;
  final Color? drawerBackgroundColor;
  final Color? endDrawerBackgroundColor;
  final Duration duration;
  final Curve curve;

  @override
  State<MinDrawer> createState() => _MinDrawerState();
}

enum _DragMode { openDrawer, closeDrawer, openEndDrawer, closeEndDrawer }

class _MinDrawerState extends State<MinDrawer> with TickerProviderStateMixin {
  late final MinDrawerController _ownedController;
  MinDrawerController get _controller => widget.controller ?? _ownedController;

  late final AnimationController _drawerCtrl = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 0,
  );

  late final AnimationController _endDrawerCtrl = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 0,
  );

  _DragMode? _dragMode;

  @override
  void initState() {
    super.initState();
    _ownedController = MinDrawerController();
    _controller.addListener(_syncFromController);
    _syncFromController();
  }

  @override
  void didUpdateWidget(covariant MinDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _drawerCtrl.duration = widget.duration;
      _endDrawerCtrl.duration = widget.duration;
    }

    if (oldWidget.controller != widget.controller) {
      final old = oldWidget.controller ?? _ownedController;
      old.removeListener(_syncFromController);
      _controller.addListener(_syncFromController);
      _syncFromController();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFromController);
    _drawerCtrl.dispose();
    _endDrawerCtrl.dispose();
    _ownedController.dispose();
    super.dispose();
  }

  void _syncFromController() {
    if (!mounted) return;

    if (_controller.isDrawerOpen) {
      _endDrawerCtrl.animateTo(0, curve: widget.curve);
      _drawerCtrl.animateTo(1, curve: widget.curve);
      return;
    }

    if (_controller.isEndDrawerOpen) {
      _drawerCtrl.animateTo(0, curve: widget.curve);
      _endDrawerCtrl.animateTo(1, curve: widget.curve);
      return;
    }

    _drawerCtrl.animateTo(0, curve: widget.curve);
    _endDrawerCtrl.animateTo(0, curve: widget.curve);
  }

  bool _isPersistent(double width) {
    return widget.persistentOnWide && width >= widget.persistentBreakpoint;
  }

  void _onHorizontalDragStart(DragStartDetails details, double width) {
    if (!widget.enableGestures) return;
    if (_isPersistent(width)) return;

    final x = details.localPosition.dx;
    final hasDrawer = widget.drawer != null;
    final hasEndDrawer = widget.endDrawer != null;

    if (_drawerCtrl.value > 0 && x <= widget.drawerWidth) {
      _dragMode = _DragMode.closeDrawer;
      return;
    }

    if (_endDrawerCtrl.value > 0 && x >= width - widget.endDrawerWidth) {
      _dragMode = _DragMode.closeEndDrawer;
      return;
    }

    if (hasDrawer && x <= widget.edgeDragWidth) {
      _dragMode = _DragMode.openDrawer;
      return;
    }

    if (hasEndDrawer && x >= width - widget.edgeDragWidth) {
      _dragMode = _DragMode.openEndDrawer;
      return;
    }

    _dragMode = null;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;

    switch (_dragMode) {
      case _DragMode.openDrawer:
      case _DragMode.closeDrawer:
        _drawerCtrl.value = (_drawerCtrl.value + (delta / widget.drawerWidth))
            .clamp(0.0, 1.0);
        _endDrawerCtrl.value = 0;
        break;
      case _DragMode.openEndDrawer:
      case _DragMode.closeEndDrawer:
        _endDrawerCtrl.value =
            (_endDrawerCtrl.value - (delta / widget.endDrawerWidth)).clamp(
              0.0,
              1.0,
            );
        _drawerCtrl.value = 0;
        break;
      case null:
        break;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _settleAfterDrag();
  }

  void _onHorizontalDragCancel() {
    _settleAfterDrag();
  }

  void _settleAfterDrag() {
    switch (_dragMode) {
      case _DragMode.openDrawer:
      case _DragMode.closeDrawer:
        if (_drawerCtrl.value > 0.5) {
          _controller.openDrawer();
        } else {
          _drawerCtrl.animateTo(0, curve: widget.curve);
          _endDrawerCtrl.animateTo(0, curve: widget.curve);
          _controller.closeAll();
        }
        break;
      case _DragMode.openEndDrawer:
      case _DragMode.closeEndDrawer:
        if (_endDrawerCtrl.value > 0.5) {
          _controller.openEndDrawer();
        } else {
          _drawerCtrl.animateTo(0, curve: widget.curve);
          _endDrawerCtrl.animateTo(0, curve: widget.curve);
          _controller.closeAll();
        }
        break;
      case null:
        break;
    }

    _dragMode = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final effectiveDrawerBg =
        widget.drawerBackgroundColor ?? theme.colors.background;
    final effectiveEndDrawerBg =
        widget.endDrawerBackgroundColor ?? theme.colors.background;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (_isPersistent(width)) {
          return Row(
            children: [
              if (widget.drawer != null)
                SizedBox(
                  width: widget.drawerWidth,
                  child: ColoredBox(
                    color: effectiveDrawerBg,
                    child: widget.drawer,
                  ),
                ),
              Expanded(child: widget.child),
              if (widget.endDrawer != null)
                SizedBox(
                  width: widget.endDrawerWidth,
                  child: ColoredBox(
                    color: effectiveEndDrawerBg,
                    child: widget.endDrawer,
                  ),
                ),
            ],
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (d) => _onHorizontalDragStart(d, width),
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onHorizontalDragCancel: _onHorizontalDragCancel,
          child: AnimatedBuilder(
            animation: Listenable.merge([_drawerCtrl, _endDrawerCtrl]),
            builder: (context, _) {
              final drawerOffset =
                  -widget.drawerWidth +
                  (widget.drawerWidth * _drawerCtrl.value);
              final endDrawerOffset =
                  -widget.endDrawerWidth +
                  (widget.endDrawerWidth * _endDrawerCtrl.value);
              final overlayOpacity =
                  (_drawerCtrl.value > _endDrawerCtrl.value
                          ? _drawerCtrl.value
                          : _endDrawerCtrl.value)
                      .clamp(0.0, 1.0);

              return Stack(
                children: [
                  widget.child,
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: overlayOpacity == 0,
                      child: Opacity(
                        opacity: overlayOpacity,
                        child: GestureDetector(
                          onTap: _controller.closeAll,
                          behavior: HitTestBehavior.opaque,
                          child: ColoredBox(color: widget.overlayColor),
                        ),
                      ),
                    ),
                  ),
                  if (widget.drawer != null)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: drawerOffset,
                      width: widget.drawerWidth,
                      child: ColoredBox(
                        color: effectiveDrawerBg,
                        child: widget.drawer,
                      ),
                    ),
                  if (widget.endDrawer != null)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: endDrawerOffset,
                      width: widget.endDrawerWidth,
                      child: ColoredBox(
                        color: effectiveEndDrawerBg,
                        child: widget.endDrawer,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
