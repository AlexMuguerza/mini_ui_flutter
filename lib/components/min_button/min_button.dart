import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/tokens.dart';

part 'min_button_style.dart';
part 'min_button_spinner.dart';

enum MinButtonVariant { primary, secondary, outline, ghost }

enum MinButtonSize { sm, md, lg }

class MinButton extends StatefulWidget {
  const MinButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = MinButtonVariant.primary,
    this.size = MinButtonSize.md,
    this.leading,
    this.trailing,
    this.loading = false,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final MinButtonVariant variant;
  final MinButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;
  final BorderRadius? borderRadius;

  @override
  State<MinButton> createState() => _MinButtonState();
}

class _MinButtonState extends State<MinButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled =>
      !widget.disabled && !widget.loading && widget.onPressed != null;

  void _activate() {
    if (_enabled) {
      widget.onPressed?.call();
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        if (!_pressed) {
          setState(() => _pressed = true);
        }
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        setState(() => _pressed = false);
        _activate();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _MinButtonStyle.resolve(
      theme: theme,
      variant: widget.variant,
      size: widget.size,
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
      enabled: _enabled,
    );

    final horizontalGap = SizedBox(width: theme.spacing.s2);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: _onKeyEvent,
        child: MouseRegion(
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _activate : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: _enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: AnimatedContainer(
              duration: theme.motion.normal,
              curve: theme.motion.curve,
              constraints: BoxConstraints(minHeight: style.height),
              padding: EdgeInsets.symmetric(
                horizontal: style.horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(style.radius),
                border: Border.all(
                  color: style.border,
                  width: theme.spacing.px,
                ),
                boxShadow: style.shadows,
              ),
              child: DefaultTextStyle(
                style: style.textStyle.copyWith(color: style.foreground),
                child: IconTheme(
                  data: IconThemeData(
                    size: style.iconSize,
                    color: style.foreground,
                  ),
                  child: AnimatedOpacity(
                    duration: theme.motion.fast,
                    opacity: _enabled ? 1 : 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.loading)
                          _MinButtonSpinner(
                            size: style.iconSize,
                            strokeWidth: math.max(theme.spacing.px, 1.0),
                            color: style.foreground,
                            duration: theme.motion.slow,
                          )
                        else if (widget.leading != null)
                          widget.leading!,
                        if (widget.loading || widget.leading != null)
                          horizontalGap,
                        widget.child,
                        if (widget.trailing != null) ...[
                          horizontalGap,
                          widget.trailing!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
