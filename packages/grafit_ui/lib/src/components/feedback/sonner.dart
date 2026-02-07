import 'dart:async';

import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../form/button.dart';

/// Toast position
enum GrafitToastPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Toast variant
enum GrafitToastVariant {
  basic,
  success,
  error,
  warning,
  info,
  loading,
}

/// Toast data class
class GrafitToastData {
  final String id;
  final String? title;
  final String? description;
  final GrafitToastVariant variant;
  final Duration duration;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Widget? customIcon;
  final bool showProgress;
  final double? progress;
  final DateTime createdAt;

  GrafitToastData({
    required this.id,
    this.title,
    this.description,
    this.variant = GrafitToastVariant.basic,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.customIcon,
    this.showProgress = false,
    this.progress,
  }) : createdAt = DateTime.now();

  GrafitToastData copyWith({
    String? id,
    String? title,
    String? description,
    GrafitToastVariant? variant,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    Widget? customIcon,
    bool? showProgress,
    double? progress,
  }) {
    return GrafitToastData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      variant: variant ?? this.variant,
      duration: duration ?? this.duration,
      onDismiss: onDismiss ?? this.onDismiss,
      onAction: onAction ?? this.onAction,
      actionLabel: actionLabel ?? this.actionLabel,
      customIcon: customIcon ?? this.customIcon,
      showProgress: showProgress ?? this.showProgress,
      progress: progress ?? this.progress,
    );
  }
}

/// Toast manager - singleton for managing toasts
class GrafitToastManager extends ChangeNotifier {
  static final GrafitToastManager _instance = GrafitToastManager._internal();
  factory GrafitToastManager() => _instance;
  GrafitToastManager._internal();

  final List<GrafitToastData> _toasts = [];
  final Map<String, Timer> _timers = {};

  List<GrafitToastData> get toasts => List.unmodifiable(_toasts);

  void addToast(GrafitToastData toast) {
    _toasts.add(toast);
    notifyListeners();

    // Auto-dismiss after duration
    if (toast.duration > Duration.zero) {
      _timers[toast.id] = Timer(toast.duration, () {
        removeToast(toast.id);
      });
    }
  }

  void updateToast(String id, GrafitToastData updated) {
    final index = _toasts.indexWhere((t) => t.id == id);
    if (index != -1) {
      _toasts[index] = updated;
      notifyListeners();
    }
  }

  void removeToast(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    final toastIndex = _toasts.indexWhere((t) => t.id == id);
    if (toastIndex != -1) {
      _toasts[toastIndex].onDismiss?.call();
      _toasts.removeAt(toastIndex);
      notifyListeners();
    }
  }

  void clear() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _toasts.clear();
    notifyListeners();
  }
}

/// GrafitSonner - Toast notification widget
class GrafitSonner extends StatefulWidget {
  final GrafitToastPosition position;
  final int maxToasts;
  final bool expandByDefault;
  final Duration duration;
  final Widget? child;

  const GrafitSonner({
    super.key,
    this.position = GrafitToastPosition.bottomRight,
    this.maxToasts = 3,
    this.expandByDefault = false,
    this.duration = const Duration(seconds: 4),
    this.child,
  });

  @override
  State<GrafitSonner> createState() => _GrafitSonnerState();

