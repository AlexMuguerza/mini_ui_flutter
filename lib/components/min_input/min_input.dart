import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/tokens.dart';
import 'min_input_style.dart';

export 'min_input_style.dart' show MinInputStyle;

enum MinInputType {
  text,
  email,
  password,
  number,
  phone,
  url,
  multiline,
}

enum MinInputVariant {
  normal,
  error,
}

class MinInput extends StatefulWidget {
  const MinInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.leading,
    this.trailing,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.type = MinInputType.text,
    this.variant = MinInputVariant.normal,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.obscureText,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.autocorrect,
    this.enableSuggestions = true,
    this.height,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.showCounter = false,
    this.semanticLabel,
  }) : assert(height == null || height > 0, 'height debe ser > 0'),
       assert(maxLines == null || maxLines > 0, 'maxLines debe ser > 0'),
       assert(minLines == null || minLines > 0, 'minLines debe ser > 0'),
       assert(
         minLines == null || maxLines == null || minLines <= maxLines,
         'minLines ($minLines) no puede ser mayor que maxLines ($maxLines)',
       ),
       assert(maxLength == null || maxLength > 0, 'maxLength debe ser > 0'),
       assert(
         !(type == MinInputType.multiline && maxLines == 1),
         'Un campo de tipo multiline no puede tener maxLines = 1',
       ),
       assert(
         !(type == MinInputType.password && maxLines != null && maxLines > 1),
         'Un campo de tipo password no puede tener maxLines > 1',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final Widget? leading;
  final Widget? trailing;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final MinInputType type;
  final MinInputVariant variant;
  final MinInputStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autocorrect;
  final bool enableSuggestions;
  final double? height;
  final EdgeInsets contentPadding;
  final bool showCounter;
  final String? semanticLabel;

  @override
  State<MinInput> createState() => _MinInputState();
}

