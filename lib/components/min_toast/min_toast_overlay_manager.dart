import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../theme/tokens.dart';
import 'min_toast_action.dart';
import 'min_toast_entry.dart';
import 'min_toast_item.dart';
import 'min_toast_position.dart';
import 'min_toast_type.dart';

/// Singleton que gestiona el overlay y la cola de toasts.
class MinToastOverlayManager {
  MinToastOverlayManager._();
  static final MinToastOverlayManager _instance = MinToastOverlayManager._();
  factory MinToastOverlayManager() => _instance;

  OverlayEntry? _entry;
  final List<MinToastEntry> _entries = [];

  /// Agrega un toast a la cola y lo muestra en pantalla.
  void show({
    required BuildContext context,
    required String id,
    required String title,
    Widget? icon,
    String? message,
    MinToastAction? action,
    MinToastType? type,
    required Duration duration,
    MinToastPosition? position,
    int? maxVisible,
    VoidCallback? onDismissed,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final entry = MinToastEntry(
      id: id,
      type: type ?? MinToastType.info,
      title: title,
      message: message,
      action: action,
      icon: icon,
      duration: duration,
      position: position,
      maxVisible: maxVisible,
      onDismissed: onDismissed,
    );

    _entries.add(entry);

    if (maxVisible != null) {
      final pos = position ?? MinToastPosition.bottomCenter;
      final key = pos.positionKey;
      var groupCount = 0;
      for (int i = _entries.length - 1; i >= 0; i--) {
        final ePos = _entries[i].position ?? MinToastPosition.bottomCenter;
        if (ePos.positionKey == key) {
          groupCount++;
        }
      }
      if (groupCount > maxVisible) {
        var toRemove = groupCount - maxVisible;
        int i = 0;
        while (toRemove > 0 && i < _entries.length) {
          final ePos = _entries[i].position ?? MinToastPosition.bottomCenter;
          if (ePos.positionKey == key) {
            final removed = _entries.removeAt(i);
            _cancelTimers(removed);
            toRemove--;
          } else {
            i++;
          }
        }
      }
    }

    if (_entry == null) {
      _entry = OverlayEntry(builder: _buildOverlay);
      overlay.insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }

    _startTimer(entry);
  }

  void _startTimer(MinToastEntry entry) {
    entry.timerController?.forward(from: 0);
    entry.autoDismissTimer = Timer(entry.duration, () {
      _scheduleDismiss(entry.id);
    });
  }

  void _cancelTimers(MinToastEntry entry) {
    entry.autoDismissTimer?.cancel();
    entry.autoDismissTimer = null;
  }

  /// Limpia todos los toasts y remueve el overlay del [Overlay].
  void reset() {
    for (final e in _entries) {
      _cancelTimers(e);
    }
    _entries.clear();
    _entry?.remove();
    _entry = null;
  }

  void _scheduleDismiss(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final entry = _entries[index];
    if (entry.isDismissing) return;
    entry.isDismissing = true;
    entry.autoDismissTimer?.cancel();
    _entry?.markNeedsBuild();
  }

  /// Descarta un toast por su [id] y lo remueve de la cola.
  void dismissById(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final entry = _entries[index];
    _cancelTimers(entry);
    _entries.removeAt(index);
    entry.onDismissed?.call();

    if (_entries.isEmpty) {
      _removeEntry();
    } else {
      _entry?.markNeedsBuild();
    }
  }

  /// Descarta todos los toasts visibles inmediatamente.
  void dismissAll() {
    for (final e in _entries) {
      _cancelTimers(e);
      e.onDismissed?.call();
    }
    _entries.clear();
    _removeEntry();
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  /// Pausa el temporizador de auto-dismiss de un toast.
  void pauseTimer(String id) {
    final i = _entries.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final entry = _entries[i];
    if (entry.isPaused) return;
    entry.isPaused = true;
    entry.timerController?.stop();
    entry.autoDismissTimer?.cancel();
  }

  /// Reanuda el temporizador de auto-dismiss de un toast.
  void resumeTimer(String id) {
    final i = _entries.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final entry = _entries[i];
    if (!entry.isPaused) return;
    entry.isPaused = false;
    entry.timerController?.forward();
    final remaining = entry.remainingDuration;
    entry.autoDismissTimer = Timer(
      remaining > Duration.zero ? remaining : const Duration(milliseconds: 100),
      () => _scheduleDismiss(entry.id),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return MinToastOverlayWidget(
      entries: List.unmodifiable(_entries),
      onDismiss: dismissById,
      onPause: pauseTimer,
      onResume: resumeTimer,
    );
  }
}

/// Widget interno que renderiza los toasts dentro del [OverlayEntry].
class MinToastOverlayWidget extends StatefulWidget {
  const MinToastOverlayWidget({
    super.key,
    required this.entries,
    required this.onDismiss,
    required this.onPause,
    required this.onResume,
  });

  /// Lista de toasts a renderizar.
  final List<MinToastEntry> entries;

  /// Callback para descartar un toast por su id.
  final void Function(String id) onDismiss;

  /// Callback para pausar el temporizador de un toast.
  final void Function(String id) onPause;

  /// Callback para reanudar el temporizador de un toast.
  final void Function(String id) onResume;

  @override
  State<MinToastOverlayWidget> createState() => MinToastOverlayWidgetState();
}

class MinToastOverlayWidgetState extends State<MinToastOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;
    if (entries.isEmpty) return const SizedBox.shrink();

    final theme = MinTheme.maybeOf(context);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screen = Size(constraints.maxWidth, constraints.maxHeight);

          final groups = <String, List<MinToastEntry>>{};
          for (final entry in entries) {
            final pos = entry.position ?? MinToastPosition.bottomCenter;
            groups.putIfAbsent(pos.positionKey, () => []).add(entry);
          }

          return Stack(
            children: [
              for (final group in groups.values)
                ..._buildGroup(group, screen, theme),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildGroup(
    List<MinToastEntry> group,
    Size screen,
    MinThemeData? theme,
  ) {
    final pos = group.first.position ?? MinToastPosition.bottomCenter;
    if (pos.top != null) {
      return _buildTopStack(group, screen, pos, theme);
    }
    return _buildBottomStack(group, screen, pos, theme);
  }

  List<Widget> _buildBottomStack(
    List<MinToastEntry> entries,
    Size screen,
    MinToastPosition pos,
    MinThemeData? theme,
  ) {
    final overlap = 28.0;
    final total = entries.length;
    final items = <Widget>[];

    for (int i = 0; i < total; i++) {
      final entry = entries[i];
      items.add(
        AnimatedPositioned(
          key: ValueKey('toast_${entry.id}'),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          bottom: (pos.bottom ?? 16) + (total - 1 - i) * overlap,
          left: pos.left ?? (pos.right == null ? 16 : null),
          right: pos.right ?? (pos.left == null ? 16 : null),
          child: Align(
            alignment: Alignment.center,
            child: MinToastStackWrapper(
              index: total - 1 - i,
              totalVisible: total,
              entry: entry,
              onDismiss: () => widget.onDismiss(entry.id),
              onPause: () => widget.onPause(entry.id),
              onResume: () => widget.onResume(entry.id),
              theme: theme,
            ),
          ),
        ),
      );
    }
    return items;
  }

  List<Widget> _buildTopStack(
    List<MinToastEntry> entries,
    Size screen,
    MinToastPosition pos,
    MinThemeData? theme,
  ) {
    final overlap = 28.0;
    final total = entries.length;
    final items = <Widget>[];

    for (int i = 0; i < total; i++) {
      final entry = entries[i];
      items.add(
        AnimatedPositioned(
          key: ValueKey('toast_${entry.id}'),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          top: (pos.top ?? 16) + (total - 1 - i) * overlap,
          left: pos.left ?? (pos.right == null ? 16 : null),
          right: pos.right ?? (pos.left == null ? 16 : null),
          child: Align(
            alignment: Alignment.center,
            child: MinToastStackWrapper(
              index: total - 1 - i,
              totalVisible: total,
              entry: entry,
              onDismiss: () => widget.onDismiss(entry.id),
              onPause: () => widget.onPause(entry.id),
              onResume: () => widget.onResume(entry.id),
              theme: theme,
            ),
          ),
        ),
      );
    }
    return items;
  }
}

class MinToastStackWrapper extends StatelessWidget {
  const MinToastStackWrapper({
    super.key,
    required this.index,
    required this.totalVisible,
    required this.entry,
    required this.onDismiss,
    required this.onPause,
    required this.onResume,
    this.theme,
  });

  final int index;
  final int totalVisible;
  final MinToastEntry entry;
  final VoidCallback onDismiss;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final MinThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - index * 0.04;
    final opacity = 1.0 - index * 0.08;

    Widget child = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity.clamp(0.0, 1.0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: math.max(scale, 0.7),
        child: MinToastItem(
          entry: entry,
          onDismiss: onDismiss,
          onPause: onPause,
          onResume: onResume,
          theme: theme,
        ),
      ),
    );

    child = AbsorbPointer(absorbing: index > 0, child: child);

    return child;
  }
}
