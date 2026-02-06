import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Focusable primitive with focus management and keyboard navigation
class GrafitFocusable extends StatefulWidget {
  final Widget child;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<KeyEvent>? onKeyEvent;
  final bool includeSemantics;

  const GrafitFocusable({
    super.key,
    required this.child,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onKeyEvent,
    this.includeSemantics = true,
  });

  @override
  State<GrafitFocusable> createState() => _GrafitFocusableState();
}

class _GrafitFocusableState extends State<GrafitFocusable> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call(_isFocused);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    widget.onKeyEvent?.call(event);
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKeyEvent,
      child: _GrafitFocusableInherited(
        focusNode: _focusNode,
        isFocused: _isFocused,
        child: widget.child,
      ),
    );

    if (widget.includeSemantics) {
      result = Semantics(
        focusable: true,
        focused: _isFocused,
        child: result,
      );
    }

    return result;
  }
}

/// Inherited widget to share focusable state with descendants
class _GrafitFocusableInherited extends InheritedWidget {
  final FocusNode focusNode;
  final bool isFocused;

  const _GrafitFocusableInherited({
    required this.focusNode,
    required this.isFocused,
    required super.child,
  });

  static _GrafitFocusableInherited of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_GrafitFocusableInherited>();
    assert(result != null, 'No _GrafitFocusableInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_GrafitFocusableInherited oldWidget) {
    return isFocused != oldWidget.isFocused;
  }
}

/// Extension to easily access focusable state
extension GrafitFocusableExtension on BuildContext {
  bool get isFocusableFocused {
    final state = _GrafitFocusableInherited.of(this);
    return state.isFocused;
  }

  FocusNode get focusNode {
    final state = _GrafitFocusableInherited.of(this);
    return state.focusNode;
  }
}

/// Focus scope for managing focus within a group of widgets
class GrafitFocusScope extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;

  const GrafitFocusScope({
    super.key,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
  });

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      child: child,
    );
  }
}

/// Focus trap that keeps focus within a widget subtree
class GrafitFocusTrap extends StatefulWidget {
  final Widget child;
  final bool autoFocus;

  const GrafitFocusTrap({
    super.key,
    required this.child,
    this.autoFocus = true,
  });

  @override
  State<GrafitFocusTrap> createState() => _GrafitFocusTrapState();
}

class _GrafitFocusTrapState extends State<GrafitFocusTrap> {
  late FocusScopeNode _focusScopeNode;
  late FocusAttachment _nodeAttachment;

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
    _nodeAttachment = _focusScopeNode.attach(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nodeAttachment.detach();
    _nodeAttachment = _focusScopeNode.attach(context);
  }

  @override
  void dispose() {
    _nodeAttachment.detach();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      autoFocus: widget.autoFocus,
      child: widget.child,
    );
  }
}
