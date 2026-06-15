import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../theme/tokens.dart';
import 'min_button.dart';

/// Representa una opción individual dentro de un [MinButtonGroup].
///
/// Contiene el valor de la opción y si está habilitada.
class MinButtonGroupOption<T> {
  /// Crea una opción para [MinButtonGroup].
  const MinButtonGroupOption({required this.value, this.enabled = true});

  /// Valor único que identifica esta opción.
  final T value;

  /// Si es `false`, la opción está deshabilitada y no responde a taps.
  final bool enabled;
}

/// Grupo de botones con selección única, completamente controlado desde afuera.
///
/// Widget genérico `<T>` que trabaja con cualquier tipo de dato.
/// Recibe una lista de [MinButtonGroupOption], el valor seleccionado
/// actualmente y un callback [onChanged].
///
/// ### Características
/// - Selección única controlada (controlled component).
/// - Estados visuales: seleccionado, no seleccionado, deshabilitado,
///   hover, pressed.
/// - Animaciones suaves de selección.
/// - Bordes redondeados con esquinas internas planas.
/// - Soporte de accesibilidad (Semantics).
/// - Responsive: se adapta al tamaño del contenido (horizontal y vertical).
///
/// ### Uso básico
/// ```dart
/// enum Color { red, green, blue }
///
/// MinButtonGroup<Color>(
///   options: const [
///     MinButtonGroupOption(value: Color.red),
///     MinButtonGroupOption(value: Color.green),
///     MinButtonGroupOption(value: Color.blue),
///   ],
///   value: _selectedColor,
///   onChanged: (color) => setState(() => _selectedColor = color),
///   labelBuilder: (color) => Text(color.name),
/// )
/// ```
///
/// ### Con opciones deshabilitadas
/// ```dart
/// MinButtonGroup<String>(
///   options: const [
///     MinButtonGroupOption(value: 'a'),
///     MinButtonGroupOption(value: 'b', enabled: false),
///     MinButtonGroupOption(value: 'c'),
///   ],
///   value: _selected,
///   onChanged: (v) => setState(() => _selected = v),
///   labelBuilder: (v) => Text(v),
/// )
/// ```
class MinButtonGroup<T> extends StatefulWidget {
  const MinButtonGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    this.direction = Axis.horizontal,
    this.size = MinButtonSize.md,
    this.variant = MinButtonVariant.outline,
    this.semanticLabel,
  });

  /// Lista de opciones disponibles en el grupo.
  final List<MinButtonGroupOption<T>> options;

  /// Valor seleccionado actualmente.
  final T? value;

  /// Callback llamado cuando se selecciona una opción.
  ///
  /// Recibe el valor de la opción seleccionada.
  final ValueChanged<T> onChanged;

  /// Callback que renderiza el widget de texto para cada opción.
  ///
  /// Útil para personalizar la apariencia del contenido de cada botón.
  final Widget Function(T value) labelBuilder;

  /// Dirección del grupo: horizontal (default) o vertical.
  final Axis direction;

  /// Tamaño aplicado a todos los botones del grupo.
  final MinButtonSize size;

  /// Variante visual aplicada a todos los botones no seleccionados.
  ///
  /// El botón seleccionado siempre usa [MinButtonVariant.primary].
  final MinButtonVariant variant;

  /// Etiqueta de accesibilidad del grupo.
  final String? semanticLabel;

  @override
  State<MinButtonGroup<T>> createState() => _MinButtonGroupState<T>();
}

