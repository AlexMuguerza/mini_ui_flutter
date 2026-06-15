import 'package:flutter/widgets.dart';

import '../resources/min_floating/min_anchor.dart';
import '../resources/min_floating/min_floating_base.dart';
import '../resources/min_floating/min_floating_controller.dart';
import '../theme/tokens.dart';
import 'min_card.dart';

/// A popover anchored to any widget. Replaces [MinPopover].
///
/// ```dart
/// MiniPopover(
///   content: (ctx, ctrl) => Text('Hello'),
///   child: ElevatedButton(
///     onPressed: null, // MiniPopover handles the tap
///     child: Text('Open'),
///   ),
/// )
/// ```
///
/// Controlled:
/// ```dart
/// MiniPopover(
///   controller: _ctrl,
///   content: (ctx, ctrl) => MyMenu(onSelect: (_) => ctrl.hide()),
///   child: MyButton(),
/// )
/// ```
class MinPopover extends MinFloatingBase {
  const MinPopover({
    super.key,
    required super.child,
    required this.content,
    super.controller,
    super.visible,
    super.enabled,
    super.openOnTap,
    super.side,
    super.duration,
    super.reverseDuration,
    super.curve,
    super.closeOnTapOutside,
    super.closeOnEscape,
    super.closeOnScroll,
    super.barrierColor,
    super.useDimmedBarrier,
    super.animation,
    super.groupId,
    this.padding,
    this.width,
    this.constraints,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
  });

  /// Builder for the popover panel content.
  /// Receives [controller] so inner widgets can call [controller.hide()].
  final Widget Function(BuildContext context, MinFloatingController controller)
  content;

  // ── Panel styling ──────────────────────────────────────────────────────────
  final EdgeInsetsGeometry? padding;
  final double? width;
  final BoxConstraints? constraints;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? shadows;

  @override
  Widget wrapOverlay(BuildContext anchorContext, Widget overlayChild) {
    final theme = MinTheme.maybeOf(anchorContext);
    if (theme == null) {
      return overlayChild;
    }

    return MinTheme(data: theme, child: overlayChild);
  }

  @override
  Widget buildContent(BuildContext context, MinFloatingController controller) {
    return _MiniPopoverPanel(popover: this, controller: controller);
  }
}

class _MiniPopoverPanel extends StatelessWidget {
  const _MiniPopoverPanel({required this.popover, required this.controller});

  final MinPopover popover;
  final MinFloatingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return MinCard(
      backgroundColor: popover.backgroundColor ?? theme.colors.popover,
      borderColor: popover.borderColor,
      borderRadius: popover.borderRadius,
      shadows: popover.shadows,
      width: popover.width,
      constraints: popover.constraints,
      padding: popover.padding ?? EdgeInsets.all(theme.spacing.s3),
      child: popover.content(context, controller),
    );
  }
}

// ── MinPopoverAnchor (alias for MinAnchorSide) ──────────────────────────────

/// Convenience alias so existing code using [MinPopoverAnchor] can migrate.
typedef MinPopoverAnchor = MinUiAnchorSide;
