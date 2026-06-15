import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'min_anchor.dart';
import 'min_floating_config.dart';
import 'min_floating_controller.dart';
import 'min_overlay_barrier.dart';

/// The animation preset applied to the floating panel.
enum MinFloatingAnimation {
  /// Fade + slight slide from the anchor direction.
  slideAndFade,

  /// Fade only.
  fade,

  /// Scale from center + fade.
  scaleFade,

  /// No animation.
  none,
}

/// Base class for all Min floating components:
/// Popover, Tooltip, Dropdown, Select, Sheet, Dialog…
///
/// Handles:
/// - [MinFloatingController] (owned or external)
/// - [LayerLink] + [CompositedTransformTarget/Follower] (anchor system)
/// - [OverlayEntry] management (portal)
/// - Animation (open/close)
/// - Barrier (tap-outside, dimmed backdrop)
/// - Escape key
/// - Scroll-to-close
/// - Global [MinFloatingConfig] defaults
///
/// Subclasses only need to implement [buildContent].
abstract class MinFloatingBase extends StatefulWidget {
  const MinFloatingBase({
    super.key,
    required this.child,
    this.controller,
    this.visible,
    this.enabled = true,
    this.openOnTap = true,
    this.side,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.closeOnTapOutside,
    this.closeOnEscape,
    this.closeOnScroll,
    this.barrierColor,
    this.useDimmedBarrier,
    this.animation = MinFloatingAnimation.slideAndFade,
    this.groupId,
    this.constrainToViewport = true,
    this.viewportPadding = const EdgeInsets.all(8),
  }) : assert(
         controller == null || visible == null,
         'Provide either controller or visible, not both.',
       );

  /// The anchor widget (trigger). Always visible.
  final Widget child;

  /// External controller. If null, an internal one is created.
  final MinFloatingController? controller;

  /// Controlled visibility (uncontrolled if null).
  final bool? visible;

  /// If false, tapping the trigger does nothing.
  final bool enabled;

  /// Open the floating element when the trigger is tapped.
  final bool openOnTap;

  // ── Positioning ────────────────────────────────────────────────────────────
  final MinUiAnchorSide? side;

  // ── Animation ──────────────────────────────────────────────────────────────
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? curve;
  final MinFloatingAnimation animation;

  // ── Behavior ───────────────────────────────────────────────────────────────
  final bool? closeOnTapOutside;
  final bool? closeOnEscape;
  final bool? closeOnScroll;
  final Color? barrierColor;
  final bool? useDimmedBarrier;

  /// TapRegion group id. Defaults to the State instance.
  final Object? groupId;

  /// Constrains floating content to the visible viewport.
  final bool constrainToViewport;

  /// Safe margin from screen edges when [constrainToViewport] is enabled.
  final EdgeInsets viewportPadding;

  /// Override in subclasses to build the floating panel content.
  Widget buildContent(BuildContext context, MinFloatingController controller);

  /// Lets subclasses wrap overlay content with inherited dependencies
  /// captured from the anchor subtree (for example, a custom theme).
  @protected
  Widget wrapOverlay(BuildContext anchorContext, Widget overlayChild) {
    return overlayChild;
  }

  @override
  State<MinFloatingBase> createState() => _MinFloatingBaseState();
}