class _MinButtonGroupState<T> extends State<MinButtonGroup<T>> {
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(
      widget.options.length,
      (_) => FocusNode(),
    );
  }

  @override
  void didUpdateWidget(covariant MinButtonGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options.length != widget.options.length) {
      for (final node in _focusNodes) {
        node.dispose();
      }
      _focusNodes = List.generate(
        widget.options.length,
        (_) => FocusNode(),
      );
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleArrowKey(int currentIndex, bool isNext) {
    final enabledIndices = <int>[];
    for (var i = 0; i < widget.options.length; i++) {
      if (widget.options[i].enabled) enabledIndices.add(i);
    }
    if (enabledIndices.isEmpty) return;

    final posInEnabled = enabledIndices.indexOf(currentIndex);
    if (posInEnabled == -1) return;

    final nextPos = isNext
        ? (posInEnabled + 1) % enabledIndices.length
        : (posInEnabled - 1 + enabledIndices.length) % enabledIndices.length;

    _focusNodes[enabledIndices[nextPos]].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final radius = _getRadius(widget.size, theme);
    final count = widget.options.length;

    final items = List.generate(count, (i) {
      final option = widget.options[i];
      final isSelected = option.value == widget.value;

      return _GroupButton<T>(
        option: option,
        isSelected: isSelected,
        size: widget.size,
        variant: widget.variant,
        borderRadius: widget.direction == Axis.horizontal
            ? _horizontalRadius(i, count, radius)
            : _verticalRadius(i, count, radius),
        labelBuilder: widget.labelBuilder,
        onChanged: widget.onChanged,
        focusNode: _focusNodes[i],
        onArrowKey: _handleArrowKey,
        index: i,
        direction: widget.direction,
      );
    });

    return Semantics(
      label: widget.semanticLabel,
      explicitChildNodes: true,
      child: widget.direction == Axis.vertical
          ? Center(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items,
                ),
              ),
            )
          : Row(mainAxisSize: MainAxisSize.min, children: items),
    );
  }

  double _getRadius(MinButtonSize size, MinThemeData theme) {
    switch (size) {
      case MinButtonSize.sm:
        return theme.radius.sm;
      case MinButtonSize.md:
        return theme.radius.md;
      case MinButtonSize.lg:
        return theme.radius.lg;
    }
  }

  BorderRadius _horizontalRadius(int index, int count, double radius) {
    if (count == 1) return BorderRadius.circular(radius);
    final isFirst = index == 0;
    final isLast = index == count - 1;
    return BorderRadius.only(
      topLeft: isFirst ? Radius.circular(radius) : Radius.zero,
      bottomLeft: isFirst ? Radius.circular(radius) : Radius.zero,
      topRight: isLast ? Radius.circular(radius) : Radius.zero,
      bottomRight: isLast ? Radius.circular(radius) : Radius.zero,
    );
  }

  BorderRadius _verticalRadius(int index, int count, double radius) {
    if (count == 1) return BorderRadius.circular(radius);
    final isFirst = index == 0;
    final isLast = index == count - 1;
    return BorderRadius.only(
      topLeft: isFirst ? Radius.circular(radius) : Radius.zero,
      topRight: isFirst ? Radius.circular(radius) : Radius.zero,
      bottomLeft: isLast ? Radius.circular(radius) : Radius.zero,
      bottomRight: isLast ? Radius.circular(radius) : Radius.zero,
    );
  }
}

// ---------------------------------------------------------------------------
// Botón interno del grupo
// ---------------------------------------------------------------------------

class _GroupButton<T> extends StatefulWidget {
  const _GroupButton({
    required this.option,
    required this.isSelected,
    required this.size,
    required this.variant,
    required this.borderRadius,
    required this.labelBuilder,
    required this.onChanged,
    required this.focusNode,
    required this.onArrowKey,
    required this.index,
    required this.direction,
  });

  final MinButtonGroupOption<T> option;
  final bool isSelected;
  final MinButtonSize size;
  final MinButtonVariant variant;
  final BorderRadius borderRadius;
  final Widget Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;
  final FocusNode focusNode;
  final void Function(int index, bool isNext) onArrowKey;
  final int index;
  final Axis direction;

  @override
  State<_GroupButton<T>> createState() => _GroupButtonState<T>();
}

