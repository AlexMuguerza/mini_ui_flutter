import 'package:flutter/widgets.dart';

/// Inserts [child] into the nearest [Overlay] (rootOverlay by default).
/// Equivalent to a "Portal" in web component systems.
///
/// Usage:
/// ```dart
/// MiniPortal(
///   visible: _isOpen,
///   child: MyFloatingPanel(),
/// )
/// ```
class MinPortal extends StatefulWidget {
  const MinPortal({
    super.key,
    required this.child,
    this.visible = true,
    this.rootOverlay = true,
  });

  final Widget child;
  final bool visible;

  /// If true, inserts into the root overlay (above routes/dialogs).
  final bool rootOverlay;

  @override
  State<MinPortal> createState() => _MinPortalState();
}

class _MinPortalState extends State<MinPortal> {
  OverlayEntry? _entry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant MinPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _sync();
    } else {
      _entry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _removeEntry();
    super.dispose();
  }

  void _sync() {
    if (widget.visible) {
      _showEntry();
    } else {
      _removeEntry();
    }
  }

  void _showEntry() {
    if (_entry != null) {
      _entry!.markNeedsBuild();
      return;
    }

    final overlay =
        Overlay.maybeOf(context, rootOverlay: widget.rootOverlay) ??
        Overlay.maybeOf(context);
    if (overlay == null) return;

    _entry = OverlayEntry(builder: (_) => widget.child);
    overlay.insert(_entry!);
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
