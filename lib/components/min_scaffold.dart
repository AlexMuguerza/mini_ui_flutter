import 'package:flutter/widgets.dart';
import '../theme/tokens.dart';

import 'min_drawer.dart';

/// Andamiaje de página con app bar, body, bottom bar, FAB y drawers.
///
/// Maneja automáticamente el padding de la status bar, la barra de
/// navegación del sistema y el teclado. Cuando el teclado aparece,
/// el body se desplaza hacia arriba para que los inputs siempre
/// sean visibles.
///
/// ### Uso básico
/// ```dart
/// MinScaffold(
///   appBar: MinAppBar(title: Text('Mi App')),
///   body: Text('Contenido'),
/// )
/// ```
///
/// ### Con drawer
/// ```dart
/// MinScaffold(
///   appBar: MinAppBar(title: Text('Mi App')),
///   drawer: Text('Menú lateral'),
///   body: Text('Contenido'),
/// )
/// ```
class MinScaffold extends StatelessWidget {
  const MinScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomNavigationBarHeight = 64,
    this.drawer,
    this.endDrawer,
    this.drawerController,
    this.drawerWidth = 280,
    this.endDrawerWidth = 280,
    this.edgeDragWidth = 24,
    this.enableDrawerGestures = true,
    this.persistentDrawerOnWide = true,
    this.persistentDrawerBreakpoint = 960,
    this.drawerOverlayColor = const Color(0x52000000),
    this.drawerBackgroundColor,
    this.endDrawerBackgroundColor,
    this.drawerDuration = const Duration(milliseconds: 180),
    this.drawerCurve = Curves.easeOut,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double bottomNavigationBarHeight;
  final Widget? drawer;
  final Widget? endDrawer;
  final MinDrawerController? drawerController;
  final double drawerWidth;
  final double endDrawerWidth;
  final double edgeDragWidth;
  final bool enableDrawerGestures;
  final bool persistentDrawerOnWide;
  final double persistentDrawerBreakpoint;
  final Color drawerOverlayColor;
  final Color? drawerBackgroundColor;
  final Color? endDrawerBackgroundColor;
  final Duration drawerDuration;
  final Curve drawerCurve;
  final Color? backgroundColor;

  /// Si es `true`, el body se desplaza hacia arriba cuando el teclado
  /// aparece, asegurando que los inputs siempre sean visibles.
  /// Por defecto es `true`.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = resizeToAvoidBottomInset
        ? mediaQuery.viewInsets.bottom
        : 0.0;

    final systemNavbarPadding = mediaQuery.padding.bottom;
    final bottomBar = bottomNavigationBar == null
        ? null
        : Padding(
            padding: EdgeInsets.only(bottom: systemNavbarPadding),
            child: bottomNavigationBar!,
          );

    Widget content = Column(
      children: [
        ?appBar,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: body,
          ),
        ),
        ?bottomBar,
      ],
    );

    if (floatingActionButton != null) {
      final fabBottomInset =
          systemNavbarPadding +
          (bottomNavigationBar == null ? 0 : bottomNavigationBarHeight) +
          theme.spacing.s4;

      content = Stack(
        children: [
          Positioned.fill(child: content),
          Positioned(
            right: theme.spacing.s4,
            bottom: fabBottomInset,
            child: floatingActionButton!,
          ),
        ],
      );
    }

    if (drawer != null || endDrawer != null) {
      content = MinDrawer(
        controller: drawerController,
        drawer: drawer,
        endDrawer: endDrawer,
        drawerWidth: drawerWidth,
        endDrawerWidth: endDrawerWidth,
        edgeDragWidth: edgeDragWidth,
        enableGestures: enableDrawerGestures,
        persistentOnWide: persistentDrawerOnWide,
        persistentBreakpoint: persistentDrawerBreakpoint,
        overlayColor: drawerOverlayColor,
        drawerBackgroundColor: drawerBackgroundColor,
        endDrawerBackgroundColor: endDrawerBackgroundColor,
        duration: drawerDuration,
        curve: drawerCurve,
        child: content,
      );
    }

    return ColoredBox(
      color: backgroundColor ?? theme.colors.background,
      child: content,
    );
  }
}