  /// Show a basic toast
  static String showToast(
    BuildContext context, {
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    Widget? customIcon,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title,
      description: description,
      variant: GrafitToastVariant.basic,
      duration: duration ?? const Duration(seconds: 4),
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      customIcon: customIcon,
    ));
    return id;
  }

  /// Show a success toast
  static String showSuccess(
    BuildContext context, {
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title ?? 'Success',
      description: description,
      variant: GrafitToastVariant.success,
      duration: duration ?? const Duration(seconds: 4),
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    ));
    return id;
  }

  /// Show an error toast
  static String showError(
    BuildContext context, {
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title ?? 'Error',
      description: description,
      variant: GrafitToastVariant.error,
      duration: duration ?? const Duration(seconds: 4),
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    ));
    return id;
  }

  /// Show a warning toast
  static String showWarning(
    BuildContext context, {
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title ?? 'Warning',
      description: description,
      variant: GrafitToastVariant.warning,
      duration: duration ?? const Duration(seconds: 4),
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    ));
    return id;
  }

  /// Show an info toast
  static String showInfo(
    BuildContext context, {
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title ?? 'Info',
      description: description,
      variant: GrafitToastVariant.info,
      duration: duration ?? const Duration(seconds: 4),
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    ));
    return id;
  }

  /// Show a loading toast
  static String showLoading(
    BuildContext context, {
    String? title,
    String? description,
    VoidCallback? onDismiss,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    manager.addToast(GrafitToastData(
      id: id,
      title: title ?? 'Loading...',
      description: description,
      variant: GrafitToastVariant.loading,
      duration: Duration.zero, // No auto-dismiss for loading
      onDismiss: onDismiss,
    ));
    return id;
  }

  /// Show a promise toast - automatically handles success/error
  static String showPromise<T>(
    BuildContext context,
    Future<T> Function() promise, {
    String? loadingTitle,
    String? loadingDescription,
    String? successTitle,
    String? successDescription,
    String? errorTitle,
    String? errorDescription,
    Duration? successDuration,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    final manager = GrafitToastManager();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Show loading toast
    manager.addToast(GrafitToastData(
      id: id,
      title: loadingTitle ?? 'Loading...',
      description: loadingDescription,
      variant: GrafitToastVariant.loading,
      duration: Duration.zero,
      showProgress: true,
      progress: null,
    ));

    // Execute promise
    promise().then((result) {
      // Update to success
      final currentToast = manager.toasts.firstWhere(
        (t) => t.id == id,
        orElse: () => manager.toasts.isNotEmpty ? manager.toasts.first : GrafitToastData(id: id),
      );
      manager.updateToast(
        id,
        currentToast.copyWith(
          title: successTitle ?? 'Success',
          description: successDescription,
          variant: GrafitToastVariant.success,
          duration: successDuration ?? const Duration(seconds: 3),
          showProgress: false,
        ),
      );
      onSuccess?.call();
    }).catchError((error) {
      // Update to error
      final currentToast = manager.toasts.firstWhere(
        (t) => t.id == id,
        orElse: () => manager.toasts.isNotEmpty ? manager.toasts.first : GrafitToastData(id: id),
      );
      manager.updateToast(
        id,
        currentToast.copyWith(
          title: errorTitle ?? 'Error',
          description: errorDescription ?? error.toString(),
          variant: GrafitToastVariant.error,
          duration: const Duration(seconds: 4),
          showProgress: false,
        ),
      );
      onError?.call();
    });

    return id;
  }

  /// Dismiss a specific toast
  static void dismiss(BuildContext context, String id) {
    GrafitToastManager().removeToast(id);
  }

  /// Dismiss all toasts
  static void dismissAll(BuildContext context) {
    GrafitToastManager().clear();
  }
}

class _GrafitSonnerState extends State<GrafitSonner> {
  final GrafitToastManager _manager = GrafitToastManager();

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onToastsChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onToastsChanged);
    super.dispose();
  }

  void _onToastsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final toasts = _manager.toasts;
    final displayToasts = toasts.take(widget.maxToasts).toList();

    if (displayToasts.isEmpty) {
      return widget.child ?? const SizedBox.shrink();
    }

    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        _GrafitToastContainer(
          toasts: displayToasts,
          position: widget.position,
          onDismiss: (id) => _manager.removeToast(id),
          onAction: (id) {
            final toastIndex = toasts.indexWhere((t) => t.id == id);
            if (toastIndex != -1) {
              toasts[toastIndex].onAction?.call();
            }
            _manager.removeToast(id);
          },
        ),
      ],
    );
  }
}

/// Toast container - positions toasts at screen edge
class _GrafitToastContainer extends StatelessWidget {
  final List<GrafitToastData> toasts;
  final GrafitToastPosition position;
  final void Function(String) onDismiss;
  final void Function(String) onAction;

