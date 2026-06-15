import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Defines how a floating element positions itself relative to its anchor.
@immutable
class MinUiAnchorSide {
  const MinUiAnchorSide({
    required this.targetAnchor,
    required this.followerAnchor,
    this.offset = Offset.zero,
    this.fallback,
  });

  // ── Named constructors ────────────────────────────────────────────────────

  const MinUiAnchorSide.below({
    Offset offset = const Offset(0, 8),
    MinUiAnchorSide? fallback = const MinUiAnchorSide.above(),
  }) : this(
         targetAnchor: Alignment.bottomCenter,
         followerAnchor: Alignment.topCenter,
         offset: offset,
         fallback: fallback,
       );

  const MinUiAnchorSide.above({Offset offset = const Offset(0, -8)})
    : this(
        targetAnchor: Alignment.topCenter,
        followerAnchor: Alignment.bottomCenter,
        offset: offset,
      );

  const MinUiAnchorSide.right({Offset offset = const Offset(8, 0)})
    : this(
        targetAnchor: Alignment.centerRight,
        followerAnchor: Alignment.centerLeft,
        offset: offset,
      );

  const MinUiAnchorSide.left({Offset offset = const Offset(-8, 0)})
    : this(
        targetAnchor: Alignment.centerLeft,
        followerAnchor: Alignment.centerRight,
        offset: offset,
      );

  // ── Fields ────────────────────────────────────────────────────────────────

  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;

  /// If the preferred side doesn't fit, try this instead.
  final MinUiAnchorSide? fallback;

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get isVertical =>
      targetAnchor == Alignment.bottomCenter ||
      targetAnchor == Alignment.topCenter;

  MinUiAnchorSide copyWith({
    Alignment? targetAnchor,
    Alignment? followerAnchor,
    Offset? offset,
    MinUiAnchorSide? fallback,
  }) => MinUiAnchorSide(
    targetAnchor: targetAnchor ?? this.targetAnchor,
    followerAnchor: followerAnchor ?? this.followerAnchor,
    offset: offset ?? this.offset,
    fallback: fallback ?? this.fallback,
  );
}

// ── MiniAnchorTarget ──────────────────────────────────────────────────────────

/// Marks a widget as the reference point for a [MinAnchorFollower].
/// Equivalent to `CompositedTransformTarget` but with a shared [LayerLink].
///
/// Usage:
/// ```dart
/// MiniAnchorTarget(
///   link: _link,
///   child: ElevatedButton(...),
/// )
/// ```
class MinAnchorTarget extends StatelessWidget {
  const MinAnchorTarget({
    super.key,
    required this.link,
    required this.child,
    this.anchorKey,
  });

  final LayerLink link;
  final Widget child;

  /// Optional key to measure the target's size/position.
  final GlobalKey? anchorKey;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(key: anchorKey, link: link, child: child);
  }
}

// ── MiniAnchorFollower ────────────────────────────────────────────────────────

/// Positions itself relative to a [MinAnchorTarget] via [LayerLink].
/// Supports automatic side-flipping when the preferred side doesn't fit.
///
/// Usage:
/// ```dart
/// MiniAnchorFollower(
///   link: _link,
///   anchorKey: _targetKey,
///   side: const MiniAnchorSide.below(),
///   child: MyPanel(),
/// )
/// ```
class MinAnchorFollower extends StatelessWidget {
  const MinAnchorFollower({
    super.key,
    required this.link,
    required this.child,
    this.side = const MinUiAnchorSide.below(),
    this.anchorKey,
    this.floatingSize,
    this.showWhenUnlinked = false,
  });

  final LayerLink link;
  final Widget child;
  final MinUiAnchorSide side;

  /// Key of the [MinAnchorTarget] to measure for collision detection.
  final GlobalKey? anchorKey;

  /// Estimated or known size of the floating element (used for flipping).
  final Size? floatingSize;

  final bool showWhenUnlinked;

