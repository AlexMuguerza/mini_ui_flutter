import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/tokens.dart';

part 'min_checkbox_style.dart';
part 'min_checkbox_painter.dart';

enum MinCheckboxSize { sm, md, lg }

class MinCheckbox extends StatefulWidget {
  const MinCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = MinCheckboxSize.md,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.side,
    this.checkColor,
    this.checkIcon,
    this.checkPainter,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final MinCheckboxSize size;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? side;
  final Color? checkColor;
  final Widget? checkIcon;
  final CustomPainter? checkPainter;
  final String? semanticLabel;

  @override
  State<MinCheckbox> createState() => _MinCheckboxState();
}

class _MinCheckboxState extends State<MinCheckbox> {
  late final FocusNode _focusNode;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _toggle() {
    if (_enabled) {
      widget.onChanged?.call(!widget.value);
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        _toggle();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _CheckboxStyle.resolve(
      theme: theme,
      size: widget.size,
      hovered: _hovered,
      focused: _focused,
      enabled: _enabled,
      checked: widget.value,
      side: widget.side,
      checkColor: widget.checkColor,
    );

    return Semantics(
      checked: widget.value,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: _onKeyEvent,
        child: MouseRegion(
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: theme.motion.curve,
              width: style.size,
              height: style.size,
              decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(style.radius),
                border: Border.all(
                  color: style.borderColor,
                  width: style.borderWidth,
                ),
                boxShadow: style.shadows,
              ),
              child: Center(
                child: AnimatedCrossFade(
                  duration: theme.motion.fast,
                  crossFadeState: widget.value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: widget.checkIcon != null
                      ? IconTheme(
                          data: IconThemeData(
                            color: style.checkColor,
                            size: style.iconSize,
                          ),
                          child: widget.checkIcon!,
                        )
                      : CustomPaint(
                          painter:
                              widget.checkPainter ??
                              _DefaultCheckmarkPainter(color: style.checkColor),
                          size: Size(style.iconSize, style.iconSize),
                        ),
                  secondChild: Container(
                    width: style.iconSize * .8,
                    height: style.iconSize * .2,
                    decoration: BoxDecoration(
                      color: style.borderColor,
                      borderRadius: BorderRadius.circular(style.radius / 2),
                    ),
                    child: SizedBox.shrink(),
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
