import 'package:flutter/widgets.dart';
import '../../theme/tokens.dart';
import 'min_toast_action.dart';
import 'min_toast_entry.dart';
import 'min_toast_painter.dart';
import 'min_toast_type.dart';

/// Widget que renderiza un toast individual con animaciones de entrada/salida,
/// barra de progreso temporal y soporte para swipe para descartar.
class MinToastItem extends StatefulWidget {
  const MinToastItem({
    super.key,
    required this.entry,
    required this.onDismiss,
    required this.onPause,
    required this.onResume,
    this.theme,
  });

  /// Datos del toast a renderizar.
  final MinToastEntry entry;

  /// Callback al completar la animación de salida.
  final VoidCallback onDismiss;

  /// Callback al hacer hover (pausa el temporizador).
  final VoidCallback onPause;

  /// Callback al salir del hover (reanuda el temporizador).
  final VoidCallback onResume;

  /// Tema opcional (usa [MinTheme.of] si no se provee).
  final MinThemeData? theme;

  @override
  State<MinToastItem> createState() => _MinToastItemState();
}

class _MinToastItemState extends State<MinToastItem>
    with TickerProviderStateMixin {
  late AnimationController _entryAnim;
  late AnimationController _timerAnim;
  double _dragX = 0;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _timerAnim = AnimationController(
      vsync: this,
      duration: widget.entry.duration,
    );
    widget.entry.enterController = _entryAnim;
    widget.entry.timerController = _timerAnim;
    _entryAnim.addListener(() {
      setState(() {});
    });
    _timerAnim.addListener(() {
      setState(() {});
    });
    _entryAnim.forward(from: 0);
    _timerAnim.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant MinToastItem old) {
    super.didUpdateWidget(old);
    if (widget.entry.isDismissing && !_isExiting) {
      _startExit();
    }
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _timerAnim.dispose();
    super.dispose();
  }

  void _startExit() {
    _isExiting = true;
    _entryAnim.reverse(from: 1.0).then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (_isExiting) return;
    final w = context.size?.width ?? 200;
    if (_dragX.abs() > w * 0.4 || (details.primaryVelocity?.abs() ?? 0) > 500) {
      _startExit();
    } else {
      setState(() => _dragX = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final theme = widget.theme ?? context.theme;

    final enterValue = _entryAnim.value;
    final opacity = enterValue;
    final yOffset = (1.0 - enterValue) * 20;
    double xOffset = _dragX;
    if (_isExiting) xOffset += (1.0 - enterValue) * 150;

    return MouseRegion(
      onEnter: (_) => widget.onPause(),
      onExit: (_) => widget.onResume(),
      child: GestureDetector(
        onHorizontalDragUpdate: (d) => setState(() => _dragX += d.delta.dx),
        onHorizontalDragEnd: _handleSwipeEnd,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(xOffset, -yOffset),
            child: _ToastContent(
              entry: entry,
              timerValue: _timerAnim.value,
              theme: theme,
              onClose: _startExit,
              onAction: entry.action?.onPressed,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({
    required this.entry,
    required this.timerValue,
    required this.theme,
    required this.onClose,
    this.onAction,
  });

  final MinToastEntry entry;
  final double timerValue;
  final MinThemeData theme;
  final VoidCallback onClose;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final type = entry.type;

    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.radius.lg),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: theme.colors.card,
          borderRadius: BorderRadius.circular(theme.radius.lg),
          border: Border.all(color: theme.colors.border),
          boxShadow: theme.shadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(theme.spacing.s4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Icon(type: type, icon: entry.icon),
                  SizedBox(width: theme.spacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                entry.title,
                                style: theme.typography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colors.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: theme.spacing.s2),
                            _Close(onClose: onClose, theme: theme),
                          ],
                        ),
                        if (entry.message != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            entry.message!,
                            style: theme.typography.small.copyWith(
                              color: theme.colors.mutedForeground,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (entry.action != null)
              _ActionButton(action: entry.action!, theme: theme),
            _TimerBar(value: timerValue, color: type.color, theme: theme),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.type, this.icon});
  final MinToastType type;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return SizedBox(width: 20, height: 20, child: icon);
    }

    final painter = switch (type) {
      MinToastType.info => MinToastInfoPainter(color: type.color),
      MinToastType.warning => MinToastWarningPainter(color: type.color),
      MinToastType.success => MinToastSuccessPainter(color: type.color),
      MinToastType.error => MinToastErrorPainter(color: type.color),
    };

    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: painter),
    );
  }
}

class _Close extends StatelessWidget {
  const _Close({required this.onClose, required this.theme});
  final VoidCallback onClose;
  final MinThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(
          painter: MinToastClosePainter(color: theme.colors.mutedForeground),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.theme});
  final MinToastAction action;
  final MinThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s4,
          vertical: theme.spacing.s2,
        ),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.colors.border)),
        ),
        child: Text(
          action.label,
          style: theme.typography.small.copyWith(
            color: theme.colors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({
    required this.value,
    required this.color,
    required this.theme,
  });
  final double value;
  final Color color;
  final MinThemeData theme;

  @override
  Widget build(BuildContext context) {
    final progress = (1.0 - value).clamp(0.0, 1.0);
    return SizedBox(
      height: 3,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        child: CustomPaint(
          painter: MinToastTimerPainter(
            progress: progress,
            color: color.withAlpha(180),
            backgroundColor: theme.colors.muted.withAlpha(80),
          ),
        ),
      ),
    );
  }
}
