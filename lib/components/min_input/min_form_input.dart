import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'min_input.dart';

/// Drop-in [FormField] wrapper around [MinInput].
///
/// Mirrors the [TextFormField] ergonomics ([initialValue], [controller],
/// [validator], [autovalidateMode], [forceErrorText], [onChanged],
/// [onSubmitted], [restorationId]) while reusing the [MinInput] look
/// and feel — including its focus ring, counter and leading/trailing
/// slots.
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: MinFormInput(
///     placeholder: 'tu@correo.com',
///     type: MinInputType.email,
///     validator: (v) => (v == null || !v.contains('@'))
///         ? 'Email inválido'
///         : null,
///   ),
/// )
/// ```
class MinFormInput extends FormField<String> {
  MinFormInput({
    super.key,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    this.placeholder,
    this.type = MinInputType.text,
    this.variant = MinInputVariant.normal,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.leading,
    this.trailing,
    this.obscureText,
    this.autocorrect,
    this.enableSuggestions = true,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.showCounter = false,
    this.semanticLabel,
    this.height,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.enabled = true,
    super.forceErrorText,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.restorationId,
  }) : assert(initialValue == null || controller == null),
       assert(maxLines == null || maxLines > 0, 'maxLines debe ser > 0'),
       assert(minLines == null || minLines > 0, 'minLines debe ser > 0'),
       assert(
         minLines == null || maxLines == null || minLines <= maxLines,
         'minLines no puede ser mayor que maxLines',
       ),
       assert(
         !(type == MinInputType.multiline && maxLines == 1),
         'MinInputType.multiline no puede tener maxLines = 1',
       ),
       assert(
         !(type == MinInputType.password && maxLines != null && maxLines > 1),
         'MinInputType.password no puede tener maxLines > 1',
       ),
       super(
         initialValue: controller != null ? controller.text : (initialValue ?? ''),
         builder: (FormFieldState<String> field) {
           final state = field as _MinFormInputState;
           final effectiveError = field.errorText;

           return MinInput(
             controller: state._effectiveController,
             focusNode: focusNode,
             placeholder: placeholder,
             leading: leading,
             trailing: trailing,
             enabled: enabled,
             autofocus: autofocus,
             type: type,
             variant: effectiveError != null
                 ? MinInputVariant.error
                 : variant,
             style: style,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             textCapitalization: textCapitalization,
             maxLength: maxLength,
             obscureText: obscureText,
             onChanged: state._handleChanged,
             onSubmitted: (value) {
               state._handleSubmitted();
               onSubmitted?.call(value);
             },
             onEditingComplete: () {
               state._handleSubmitted();
               onEditingComplete?.call();
             },
             inputFormatters: inputFormatters,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             height: height,
             contentPadding: contentPadding,
             maxLines: maxLines,
             minLines: minLines,
             showCounter: showCounter,
             errorText: effectiveError,
             semanticLabel: semanticLabel,
           );
         },
       );

  /// Controls the text being edited.
  ///
  /// If null, this widget creates its own [TextEditingController] and
  /// initializes its `text` with [initialValue].
  final TextEditingController? controller;

  /// Placeholder shown when the field is empty.
  final String? placeholder;

  /// Semantic input type (text, email, number, phone, url, password).
  final MinInputType type;

  /// Visual variant.
  final MinInputVariant variant;

  /// Optional style override.
  final MinInputStyle? style;

  /// Keyboard type override.
  final TextInputType? keyboardType;

  /// Text input action override.
  final TextInputAction? textInputAction;

  /// Text capitalization strategy.
  final TextCapitalization textCapitalization;

  /// Auto-focus when the widget is first rendered.
  final bool autofocus;

  /// Widget shown before the editable area.
  final Widget? leading;

  /// Widget shown after the editable area.
  final Widget? trailing;

  /// Whether to obscure the text (passwords).
  final bool? obscureText;

  /// Whether autocorrect is enabled.
  final bool? autocorrect;

  /// Whether IME suggestions are enabled.
  final bool enableSuggestions;

  /// Maximum allowed length.
  final int? maxLength;

  /// Maximum number of lines. Ignored when [type] is not [MinInputType.multiline].
  final int? maxLines;

  /// Minimum number of lines. Ignored when [type] is not [MinInputType.multiline].
  final int? minLines;

  /// Show a character counter when [maxLength] is set.
  final bool showCounter;

  /// Accessibility label.
  final String? semanticLabel;

  /// Fixed height override.
  final double? height;

  /// Inner padding of the field.
  final EdgeInsets contentPadding;

  /// Called when the user initiates a change to the field value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the value (Enter / IME action).
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is completed.
  final VoidCallback? onEditingComplete;

  /// Input formatters applied to the field.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether the field is enabled. Disabled fields ignore input and
  /// show a muted appearance.
  @override
  // ignore: overridden_fields
  final bool enabled;

  @override
  FormFieldState<String> createState() => _MinFormInputState();
}

class _MinFormInputState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _minFormField.controller ?? _controller!;

  MinFormInput get _minFormField => super.widget as MinFormInput;

  @override
  void initState() {
    super.initState();
    if (_minFormField.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      _minFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(MinFormInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_minFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _minFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _minFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_minFormField.controller != null) {
        setValue(_minFormField.controller!.text);
        if (oldWidget.controller == null) {
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _minFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.value = TextEditingValue(text: value ?? '');
    }
  }

  @override
  void reset() {
    _effectiveController.value = TextEditingValue(
      text: widget.initialValue ?? '',
    );
    super.reset();
    _minFormField.onChanged?.call(_effectiveController.text);
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? TextEditingController()
        : TextEditingController.fromValue(value);
  }

  void _handleChanged(String value) {
    didChange(value);
    _minFormField.onChanged?.call(value);
  }

  void _handleSubmitted() {
    setState(() => validate());
  }
}