  MinUiAnchorSide _resolve() {
    final key = anchorKey;
    if (key == null || floatingSize == null) {
      return side;
    }

    final ctx = key.currentContext;
    if (ctx == null) {
      return side;
    }

    if (ctx is Element && !ctx.mounted) {
      return side;
    }

    final RenderObject? box;
    try {
      box = ctx.findRenderObject();
    } on FlutterError {
      return side;
    }

    if (box is! RenderBox || !box.attached) {
      return side;
    }

    final Offset topLeft;
    try {
      topLeft = box.localToGlobal(Offset.zero);
    } on FlutterError {
      return side;
    }
    final screenSize =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    final targetRect = topLeft & box.size;
    final size = floatingSize!;
    final resolved = _resolveWithFallback(side, targetRect, screenSize, size);
    return _clampToViewport(resolved, targetRect, screenSize, size);
  }

  MinUiAnchorSide _resolveWithFallback(
    MinUiAnchorSide preferred,
    Rect targetRect,
    Size screenSize,
    Size floating,
  ) {
    final fallback = preferred.fallback;
    if (fallback == null) {
      return preferred;
    }

    final fh = floating.height;
    final fw = floating.width;

    if (preferred.targetAnchor == Alignment.bottomCenter) {
      final bottomSpace = screenSize.height - targetRect.bottom;
      final topSpace = targetRect.top;
      if (bottomSpace < fh + preferred.offset.dy && topSpace > bottomSpace) {
        return fallback;
      }
    } else if (preferred.targetAnchor == Alignment.topCenter) {
      final topSpace = targetRect.top;
      final bottomSpace = screenSize.height - targetRect.bottom;
      if (topSpace < fh && bottomSpace > topSpace) {
        return fallback;
      }
    } else if (preferred.targetAnchor == Alignment.centerRight) {
      final rightSpace = screenSize.width - targetRect.right;
      final leftSpace = targetRect.left;
      if (rightSpace < fw && leftSpace > rightSpace) {
        return fallback;
      }
    } else if (preferred.targetAnchor == Alignment.centerLeft) {
      final leftSpace = targetRect.left;
      final rightSpace = screenSize.width - targetRect.right;
      if (leftSpace < fw && rightSpace > leftSpace) {
        return fallback;
      }
    }

    return preferred;
  }

  MinUiAnchorSide _clampToViewport(
    MinUiAnchorSide resolved,
    Rect targetRect,
    Size screenSize,
    Size floating,
  ) {
    const viewportPadding = 8.0;

    final targetPoint = _alignmentPoint(targetRect, resolved.targetAnchor);
    final followerAnchorPoint = Offset(
      ((resolved.followerAnchor.x + 1) / 2) * floating.width,
      ((resolved.followerAnchor.y + 1) / 2) * floating.height,
    );

    final initialTopLeft = targetPoint + resolved.offset - followerAnchorPoint;

    final maxLeft = screenSize.width - floating.width - viewportPadding;
    final maxTop = screenSize.height - floating.height - viewportPadding;

    final clampedLeft = initialTopLeft.dx.clamp(
      viewportPadding,
      maxLeft < viewportPadding ? viewportPadding : maxLeft,
    );
    final clampedTop = initialTopLeft.dy.clamp(
      viewportPadding,
      maxTop < viewportPadding ? viewportPadding : maxTop,
    );

    final delta = Offset(
      clampedLeft - initialTopLeft.dx,
      clampedTop - initialTopLeft.dy,
    );

    if (delta == Offset.zero) {
      return resolved;
    }

    return resolved.copyWith(offset: resolved.offset + delta);
  }

  Offset _alignmentPoint(Rect rect, Alignment alignment) {
    return Offset(
      rect.left + ((alignment.x + 1) / 2) * rect.width,
      rect.top + ((alignment.y + 1) / 2) * rect.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve();
    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: showWhenUnlinked,
      targetAnchor: resolved.targetAnchor,
      followerAnchor: resolved.followerAnchor,
      offset: resolved.offset,
      child: child,
    );
  }
}

// ── MiniSizeObserver ──────────────────────────────────────────────────────────

/// Reports the size of its child after each layout pass.
/// Used to enable collision-aware side-flipping in [MinAnchorFollower].
class MinSizeObserver extends SingleChildRenderObjectWidget {
  const MinSizeObserver({
    super.key,
    required this.onSize,
    required super.child,
  });

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _SizeObserverBox(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _SizeObserverBox).onSize = onSize;
  }
}

class _SizeObserverBox extends RenderProxyBox {
  _SizeObserverBox(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size == _last) return;
    _last = size;
    final s = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) onSize(s);
    });
  }
}
