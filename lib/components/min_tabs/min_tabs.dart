import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/tokens.dart';

part 'min_tabs_style.dart';

/// Tamaño de las tabs.
enum MinTabsSize { sm, md, lg }

/// Variante visual de las tabs.
///
/// * [underline] — línea inferior en la tab seleccionada (estilo shadcn/ui).
/// * [pill] — fondo contrastante en la tab seleccionada (estilo segmented control).
enum MinTabsVariant { underline, pill }

/// Opción individual dentro de [MinTabs].
class MinTabsOption<T> {
  const MinTabsOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });

  /// Valor asociado a esta opción.
  final T value;

  /// Widget de etiqueta (normalmente un [Text]).
  final Widget label;

  /// Icono opcional mostrado antes del [label].
  final Widget? icon;

  /// Si `true` la opción no es interactuable.
  final bool disabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinTabsOption<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          disabled == other.disabled;

  @override
  int get hashCode => value.hashCode;
}

/// Componente de tabs con selección controlada.
///
/// Soporta dos variantes: [MinTabsVariant.underline] (línea inferior) y
/// [MinTabsVariant.pill] (fondo tipo segmented control). Navegación por
/// teclado (flechas, Enter/Espacio), foco visible y opción deshabilitada.
///
/// Cuando [scrollable] es `true` el contenedor ocupa todo el ancho disponible
/// y las tabs scrollean horizontalmente si no entran.
class MinTabs<T> extends StatefulWidget {
  const MinTabs({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.variant = MinTabsVariant.underline,
    this.size = MinTabsSize.md,
    this.semanticLabel,
    this.scrollable = false,
  }) : super();

  /// Lista de opciones a mostrar como tabs.
  final List<MinTabsOption<T>> options;

  /// Valor actualmente seleccionado.
  ///
  /// Debe coincidir con el [MinTabsOption.value] de alguna opción.
  final T? value;

  /// Callback llamado cuando el usuario selecciona una tab.
  final ValueChanged<T> onChanged;

  /// Estilo visual de las tabs.
  final MinTabsVariant variant;

  /// Tamaño de las tabs.
  final MinTabsSize size;

  /// Etiqueta semántica para lectores de pantalla.
  final String? semanticLabel;

  /// Si `true` habilita scroll horizontal interno cuando las tabs no entran.
  ///
  /// Cuando es `false` (default) el contenedor se ajusta al ancho del contenido.
  final bool scrollable;

  @override
  State<MinTabs<T>> createState() => _MinTabsState<T>();
}