class _MinInputState extends State<MinInput> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();
  Offset? _pointerDownPosition;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  bool get _isSingleLine => _resolvedMaxLines == 1;

  int? get _resolvedMaxLines {
    if (widget.maxLines != null) return widget.maxLines;
    return widget.type == MinInputType.multiline ? null : 1;
  }

  int get _resolvedMinLines => widget.minLines ?? 1;

  double get _lineHeightPx => 16 * 1.5;

  double _heightForLines(int lines) =>
      widget.contentPadding.vertical + (_lineHeightPx * lines);

  BoxConstraints? get _resolvedFieldConstraints {
    if (widget.height != null) {
      return BoxConstraints.tight(Size.fromHeight(widget.height!));
    }
    if (_isSingleLine) {
      return const BoxConstraints(minHeight: 40);
    }
    final computedMin = _heightForLines(_resolvedMinLines);
    final effectiveMinHeight = computedMin < 40.0 ? 40.0 : computedMin;
    return BoxConstraints(minHeight: effectiveMinHeight);
  }

  bool get _resolvedObscureText =>
      widget.obscureText ?? (widget.type == MinInputType.password);

  TextInputType get _resolvedKeyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;
    return switch (widget.type) {
      MinInputType.email => TextInputType.emailAddress,
      MinInputType.password => TextInputType.visiblePassword,
      MinInputType.number => const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      MinInputType.phone => TextInputType.phone,
      MinInputType.url => TextInputType.url,
      MinInputType.multiline => TextInputType.multiline,
      MinInputType.text => TextInputType.text,
    };
  }

  TextInputAction get _resolvedAction {
    if (widget.textInputAction != null) return widget.textInputAction!;
    return widget.type == MinInputType.multiline
        ? TextInputAction.newline
        : TextInputAction.done;
  }

  bool get _resolvedAutocorrect {
    if (widget.autocorrect != null) return widget.autocorrect!;
    return widget.type != MinInputType.password &&
        widget.type != MinInputType.email;
  }

  bool get _resolvedEnableSuggestions {
    if (widget.type == MinInputType.password) return false;
    return widget.enableSuggestions;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MinInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _ownedController;
      oldController?.removeListener(_handleControllerChanged);
      _controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      final oldFocusNode = oldWidget.focusNode ?? _ownedFocusNode;
      oldFocusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  void _handleFieldTap() {
    if (!widget.enabled || widget.readOnly) return;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else {
      _editableKey.currentState?.requestKeyboard();
    }
  }

  void _handleTapOutside(PointerDownEvent _) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final hasError =
        widget.variant == MinInputVariant.error ||
        (widget.errorText?.isNotEmpty ?? false);
    final isFocused = _focusNode.hasFocus;
    final isDisabled = !widget.enabled || widget.readOnly;

    final inputStyle = widget.style ?? MinInputStyle.outline(theme);

    final BoxDecoration decoration;
    if (isDisabled) {
      decoration = inputStyle.disabled;
    } else if (hasError) {
      decoration = inputStyle.error;
    } else if (isFocused) {
      decoration = inputStyle.focused;
    } else {
      decoration = inputStyle.idle;
    }

    final foregroundColor = isDisabled
        ? (inputStyle.disabledForegroundColor ?? theme.colors.mutedForeground)
        : (inputStyle.foregroundColor ?? theme.colors.foreground);

    final placeholderColor =
        inputStyle.placeholderColor ?? theme.colors.mutedForeground;

    final activeBorderColor = hasError
        ? (inputStyle.error.border as Border?)?.bottom.color ??
              theme.colors.destructive
        : (inputStyle.focused.border as Border?)?.bottom.color ??
              theme.colors.ring;

    final effectivePadding = inputStyle.contentPadding ?? widget.contentPadding;

    final editable = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: _resolvedKeyboardType,
      textInputAction: _resolvedAction,
      textCapitalization: widget.textCapitalization,
      maxLines: _resolvedMaxLines,
      minLines: _resolvedMinLines,
      readOnly: widget.readOnly || !widget.enabled,
      autofocus: widget.autofocus,
      obscureText: _resolvedObscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
        ...?widget.inputFormatters,
      ],
      autocorrect: _resolvedAutocorrect,
      enableSuggestions: _resolvedEnableSuggestions,
      style: theme.typography.body.copyWith(
        color: foregroundColor,
        height: 1.5,
      ),
      cursorColor: activeBorderColor,
      backgroundCursorColor: theme.colors.mutedForeground,
      onTapOutside: _handleTapOutside,
    );

    Widget field = Stack(
      alignment: _isSingleLine ? Alignment.centerLeft : Alignment.topLeft,
      children: [
        TextFieldTapRegion(child: editable),
        if (_controller.text.isEmpty && widget.placeholder != null)
          IgnorePointer(
            child: Text(
              widget.placeholder!,
              style: theme.typography.body.copyWith(
                color: placeholderColor,
                height: 1.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );

    Widget inputArea = TextFieldTapRegion(
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          _pointerDownPosition = event.position;
        },
        onPointerUp: (event) {
          final down = _pointerDownPosition;
          if (down == null) return;
          final delta = (event.position - down).distance;
          _pointerDownPosition = null;
          if (delta < 10) _handleFieldTap();
        },
        onPointerCancel: (_) {
          _pointerDownPosition = null;
        },
        child: Container(
          constraints: _resolvedFieldConstraints,
          child: TweenAnimationBuilder<Decoration>(
            tween: DecorationTween(end: decoration),
            duration: theme.motion.fast,
            curve: theme.motion.curve,
            builder: (context, animatedDecoration, child) => DecoratedBox(
              decoration: animatedDecoration,
              child: Padding(padding: effectivePadding, child: child),
            ),
            child: Row(
              crossAxisAlignment: _isSingleLine
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (widget.leading != null) ...[
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 16),
                    child: widget.leading!,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(child: field),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 8),
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 16),
                    child: widget.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    Widget content = inputArea;

    final showCounterWidget = widget.showCounter &&
        widget.maxLength != null &&
        widget.maxLength! > 0;

    if (showCounterWidget) {
      final currentLength = _controller.text.length;
      final maxLength = widget.maxLength!;
      final counterColor = currentLength >= maxLength
          ? theme.colors.destructive
          : theme.colors.mutedForeground;

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          SizedBox(height: theme.spacing.s1),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$currentLength / $maxLength',
              style: theme.typography.small.copyWith(color: counterColor),
            ),
          ),
        ],
      );
    }

    if (hasError) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          if (widget.errorText?.isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Text(
              widget.errorText!,
              style: theme.typography.small.copyWith(
                color: theme.colors.destructive,
              ),
            ),
          ],
        ],
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      enabled: widget.enabled,
      textField: true,
      child: content,
    );
  }
}
