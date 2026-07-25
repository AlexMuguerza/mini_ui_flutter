import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Tamaño del acordeón.
enum MinAccordionSize { sm, md, lg }

/// Opción individual dentro de [MinAccordion].
class MinAccordionOption<T> {
  const MinAccordionOption({
    required this.value,
    required this.header,
    required this.body,
    this.disabled = false,
  });

  final T value;
  final Widget header;
  final Widget body;
  final bool disabled;
}

/// Acordeón expandible/colapsable con animación.
///
/// Soporta expansión simple (default) o múltiple con [multiple].
/// Navegación por teclado (Enter/Espacio para toggle), foco visible.
///
/// ```dart
/// MinAccordion<String>(
///   options: [
///     MinAccordionOption(
///       value: '1',
///       header: Text('Item 1'),
///       body: Text('Contenido 1'),
///     ),
///   ],
///   value: {'1'},
///   onChanged: (v) {},
/// )
/// ```
class MinAccordion<T> extends StatefulWidget {
  const MinAccordion({
    super.key,
    required this.options,
    this.value = const {},
    this.onChanged,
    this.multiple = false,
    this.size = MinAccordionSize.md,
    this.keepChildren = true,
    this.headerPadding,
    this.bodyPadding,
    this.icon,
  });

  final List<MinAccordionOption<T>> options;
  final Set<T> value;
  final ValueChanged<Set<T>>? onChanged;
  final bool multiple;
  final MinAccordionSize size;
  final bool keepChildren;

  /// Padding del header de cada item. `null` usa el default según [size].
  final EdgeInsets? headerPadding;

  /// Padding del body de cada item. `null` usa el default según [size].
  final EdgeInsets? bodyPadding;

  /// Widget del chevron colapsable. Por defecto usa [_ChevronPainter].
  final Widget? icon;

  @override
  State<MinAccordion<T>> createState() => _MinAccordionState<T>();
}

class _MinAccordionState<T> extends State<MinAccordion<T>> {
  final Set<int> _hoveredIndices = {};
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    assert(widget.options.isNotEmpty, 'options must not be empty');
    assert(
      widget.value.isEmpty ||
          widget.value.every((v) => widget.options.any((o) => o.value == v)),
      'each value must exist in options',
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

  void _toggle(T value) {
    final next = Set<T>.from(widget.value);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      if (!widget.multiple) next.clear();
      next.add(value);
    }
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final sizeStyle = _resolveSize(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.options.length; i++)
          _buildItem(theme, sizeStyle, i),
      ],
    );
  }

  Widget _buildItem(MinThemeData theme, _AccordionSizeStyle sizeStyle, int i) {
    final option = widget.options[i];
    final isExpanded = widget.value.contains(option.value);
    final isHovered = _hoveredIndices.contains(i);
    final isDisabled = option.disabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (i > 0) Container(height: 1, color: theme.colors.border),
        Focus(
          focusNode: _focusNodeForIndex(i),
          child: GestureDetector(
            onTap: isDisabled ? null : () => _toggle(option.value),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndices.add(i)),
              onExit: (_) => setState(() => _hoveredIndices.remove(i)),
              child: Semantics(
                label: isExpanded ? 'Colapsar' : 'Expandir',
                child: AnimatedContainer(
                  duration: theme.motion.fast,
                  curve: theme.motion.curve,
                  padding: widget.headerPadding ?? sizeStyle.headerPadding,
                  decoration: BoxDecoration(
                    color: isHovered ? theme.colors.accent : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: option.header),
                      widget.icon ??
                          AnimatedRotation(
                            turns: isExpanded ? 0.75 : 0.25,
                            duration: theme.motion.fast,
                            curve: theme.motion.curve,
                            child: SizedBox(
                              width: sizeStyle.iconSize,
                              height: sizeStyle.iconSize,
                              child: CustomPaint(
                                painter: _ChevronPainter(
                                  color: theme.colors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: widget.bodyPadding ?? sizeStyle.bodyPadding,
            child: option.body,
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: theme.motion.fast,
          firstCurve: theme.motion.curve,
          secondCurve: theme.motion.curve,
          sizeCurve: theme.motion.curve,
        ),
      ],
    );
  }

  _AccordionSizeStyle _resolveSize(MinThemeData theme) {
    final vPadding = switch (widget.size) {
      MinAccordionSize.sm => theme.spacing.s1,
      MinAccordionSize.md => theme.spacing.s2,
      MinAccordionSize.lg => theme.spacing.s3,
    };
    final iconSize = switch (widget.size) {
      MinAccordionSize.sm => 16.0,
      MinAccordionSize.md => 20.0,
      MinAccordionSize.lg => 24.0,
    };
    final bodyPadding = switch (widget.size) {
      MinAccordionSize.sm => const EdgeInsets.only(bottom: 4),
      MinAccordionSize.md => const EdgeInsets.only(bottom: 8),
      MinAccordionSize.lg => const EdgeInsets.only(bottom: 12),
    };

    return _AccordionSizeStyle(
      headerPadding: EdgeInsets.symmetric(vertical: vPadding),
      iconSize: iconSize,
      bodyPadding: bodyPadding,
    );
  }
}

class _AccordionSizeStyle {
  const _AccordionSizeStyle({
    required this.headerPadding,
    required this.iconSize,
    required this.bodyPadding,
  });

  final EdgeInsets headerPadding;
  final double iconSize;
  final EdgeInsets bodyPadding;
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.2)
      ..lineTo(size.width * 0.75, size.height * 0.5)
      ..lineTo(size.width * 0.50, size.height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => oldDelegate.color != color;
}