  const _GrafitToastContainer({
    required this.toasts,
    required this.position,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isTop = position == GrafitToastPosition.topLeft ||
        position == GrafitToastPosition.topCenter ||
        position == GrafitToastPosition.topRight;

    return Positioned.fill(
      child: Padding(
        padding: _getPadding(),
        child: Align(
          alignment: _getAlignment(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
            children: isTop
                ? toasts
                    .map((toast) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _GrafitToastItem(
                            toast: toast,
                            onDismiss: onDismiss,
                            onAction: onAction,
                          ),
                        ))
                    .toList()
                : toasts
                    .reversed
                    .map((toast) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _GrafitToastItem(
                            toast: toast,
                            onDismiss: onDismiss,
                            onAction: onAction,
                          ),
                        ))
                    .toList(),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (position) {
      case GrafitToastPosition.topLeft:
      case GrafitToastPosition.topCenter:
      case GrafitToastPosition.topRight:
        return const EdgeInsets.only(top: 16, left: 16, right: 16);
      case GrafitToastPosition.bottomLeft:
      case GrafitToastPosition.bottomCenter:
      case GrafitToastPosition.bottomRight:
        return const EdgeInsets.only(bottom: 16, left: 16, right: 16);
    }
  }

  Alignment _getAlignment() {
    switch (position) {
      case GrafitToastPosition.topLeft:
        return Alignment.topLeft;
      case GrafitToastPosition.topCenter:
        return Alignment.topCenter;
      case GrafitToastPosition.topRight:
        return Alignment.topRight;
      case GrafitToastPosition.bottomLeft:
        return Alignment.bottomLeft;
      case GrafitToastPosition.bottomCenter:
        return Alignment.bottomCenter;
      case GrafitToastPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (position) {
      case GrafitToastPosition.topLeft:
      case GrafitToastPosition.bottomLeft:
        return CrossAxisAlignment.start;
      case GrafitToastPosition.topCenter:
      case GrafitToastPosition.bottomCenter:
        return CrossAxisAlignment.center;
      case GrafitToastPosition.topRight:
      case GrafitToastPosition.bottomRight:
        return CrossAxisAlignment.end;
    }
  }
}

/// Individual toast item with animation
class _GrafitToastItem extends StatefulWidget {
  final GrafitToastData toast;
  final void Function(String) onDismiss;
  final void Function(String) onAction;

  const _GrafitToastItem({
    required this.toast,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  State<_GrafitToastItem> createState() => _GrafitToastItemState();
}

class _GrafitToastItemState extends State<_GrafitToastItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: _GrafitToastContent(
        toast: widget.toast,
        onDismiss: () => widget.onDismiss(widget.toast.id),
        onAction: () => widget.onAction(widget.toast.id),
      ),
    );
  }
}

/// Toast content widget
class _GrafitToastContent extends StatelessWidget {
  final GrafitToastData toast;
  final VoidCallback onDismiss;
  final VoidCallback onAction;

  const _GrafitToastContent({
    required this.toast,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final toastColors = _getToastColors(colors);

    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 400),
      decoration: BoxDecoration(
        color: toastColors.background,
        border: Border.all(color: toastColors.border),
        borderRadius: BorderRadius.circular(colors.radius * 8),
        boxShadow: [
          BoxShadow(
            color: colors.foreground.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(colors.radius * 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (toast.showProgress && toast.variant == GrafitToastVariant.loading)
              LinearProgressIndicator(
                backgroundColor: toastColors.progressBackground,
                valueColor: AlwaysStoppedAnimation(toastColors.progress),
                minHeight: 2,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (toast.customIcon != null)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: toast.customIcon,
                    )
                  else
                    Icon(
                      _getIcon(),
                      color: toastColors.foreground,
                      size: 20,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (toast.title != null)
                          Text(
                            toast.title!,
                            style: TextStyle(
                              color: toastColors.foreground,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (toast.title != null && toast.description != null)
                          const SizedBox(height: 4),
                        if (toast.description != null)
                          Text(
                            toast.description!,
                            style: TextStyle(
                              color: toastColors.foreground.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                        if (toast.onAction != null && toast.actionLabel != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: GestureDetector(
                              onTap: onAction,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: toastColors.actionBackground,
                                  borderRadius: BorderRadius.circular(
                                    colors.radius * 4,
                                  ),
                                ),
                                child: Text(
                                  toast.actionLabel!,
                                  style: TextStyle(
                                    color: toastColors.foreground,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Icon(
                      Icons.close,
                      color: toastColors.foreground.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ToastColors _getToastColors(GrafitColorScheme colors) {
    return switch (toast.variant) {
      GrafitToastVariant.basic => _ToastColors(
          background: colors.background,
          foreground: colors.foreground,
          border: colors.border,
          progress: colors.primary,
          progressBackground: colors.muted,
          actionBackground: colors.primary.withValues(alpha: 0.1),
        ),
      GrafitToastVariant.success => _ToastColors(
          background: const Color(0xFF14532D).withValues(alpha: 0.95),
          foreground: const Color(0xFF86EFAC),
          border: const Color(0xFF166534),
          progress: const Color(0xFF86EFAC),
          progressBackground: const Color(0xFF14532D),
          actionBackground: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
        ),
      GrafitToastVariant.error => _ToastColors(
          background: const Color(0xFF450A0A).withValues(alpha: 0.95),
          foreground: const Color(0xFFFCA5A5),
          border: const Color(0xFF7F1D1D),
          progress: const Color(0xFFFCA5A5),
          progressBackground: const Color(0xFF450A0A),
          actionBackground: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
        ),
      GrafitToastVariant.warning => _ToastColors(
          background: const Color(0xFF422006).withValues(alpha: 0.95),
          foreground: const Color(0xFFFCD34D),
          border: const Color(0xFF78350F),
          progress: const Color(0xFFFCD34D),
          progressBackground: const Color(0xFF422006),
          actionBackground: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
        ),
      GrafitToastVariant.info => _ToastColors(
          background: colors.primary.withValues(alpha: 0.95),
          foreground: colors.primaryForeground,
          border: colors.primary,
          progress: colors.primaryForeground,
          progressBackground: colors.primary.withValues(alpha: 0.3),
          actionBackground: colors.primaryForeground.withValues(alpha: 0.15),
        ),
      GrafitToastVariant.loading => _ToastColors(
          background: colors.background,
          foreground: colors.foreground,
          border: colors.border,
          progress: colors.primary,
          progressBackground: colors.muted,
          actionBackground: colors.primary.withValues(alpha: 0.1),
        ),
    };
  }

  IconData? _getIcon() {
    return switch (toast.variant) {
      GrafitToastVariant.basic => null,
      GrafitToastVariant.success => Icons.check_circle_outline,
      GrafitToastVariant.error => Icons.cancel_outlined,
      GrafitToastVariant.warning => Icons.warning_amber_outlined,
      GrafitToastVariant.info => Icons.info_outline,
      GrafitToastVariant.loading => null,
    };
  }
}

/// Toast colors data class
class _ToastColors {
  final Color background;
  final Color foreground;
  final Color border;
  final Color progress;
  final Color progressBackground;
  final Color actionBackground;

  const _ToastColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.progress,
    required this.progressBackground,
    required this.actionBackground,
  });
}

/// Helper extension for easier toast usage
extension GrafitSonnerExtension on BuildContext {
  /// Show a basic toast
  String showToast({
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    Widget? customIcon,
  }) {
    return GrafitSonner.showToast(
      this,
      title: title,
      description: description,
      duration: duration,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      customIcon: customIcon,
    );
  }

  /// Show a success toast
  String showSuccess({
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return GrafitSonner.showSuccess(
      this,
      title: title,
      description: description,
      duration: duration,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show an error toast
  String showError({
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return GrafitSonner.showError(
      this,
      title: title,
      description: description,
      duration: duration,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show a warning toast
  String showWarning({
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return GrafitSonner.showWarning(
      this,
      title: title,
      description: description,
      duration: duration,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show an info toast
  String showInfo({
    String? title,
    String? description,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return GrafitSonner.showInfo(
      this,
      title: title,
      description: description,
      duration: duration,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show a loading toast
  String showLoading({
    String? title,
    String? description,
    VoidCallback? onDismiss,
  }) {
    return GrafitSonner.showLoading(
      this,
      title: title,
      description: description,
      onDismiss: onDismiss,
    );
  }

  /// Show a promise toast
  String showPromise<T>(
    Future<T> Function() promise, {
    String? loadingTitle,
    String? loadingDescription,
    String? successTitle,
    String? successDescription,
    String? errorTitle,
    String? errorDescription,
    Duration? successDuration,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    return GrafitSonner.showPromise<T>(
      this,
      promise,
      loadingTitle: loadingTitle,
      loadingDescription: loadingDescription,
      successTitle: successTitle,
      successDescription: successDescription,
      errorTitle: errorTitle,
      errorDescription: errorDescription,
      successDuration: successDuration,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Dismiss a specific toast
  void dismissToast(String id) {
    GrafitSonner.dismiss(this, id);
  }

  /// Dismiss all toasts
  void dismissAllToasts() {
    GrafitSonner.dismissAll(this);
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerDefault(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GrafitButton(
            label: 'Show Toast',
            onPressed: () {
              context.showToast(
                title: 'Hello World',
                description: 'This is a basic toast notification',
              );
            },
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Success',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerSuccess(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Success',
        onPressed: () {
          context.showSuccess(
            title: 'Success',
            description: 'Your changes have been saved',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Error',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerError(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Error',
        onPressed: () {
          context.showError(
            title: 'Error',
            description: 'Something went wrong. Please try again.',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Warning',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerWarning(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Warning',
        onPressed: () {
          context.showWarning(
            title: 'Warning',
            description: 'Your session is about to expire',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Info',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerInfo(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Info',
        onPressed: () {
          context.showInfo(
            title: 'Information',
            description: 'You have 3 new notifications',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerLoading(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GrafitButton(
            label: 'Show Loading',
            onPressed: () {
              final id = context.showLoading(
                title: 'Processing',
                description: 'Please wait while we process your request...',
              );
              // Dismiss after 3 seconds
              Future.delayed(const Duration(seconds: 3), () {
                context.dismissToast(id);
              });
            },
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Action',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerWithAction(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Toast With Action',
        onPressed: () {
          context.showToast(
            title: 'New Update Available',
            description: 'A new version of the app is ready to install',
            actionLabel: 'Update Now',
            onAction: () {
              // Handle action
            },
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple Positions',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerPositions(BuildContext context) {
  final position = context.knobs.list(
    label: 'Position',
    initialOption: GrafitToastPosition.bottomRight,
    options: [
      GrafitToastPosition.topLeft,
      GrafitToastPosition.topCenter,
      GrafitToastPosition.topRight,
      GrafitToastPosition.bottomLeft,
      GrafitToastPosition.bottomCenter,
      GrafitToastPosition.bottomRight,
    ],
  );

  return GrafitSonner(
    position: position,
    child: Center(
      child: GrafitButton(
        label: 'Show Toast',
        onPressed: () {
          context.showToast(
            title: 'Position: ${position.name}',
            description: 'Toast appears at ${position.name}',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Promise',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerPromise(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: GrafitButton(
        label: 'Show Promise Toast',
        onPressed: () {
          context.showPromise(
            () async {
              await Future.delayed(const Duration(seconds: 2));
              if (context.mounted) {
                return 'Success!';
              }
              throw Exception('Failed');
            }(),
            loadingTitle: 'Loading...',
            loadingDescription: 'Fetching data from server',
            successTitle: 'Complete',
            successDescription: 'Data loaded successfully',
            errorTitle: 'Error',
            errorDescription: 'Failed to load data',
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Variants',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerAllVariants(BuildContext context) {
  return GrafitSonner(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          GrafitButton(
            label: 'Basic',
            variant: GrafitButtonVariant.primary,
            onPressed: () => context.showToast(title: 'Basic Toast'),
          ),
          GrafitButton(
            label: 'Success',
            variant: GrafitButtonVariant.primary,
            onPressed: () => context.showSuccess(title: 'Success!'),
          ),
          GrafitButton(
            label: 'Error',
            variant: GrafitButtonVariant.destructive,
            onPressed: () => context.showError(title: 'Error!'),
          ),
          GrafitButton(
            label: 'Warning',
            variant: GrafitButtonVariant.primary,
            onPressed: () => context.showWarning(title: 'Warning!'),
          ),
          GrafitButton(
            label: 'Info',
            variant: GrafitButtonVariant.secondary,
            onPressed: () => context.showInfo(title: 'Info'),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitSonner,
  path: 'Feedback/Sonner',
)
Widget sonnerInteractive(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Notification');
  final description = context.knobs.string(label: 'Description', initialValue: 'You have a new message');
  final variant = context.knobs.list(
    label: 'Variant',
    initialOption: GrafitToastVariant.basic,
    options: [
      GrafitToastVariant.basic,
      GrafitToastVariant.success,
      GrafitToastVariant.error,
      GrafitToastVariant.warning,
      GrafitToastVariant.info,
    ],
  );
  final position = context.knobs.list(
    label: 'Position',
    initialOption: GrafitToastPosition.bottomRight,
    options: [
      GrafitToastPosition.topLeft,
      GrafitToastPosition.topCenter,
      GrafitToastPosition.topRight,
      GrafitToastPosition.bottomLeft,
      GrafitToastPosition.bottomCenter,
      GrafitToastPosition.bottomRight,
    ],
  );
  final maxToasts = context.knobs.int.slider(
    label: 'Max Toasts',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  return GrafitSonner(
    position: position,
    maxToasts: maxToasts,
    child: Center(
      child: GrafitButton(
        label: 'Show Toast',
        onPressed: () {
          switch (variant) {
            case GrafitToastVariant.basic:
              context.showToast(title: title, description: description);
              break;
            case GrafitToastVariant.success:
              context.showSuccess(title: title, description: description);
              break;
            case GrafitToastVariant.error:
              context.showError(title: title, description: description);
              break;
            case GrafitToastVariant.warning:
              context.showWarning(title: title, description: description);
              break;
            case GrafitToastVariant.info:
              context.showInfo(title: title, description: description);
              break;
            case GrafitToastVariant.loading:
              context.showLoading(title: title, description: description);
              break;
          }
        },
      ),
    ),
  );
}
