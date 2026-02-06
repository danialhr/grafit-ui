import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Clickable primitive with gesture handling and states
class GrafitClickable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final HitTestBehavior behavior;
  final bool excludeFromSemantics;
  final bool enabled;

  const GrafitClickable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.behavior = HitTestBehavior.opaque,
    this.excludeFromSemantics = false,
    this.enabled = true,
  });

  @override
  State<GrafitClickable> createState() => _GrafitClickableState();
}

class _GrafitClickableState extends State<GrafitClickable> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = widget.enabled && widget.onTap != null;

    Widget result = FocusableActionDetector(
      enabled: effectiveEnabled,
      onShowFocusHighlight: (value) {
        setState(() {
          _isFocused = value;
        });
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            if (effectiveEnabled) {
              widget.onTap?.call();
              return true;
            }
            return false;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (intent) {
            if (effectiveEnabled) {
              widget.onTap?.call();
              return true;
            }
            return false;
          },
        ),
      },
      child: MouseRegion(
        cursor: effectiveEnabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (event) {
          if (effectiveEnabled) {
            setState(() {
              _isHovered = true;
            });
          }
        },
        onExit: (event) {
          if (effectiveEnabled) {
            setState(() {
              _isHovered = false;
            });
          }
        },
        child: GestureDetector(
          behavior: widget.behavior,
          onTap: effectiveEnabled ? widget.onTap : null,
          onLongPress: effectiveEnabled ? widget.onLongPress : null,
          onTapDown: effectiveEnabled
              ? (details) {
                  setState(() {
                    _isPressed = true;
                  });
                  widget.onTapDown?.call(details);
                }
              : null,
          onTapUp: effectiveEnabled
              ? (details) {
                  setState(() {
                    _isPressed = false;
                  });
                  widget.onTapUp?.call(details);
                }
              : null,
          onTapCancel: effectiveEnabled
              ? () {
                  setState(() {
                    _isPressed = false;
                  });
                }
              : null,
          child: _GrafitClickableInherited(
            isHovered: _isHovered,
            isPressed: _isPressed,
            isFocused: _isFocused,
            child: widget.child,
          ),
        ),
      ),
    );

    if (!widget.excludeFromSemantics && widget.onTap != null) {
      result = Semantics(
        button: true,
        enabled: effectiveEnabled,
        excludeSemantics: true,
        child: result,
      );
    }

    return result;
  }
}

/// Inherited widget to share clickable state with descendants
class _GrafitClickableInherited extends InheritedWidget {
  final bool isHovered;
  final bool isPressed;
  final bool isFocused;

  const _GrafitClickableInherited({
    required this.isHovered,
    required this.isPressed,
    required this.isFocused,
    required super.child,
  });

  static _GrafitClickableInherited of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_GrafitClickableInherited>();
    assert(result != null, 'No _GrafitClickableInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_GrafitClickableInherited oldWidget) {
    return isHovered != oldWidget.isHovered ||
        isPressed != oldWidget.isPressed ||
        isFocused != oldWidget.isFocused;
  }
}

/// Extension to easily access clickable state
extension GrafitClickableExtension on BuildContext {
  bool get isClickableHovered {
    final state = _GrafitClickableInherited.of(this);
    return state.isHovered;
  }

  bool get isClickablePressed {
    final state = _GrafitClickableInherited.of(this);
    return state.isPressed;
  }

  bool get isClickableFocused {
    final state = _GrafitClickableInherited.of(this);
    return state.isFocused;
  }
}