class _MinTabsState<T> extends State<MinTabs<T>> {
  final Map<int, FocusNode> _focusNodes = {};
  final Set<int> _hoveredIndices = {};
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    assert(widget.options.isNotEmpty, 'options must not be empty');
    assert(
      widget.value == null ||
          widget.options.any((o) => o.value == widget.value),
      'value must be one of the options',
    );
  }

  @override
  void dispose() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  FocusNode _focusNodeForIndex(int index) =>
      _focusNodes.putIfAbsent(index, () => FocusNode());

  void _handleArrowKey(int currentIndex, bool isNext) {
    final enabledIndices = <int>[];
    for (var i = 0; i < widget.options.length; i++) {
      if (!widget.options[i].disabled) enabledIndices.add(i);
    }
    if (enabledIndices.isEmpty) return;
    final posInEnabled = enabledIndices.indexOf(currentIndex);
    final nextPos = isNext
        ? (posInEnabled + 1) % enabledIndices.length
        : (posInEnabled - 1 + enabledIndices.length) % enabledIndices.length;
    final targetIndex = enabledIndices[nextPos];
    setState(() => _focusedIndex = targetIndex);
    _focusNodeForIndex(targetIndex).requestFocus();
  }

  void _handleTap(int index) {
    final option = widget.options[index];
    if (!option.disabled) {
      widget.onChanged(option.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Semantics(
      label: widget.semanticLabel,
      explicitChildNodes: true,
      child: _buildTabBar(theme),
    );
  }

  Widget _buildTabBar(MinThemeData theme) {
    final style = _TabsStyle.resolve(theme: theme, size: widget.size);

    if (widget.scrollable) {
      final bar = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = option.value == widget.value;
            final isHovered = _hoveredIndices.contains(index);
            final isFocused = _focusedIndex == index;

            return _buildTabItem(
              theme: theme,
              style: style,
              index: index,
              option: option,
              isSelected: isSelected,
              isHovered: isHovered,
              isFocused: isFocused,
            );
          }).toList(),
        ),
      );

      if (widget.variant == MinTabsVariant.underline) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colors.border, width: 1),
            ),
          ),
          child: bar,
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: theme.colors.muted,
          borderRadius: BorderRadius.circular(theme.radius.sm),
          border: Border.all(color: theme.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(2),
        child: bar,
      );
    }

    final bar = Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = option.value == widget.value;
        final isHovered = _hoveredIndices.contains(index);
        final isFocused = _focusedIndex == index;

        return _buildTabItem(
          theme: theme,
          style: style,
          index: index,
          option: option,
          isSelected: isSelected,
          isHovered: isHovered,
          isFocused: isFocused,
        );
      }).toList(),
    );

    Widget container;

    if (widget.variant == MinTabsVariant.underline) {
      container = Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.colors.border, width: 1),
          ),
        ),
        child: bar,
      );
    } else {
      container = Container(
        decoration: BoxDecoration(
          color: theme.colors.muted,
          borderRadius: BorderRadius.circular(theme.radius.sm),
          border: Border.all(color: theme.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(2),
        child: bar,
      );
    }

    return IntrinsicWidth(child: container);
  }

  Widget _buildTabItem({
    required MinThemeData theme,
    required _TabsStyle style,
    required int index,
    required MinTabsOption<T> option,
    required bool isSelected,
    required bool isHovered,
    required bool isFocused,
  }) {
    final enabled = !option.disabled;
    final itemStyle = _TabItemStyle.resolve(
      theme: theme,
      variant: widget.variant,
      selected: isSelected,
      hovered: isHovered,
      focused: isFocused,
      disabled: !enabled,
    );

    return Focus(
      focusNode: _focusNodeForIndex(index),
      autofocus: false,
      onKeyEvent: (node, event) => _onKeyEvent(node, event, index, enabled),
      onFocusChange: (focused) {
        if (focused) setState(() => _focusedIndex = index);
      },
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: enabled
            ? (_) => setState(() => _hoveredIndices.add(index))
            : null,
        onExit: enabled
            ? (_) => setState(() => _hoveredIndices.remove(index))
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => _handleTap(index) : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: style.horizontalPadding,
              vertical: style.verticalPadding,
            ),
            decoration: BoxDecoration(
              color: itemStyle.background,
              border: _resolveBorder(theme, isSelected, isFocused),
              borderRadius: widget.variant == MinTabsVariant.pill
                  ? BorderRadius.circular(theme.radius.sm)
                  : null,
              boxShadow: widget.variant == MinTabsVariant.pill && isSelected
                  ? theme.shadows.md
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.icon != null) ...[
                  option.icon!,
                  SizedBox(width: theme.spacing.s2),
                ],
                DefaultTextStyle(
                  style: style.labelStyle.copyWith(color: itemStyle.foreground),
                  child: option.label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Border? _resolveBorder(MinThemeData theme, bool isSelected, bool isFocused) {
    if (isFocused) {
      return Border.all(color: theme.colors.ring, width: 2);
    }
    if (widget.variant == MinTabsVariant.underline && isSelected) {
      return Border(bottom: BorderSide(color: theme.colors.primary, width: 2));
    }
    return null;
  }

  KeyEventResult _onKeyEvent(
    FocusNode node,
    KeyEvent event,
    int index,
    bool enabled,
  ) {
    if (!enabled) return KeyEventResult.ignored;

    final isPrev = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final isNext = event.logicalKey == LogicalKeyboardKey.arrowRight;

    if (isNext || isPrev) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        _handleArrowKey(index, isNext);
        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) return KeyEventResult.handled;
      if (event is KeyUpEvent) {
        _handleTap(index);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }
}