class _GroupButtonState<T> extends State<_GroupButton<T>> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.option.enabled;

  void _handleTap() {
    if (_enabled) {
      widget.onChanged(widget.option.value);
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final isHorizontal = widget.direction == Axis.horizontal;
    final isNextKey = isHorizontal
        ? event.logicalKey == LogicalKeyboardKey.arrowRight
        : event.logicalKey == LogicalKeyboardKey.arrowDown;
    final isPrevKey = isHorizontal
        ? event.logicalKey == LogicalKeyboardKey.arrowLeft
        : event.logicalKey == LogicalKeyboardKey.arrowUp;

    if (isNextKey) {
      widget.onArrowKey(widget.index, true);
      return KeyEventResult.handled;
    }
    if (isPrevKey) {
      widget.onArrowKey(widget.index, false);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        setState(() => _pressed = true);
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        setState(() => _pressed = false);
        _handleTap();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _GroupButtonStyle.resolve(
      theme: theme,
      size: widget.size,
      isSelected: widget.isSelected,
      enabled: _enabled,
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.isSelected,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: false,
        onFocusChange: (v) => setState(() => _focused = v),
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
            onTap: _enabled ? _handleTap : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: _enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: AnimatedContainer(
              duration: theme.motion.normal,
              curve: theme.motion.curve,
              height: style.height,
              padding: EdgeInsets.symmetric(
                horizontal: style.horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: widget.borderRadius,
                border: Border.all(
                  color: style.border,
                  width: theme.spacing.px,
                ),
                boxShadow: style.shadows,
              ),
              child: DefaultTextStyle(
                style: style.textStyle.copyWith(color: style.foreground),
                child: AnimatedOpacity(
                  duration: theme.motion.fast,
                  opacity: _enabled ? 1 : 0.5,
                  child: Center(
                    child: widget.labelBuilder(widget.option.value),
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

// ---------------------------------------------------------------------------
// Estilo del botón del grupo
// ---------------------------------------------------------------------------

class _GroupButtonStyle {
  const _GroupButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.textStyle,
    required this.shadows,
    required this.height,
    required this.horizontalPadding,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final TextStyle textStyle;
  final List<BoxShadow> shadows;
  final double height;
  final double horizontalPadding;

  static _GroupButtonStyle resolve({
    required MinThemeData theme,
    required MinButtonSize size,
    required bool isSelected,
    required bool enabled,
    required bool hovered,
    required bool pressed,
    required bool focused,
  }) {
    // Background
    Color background;
    if (!enabled) {
      background = theme.colors.muted;
    } else if (isSelected) {
      background = theme.colors.primary;
    } else if (pressed) {
      background = theme.colors.accent;
    } else if (hovered) {
      background = theme.colors.accent;
    } else {
      background = theme.colors.background;
    }

    // Foreground
    Color foreground;
    if (!enabled) {
      foreground = theme.colors.mutedForeground;
    } else if (isSelected) {
      foreground = theme.colors.primaryForeground;
    } else {
      foreground = theme.colors.foreground;
    }

    // Border
    Color border;
    if (!enabled) {
      border = theme.colors.border;
    } else if (focused) {
      border = theme.colors.ring;
    } else if (isSelected) {
      border = theme.colors.primary;
    } else {
      border = theme.colors.border;
    }

    // Shadows
    List<BoxShadow> shadows;
    if (focused) {
      shadows = [
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(90),
        ),
      ];
    } else {
      shadows = const [];
    }

    // Size
    switch (size) {
      case MinButtonSize.sm:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.small,
          shadows: shadows,
          height: theme.spacing.s10 - theme.spacing.s1,
          horizontalPadding: theme.spacing.s3,
        );
      case MinButtonSize.md:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.body,
          shadows: shadows,
          height: theme.spacing.s10,
          horizontalPadding: theme.spacing.s4,
        );
      case MinButtonSize.lg:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.h3,
          shadows: shadows,
          height: theme.spacing.s10 + theme.spacing.s2,
          horizontalPadding: theme.spacing.s5,
        );
    }
  }
}