class _MinFloatingBaseState extends State<MinFloatingBase>
    with SingleTickerProviderStateMixin {
  // ── Core infrastructure ────────────────────────────────────────────────────
  final LayerLink _link = LayerLink();
  final GlobalKey _targetKey = GlobalKey();

  late AnimationController _anim;
  OverlayEntry? _entry;
  bool _isHiding = false;
  Size? _floatingSize;
  bool _overlayRebuildScheduled = false;

  // ── Controller ─────────────────────────────────────────────────────────────
  MinFloatingController? _owned;
  MinFloatingController get _ctrl => widget.controller ?? _owned!;

  // ── Config (merged with tree defaults) ────────────────────────────────────
  late MinFloatingDefaults _cfg;

  MinUiAnchorSide get _side => widget.side ?? _cfg.side;
  Duration get _duration => widget.duration ?? _cfg.duration;
  Duration get _reverseDuration =>
      widget.reverseDuration ?? _cfg.effectiveReverseDuration;
  Curve get _curve => widget.curve ?? _cfg.curve;
  bool get _closeOnTapOutside =>
      widget.closeOnTapOutside ?? _cfg.closeOnTapOutside;
  bool get _closeOnEscape => widget.closeOnEscape ?? _cfg.closeOnEscape;
  bool get _closeOnScroll => widget.closeOnScroll ?? _cfg.closeOnScroll;
  Color get _barrierColor => widget.barrierColor ?? _cfg.barrierColor;
  bool get _useDimmedBarrier =>
      widget.useDimmedBarrier ?? _cfg.useDimmedBarrier;

  Object get _groupId => widget.groupId ?? this;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this);
    if (widget.controller == null) {
      _owned = MinFloatingController(isOpen: widget.visible ?? false);
    }
    _ctrl.addListener(_onControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cfg = MinFloatingConfig.of(context);
    _anim.duration = _duration;
    _anim.reverseDuration = _reverseDuration;
    _scheduleOverlayRebuild();
  }

  @override
  void didUpdateWidget(covariant MinFloatingBase old) {
    super.didUpdateWidget(old);

    // Swap controller if changed
    if (old.controller != widget.controller) {
      (old.controller ?? _owned)?.removeListener(_onControllerChanged);
      if (widget.controller == null && _owned == null) {
        _owned = MinFloatingController(isOpen: widget.visible ?? false);
      }
      _ctrl.addListener(_onControllerChanged);
    }

    // Sync visible prop
    if (widget.visible != null) _ctrl.setOpen(widget.visible!);

    // Sync animation durations
    _anim.duration = _duration;
    _anim.reverseDuration = _reverseDuration;

    _scheduleOverlayRebuild();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerChanged);
    _removeEntry(immediate: true);
    _anim.dispose();
    _owned?.dispose();
    super.dispose();
  }

  // ── Controller callbacks ───────────────────────────────────────────────────

  void _onControllerChanged() {
    if (_ctrl.isOpen) {
      _openEntry();
    } else {
      _closeEntry();
    }
  }

  // ── Overlay entry management ───────────────────────────────────────────────

  void _openEntry() {
    if (!mounted) return;
    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
    if (overlay == null) return;

    // Re-measure on each open so placement starts from fresh geometry.
    _floatingSize = null;

    if (_entry == null) {
      _entry = OverlayEntry(builder: _buildOverlay);
      overlay.insert(_entry!);
    } else {
      _scheduleOverlayRebuild();
    }

    _isHiding = false;
    _anim.forward(from: 0);
  }

  void _closeEntry() {
    if (_entry == null || _isHiding) return;
    _isHiding = true;
    _anim.reverse().whenComplete(() {
      if (!_ctrl.isOpen) _removeEntry();
      _isHiding = false;
    });
  }

  void _removeEntry({bool immediate = false}) {
    if (_entry == null) return;
    if (!immediate && _anim.isAnimating) return;
    _entry!.remove();
    _entry = null;
  }

  void _scheduleOverlayRebuild() {
    if (_entry == null || _overlayRebuildScheduled) {
      return;
    }

    _overlayRebuildScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayRebuildScheduled = false;
      if (!mounted || _entry == null) {
        return;
      }
      _entry!.markNeedsBuild();
    });
  }

  // ── Trigger ────────────────────────────────────────────────────────────────

  void _onTriggerTap() {
    if (!widget.enabled || !widget.openOnTap) return;
    // Only toggle if uncontrolled
    if (widget.controller == null && widget.visible == null) {
      _ctrl.toggle();
    }
  }

  // ── Overlay builder ────────────────────────────────────────────────────────

  Widget _buildOverlay(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (_closeOnScroll && n is ScrollUpdateNotification) {
          _ctrl.hide();
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screen = Size(constraints.maxWidth, constraints.maxHeight);

          Widget content = widget.buildContent(context, _ctrl);

          if (widget.constrainToViewport) {
            final maxWidth = (screen.width - widget.viewportPadding.horizontal)
                .clamp(0.0, double.infinity);
            final maxHeight = (screen.height - widget.viewportPadding.vertical)
                .clamp(0.0, double.infinity);
            content = ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: SingleChildScrollView(primary: false, child: content),
            );
          }

          // Size observer for side-flipping
          content = MinSizeObserver(
            onSize: (s) {
              if (_floatingSize == s) return;
              _floatingSize = s;
              _scheduleOverlayRebuild();
            },
            child: content,
          );

          // Animation wrapper
          content = _applyAnimation(content, screen);

          // TapRegion (close on outside tap)
          if (_closeOnTapOutside) {
            content = TapRegion(
              groupId: _groupId,
              onTapOutside: (_) => _ctrl.hide(),
              child: content,
            );
          }

          // Escape key
          if (_closeOnEscape) {
            content = CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): _ctrl.hide,
              },
              child: content,
            );
          }

          // Anchor follower
          final isReady = _floatingSize != null;
          final anchored = MinAnchorFollower(
            link: _link,
            anchorKey: _targetKey,
            side: _side,
            floatingSize: _floatingSize,
            child: IgnorePointer(
              ignoring: !isReady,
              child: AnimatedOpacity(
                duration: _duration,
                curve: _curve,
                opacity: isReady ? 1 : 0,
                child: content,
              ),
            ),
          );

          final overlayContent = Stack(
            children: [
              // Barrier (behind the floating panel)
              if (_useDimmedBarrier)
                MinOverlayBarrier.dimmed(
                  color: _barrierColor,
                  onTap: _closeOnTapOutside ? _ctrl.hide : null,
                )
              else if (_closeOnTapOutside)
                MinOverlayBarrier.transparent(onTap: _ctrl.hide),

              anchored,
            ],
          );

          return SizedBox(
            width: screen.width,
            height: screen.height,
            child: _wrapOverlaySafely(overlayContent),
          );
        },
      ),
    );
  }

  Widget _wrapOverlaySafely(Widget overlayChild) {
    try {
      return widget.wrapOverlay(context, overlayChild);
    } on FlutterError {
      return overlayChild;
    }
  }

  Widget _applyAnimation(Widget child, Size screen) {
    final opacity = CurvedAnimation(parent: _anim, curve: _curve);

    switch (widget.animation) {
      case MinFloatingAnimation.none:
        return child;

      case MinFloatingAnimation.fade:
        return FadeTransition(opacity: opacity, child: child);

      case MinFloatingAnimation.scaleFade:
        return FadeTransition(
          opacity: opacity,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(opacity),
            child: child,
          ),
        );

      case MinFloatingAnimation.slideAndFade:
        // Slide direction depends on anchor side
        final isBelow = _side.targetAnchor == Alignment.bottomCenter;
        final isAbove = _side.targetAnchor == Alignment.topCenter;
        final dy = isBelow ? 0.04 : (isAbove ? -0.04 : 0.0);
        final dx = _side.targetAnchor == Alignment.centerRight
            ? 0.04
            : (_side.targetAnchor == Alignment.centerLeft ? -0.04 : 0.0);

        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(
            position: Tween(
              begin: Offset(dx, dy),
              end: Offset.zero,
            ).animate(opacity),
            child: ScaleTransition(
              scale: Tween(begin: 0.96, end: 1.0).animate(opacity),
              child: child,
            ),
          ),
        );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    Widget trigger = widget.child;

    // Same TapRegion group as the floating panel → outside taps work correctly
    if (_closeOnTapOutside) {
      trigger = TapRegion(groupId: _groupId, child: trigger);
    }

    // Tap to open/close
    trigger = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTriggerTap,
      child: trigger,
    );

    return MinAnchorTarget(link: _link, anchorKey: _targetKey, child: trigger);
  }
}
