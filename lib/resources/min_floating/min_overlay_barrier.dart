import 'package:flutter/widgets.dart';

/// A full-screen layer placed behind floating content.
/// Equivalent to the `Overlay` / `ModalBarrier` concept in web component systems.
///
/// - Blocks pointer events to content below (when [absorb] is true).
/// - Optionally dims the screen with [color].
/// - Calls [onTap] when tapped (used to close the floating element).
///
/// Usage:
/// ```dart
/// MiniOverlayBarrier(
///   visible: _isOpen,
///   color: Colors.black26,
///   onTap: _close,
/// )
/// ```
class MinOverlayBarrier extends StatelessWidget {
  const MinOverlayBarrier({
    super.key,
    this.visible = true,
    this.color = const Color(0x00000000),
    this.onTap,
    this.absorb = true,
  });

  /// Transparent barrier – blocks touches but shows nothing.
  const MinOverlayBarrier.transparent({
    super.key,
    this.visible = true,
    this.onTap,
  }) : color = const Color(0x00000000),
       absorb = true;

  /// Dimmed barrier – dims the screen behind a modal.
  const MinOverlayBarrier.dimmed({
    super.key,
    this.visible = true,
    this.color = const Color(0x80000000),
    this.onTap,
  }) : absorb = true;

  final bool visible;
  final Color color;
  final VoidCallback? onTap;

  /// Whether to absorb (block) pointer events that fall through.
  final bool absorb;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    Widget barrier = ColoredBox(color: color);

    if (absorb) {
      barrier = AbsorbPointer(absorbing: true, child: barrier);
    }

    if (onTap != null) {
      barrier = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: barrier,
      );
    }

    return Positioned.fill(child: barrier);
  }
}
