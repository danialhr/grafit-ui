import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../theme/theme.dart';

/// OTP (One-Time Password) input component
///
/// Provides individual digit slots with auto-focus navigation,
/// paste support, and customizable styling via GrafitTheme.
///
/// Example:
/// ```dart
/// GrafitInputOtp(
///   length: 6,
///   onChanged: (value) => print('OTP: $value'),
///   child: Row(
///     children: [
///       GrafitInputOtpGroup(
///         children: [
///           GrafitInputOtpSlot(index: 0),
///           GrafitInputOtpSlot(index: 1),
///           GrafitInputOtpSlot(index: 2),
///         ],
///       ),
///       GrafitInputOtpSeparator(),
///       GrafitInputOtpGroup(
///         children: [
///           GrafitInputOtpSlot(index: 3),
///           GrafitInputOtpSlot(index: 4),
///           GrafitInputOtpSlot(index: 5),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
class GrafitInputOtp extends StatefulWidget {
  /// Total number of OTP digits
  final int length;

  /// Callback when OTP value changes
  final ValueChanged<String>? onChanged;

  /// Callback when all digits are entered
  final ValueChanged<String>? onCompleted;

  /// Initial OTP value
  final String? initialValue;

  /// Whether the input is enabled
  final bool enabled;

  /// Whether to autofocus the first slot
  final bool autofocus;

  /// Input formatter for validation (e.g., digits only)
  final List<TextInputFormatter>? inputFormatters;

  /// Text input type (defaults to number)
  final TextInputType keyboardType;

  /// The child widget containing groups and slots
  final Widget child;

  const GrafitInputOtp({
    super.key,
    required this.length,
    required this.child,
    this.onChanged,
    this.onCompleted,
    this.initialValue,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.keyboardType = TextInputType.number,
  });

  @override
  State<GrafitInputOtp> createState() => _GrafitInputOtpState();

  /// Access the OTP state from descendants
  static _GrafitInputOtpState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InputOtpInherited>()?.state;
  }
}

class _GrafitInputOtpState extends State<GrafitInputOtp> {
  late List<String> _digits;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeState();
    if (widget.autofocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusFirstSlot();
      });
    }
  }

  void _initializeState() {
    final initialValue = widget.initialValue ?? '';
    _digits = List.generate(
      widget.length,
      (index) => index < initialValue.length ? initialValue[index] : '',
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(text: _digits[index]),
    );

    // Add listeners to focus nodes
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() => _focusedIndex = i);
        }
      });
    }
  }

  void _focusFirstSlot() {
    if (_focusNodes.isNotEmpty && widget.enabled) {
      _focusNodes[0].requestFocus();
    }
  }

  @override
  void didUpdateWidget(GrafitInputOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _disposeControllers();
      _disposeFocusNodes();
      _initializeState();
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  void _disposeFocusNodes() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  String get _value => _digits.join();

  void _onChanged(String value, int index) {
    setState(() {
      _digits[index] = value;
    });

    widget.onChanged?.call(_value);

    // Auto-focus next slot
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if completed
    if (_value.length == widget.length && !_value.contains('')) {
      widget.onCompleted?.call(_value);
    }
  }

  void _onDelete(int index) {
    if (_digits[index].isEmpty && index > 0) {
      // Focus previous slot if current is empty
      _focusNodes[index - 1].requestFocus();
    } else {
      setState(() {
        _digits[index] = '';
        _controllers[index].clear();
      });
      widget.onChanged?.call(_value);
    }
  }

  void _onPaste(String pastedText) {
    final cleanText = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    final length = min(cleanText.length, widget.length);

    setState(() {
      for (var i = 0; i < length; i++) {
        _digits[i] = cleanText[i];
        _controllers[i].text = cleanText[i];
      }
    });

    widget.onChanged?.call(_value);

    // Focus the next empty slot or the last filled slot
    final nextEmpty = _digits.indexWhere((d) => d.isEmpty);
    if (nextEmpty != -1 && nextEmpty < widget.length) {
      _focusNodes[nextEmpty].requestFocus();
    } else if (length > 0) {
      _focusNodes[length - 1].requestFocus();
    }

    // Check if completed
    if (_value.length == widget.length) {
      widget.onCompleted?.call(_value);
    }
  }

  /// Handle paste event from keyboard
  void _handlePaste() {
    // This would be triggered by Ctrl+V or paste action
    // Implementation would read from clipboard and call _onPaste
    // Clipboard.getData(Clipboard.kTextPlain).then((value) {
    //   if (value?.text != null) {
    //     _onPaste(value!.text!);
    //   }
    // });
  }

  /// Get the character at a specific slot
  String? getChar(int index) {
    if (index < 0 || index >= _digits.length) return null;
    return _digits[index];
  }

  /// Check if a slot is focused
  bool isFocused(int index) {
    return _focusedIndex == index;
  }

  /// Check if a slot has a fake caret (show blinking cursor)
  bool hasFakeCaret(int index) {
    return isFocused(index) && _digits[index].isEmpty;
  }

  /// Clear all digits
  void clear() {
    setState(() {
      for (var i = 0; i < _digits.length; i++) {
        _digits[i] = '';
        _controllers[i].clear();
      }
    });
    widget.onChanged?.call('');
  }

  /// Set the OTP value programmatically
  void setValue(String value) {
    final cleanValue = value.substring(0, min(value.length, widget.length));
    setState(() {
      for (var i = 0; i < cleanValue.length; i++) {
        _digits[i] = cleanValue[i];
        _controllers[i].text = cleanValue[i];
      }
      for (var i = cleanValue.length; i < widget.length; i++) {
        _digits[i] = '';
        _controllers[i].clear();
      }
    });
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return _InputOtpInherited(
      state: this,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, letterSpacing: 0),
        child: widget.child,
      ),
    );
  }
}

class _InputOtpInherited extends InheritedWidget {
  final _GrafitInputOtpState state;

  const _InputOtpInherited({
    required this.state,
    required super.child,
  });

  static _InputOtpInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InputOtpInherited>();
  }

  @override
  bool updateShouldNotify(_InputOtpInherited oldWidget) => true;
}

/// Group container for OTP input slots
///
/// Provides spacing and alignment for multiple slots.
/// Use this to organize slots visually (e.g., groups of 3 for a 6-digit code).
class GrafitInputOtpGroup extends StatelessWidget {
  /// The slots to include in this group
  final List<Widget> children;

  /// Additional spacing between slots
  final double? spacing;

  /// Custom padding for the group
  final EdgeInsetsGeometry? padding;

  const GrafitInputOtpGroup({
    super.key,
    required this.children,
    this.spacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          children.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              right: index < children.length - 1
                  ? (spacing ?? theme.colors.radius * 4)
                  : 0,
            ),
            child: children[index],
          ),
        ),
      ),
    );
  }
}

/// Individual OTP slot for a single digit
///
/// Displays the entered character and manages focus state.
/// Shows a blinking cursor when focused and empty.
class GrafitInputOtpSlot extends StatelessWidget {
  /// The index of this slot in the OTP sequence
  final int index;

  /// Whether this slot has an error
  final bool hasError;

  /// Custom width for the slot
  final double? width;

  /// Custom height for the slot
  final double? height;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Whether to render the slot as the first in a sequence
  final bool isFirst;

  /// Whether to render the slot as the last in a sequence
  final bool isLast;

  const GrafitInputOtpSlot({
    super.key,
    required this.index,
    this.hasError = false,
    this.width,
    this.height,
    this.borderRadius,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final otpState = GrafitInputOtp.of(context);
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    if (otpState == null) {
      return const SizedBox.shrink();
    }

    final char = otpState.getChar(index);
    final isActive = otpState.isFocused(index);
    final showCaret = otpState.hasFakeCaret(index);

    final effectiveWidth = width ?? 36;
    final effectiveHeight = height ?? 36;
    final defaultBorderRadius = BorderRadius.circular(colors.radius * 8);

    return _OtpSlotFocusTarget(
      index: index,
      child: Container(
        width: effectiveWidth,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: isActive ? colors.background : colors.muted.withValues(alpha: 0.3),
          border: Border.all(
            color: hasError
                ? colors.destructive
                : isActive
                    ? colors.ring
                    : colors.border,
            width: isActive ? 2 : 1,
          ),
          borderRadius: borderRadius ?? defaultBorderRadius,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: hasError
                        ? colors.destructive.withValues(alpha: 0.2)
                        : colors.ring.withValues(alpha: 0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Character display
              if (char != null && char.isNotEmpty)
                Text(
                  char,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.foreground,
                    letterSpacing: 0,
                  ),
                ),
              // Blinking caret
              if (showCaret)
                SizedBox(
                  width: 2,
                  height: 16,
                  child: _BlinkingCaret(
                    color: colors.foreground,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Internal widget to handle focus and input for each slot
class _OtpSlotFocusTarget extends StatefulWidget {
  final int index;
  final Widget child;

  const _OtpSlotFocusTarget({
    required this.index,
    required this.child,
  });

  @override
  State<_OtpSlotFocusTarget> createState() => _OtpSlotFocusTargetState();
}

class _OtpSlotFocusTargetState extends State<_OtpSlotFocusTarget> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final otpState = GrafitInputOtp.of(context)!;
    _focusNode = otpState._focusNodes[widget.index];
    _controller = otpState._controllers[widget.index];
  }

  @override
  void dispose() {
    // Focus nodes and controllers are managed by parent
    super.dispose();
  }

  void _handleTap() {
    if (_focusNode.canRequestFocus) {
      _focusNode.requestFocus();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final otpState = GrafitInputOtp.of(context)!;

    // Handle backspace
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controller.text.isEmpty && widget.index > 0) {
        // Move to previous slot and delete
        otpState._onDelete(widget.index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = GrafitInputOtp.of(context)!;
    final isEnabled = true; // Will be controlled by parent's enabled state

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        onTap: _handleTap,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: isEnabled,
          keyboardType: otpState.widget.keyboardType,
          inputFormatters: otpState.widget.inputFormatters,
          maxLength: 1,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            counterText: '',
            isDense: true,
          ),
          style: const TextStyle(
            color: Colors.transparent,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            if (value.isNotEmpty) {
              otpState._onChanged(value, widget.index);
            }
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              otpState._onChanged(value, widget.index);
            }
          },
        ),
      ),
    );
  }
}

/// Blinking caret animation for empty focused slots
class _BlinkingCaret extends StatefulWidget {
  final Color color;

  const _BlinkingCaret({required this.color});

  @override
  State<_BlinkingCaret> createState() => _BlinkingCaretState();
}

class _BlinkingCaretState extends State<_BlinkingCaret>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 2,
            height: 16,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }
}

/// Separator widget for visual grouping of OTP slots
///
/// Typically rendered as a horizontal line or dash between groups.
/// Can be customized with any widget.
class GrafitInputOtpSeparator extends StatelessWidget {
  /// Custom widget to use as separator (defaults to horizontal dash)
  final Widget? child;

  /// Width of the separator
  final double? width;

  /// Height of the separator
  final double? height;

  /// Color of the separator
  final Color? color;

  /// Spacing around the separator
  final EdgeInsetsGeometry? padding;

  const GrafitInputOtpSeparator({
    super.key,
    this.child,
    this.width,
    this.height,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final defaultChild = Container(
      width: width ?? 16,
      height: height ?? 2,
      margin: padding ?? const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color ?? colors.mutedForeground,
        borderRadius: BorderRadius.circular(1),
      ),
    );

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 4),
      child: child ?? defaultChild,
    );
  }
}

// ============================================================
// WIDGETBOOK USE CASES
// ============================================================

@widgetbook.UseCase(
  name: 'Default',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: 6,
      child: Row(
        children: [
          GrafitInputOtpGroup(
            children: [
              GrafitInputOtpSlot(index: 0),
              GrafitInputOtpSlot(index: 1),
              GrafitInputOtpSlot(index: 2),
            ],
          ),
          GrafitInputOtpSeparator(),
          GrafitInputOtpGroup(
            children: [
              GrafitInputOtpSlot(index: 3),
              GrafitInputOtpSlot(index: 4),
              GrafitInputOtpSlot(index: 5),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Four Digits',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpFourDigits(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: 4,
      child: Row(
        children: [
          GrafitInputOtpSlot(index: 0),
          GrafitInputOtpSlot(index: 1),
          GrafitInputOtpSlot(index: 2),
          GrafitInputOtpSlot(index: 3),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpWithError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: 6,
      child: Row(
        children: [
          GrafitInputOtpSlot(index: 0),
          GrafitInputOtpSlot(index: 1, hasError: true),
          GrafitInputOtpSlot(index: 2, hasError: true),
          GrafitInputOtpSlot(index: 3),
          GrafitInputOtpSlot(index: 4),
          GrafitInputOtpSlot(index: 5),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Initial Value',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpWithInitialValue(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: 6,
      initialValue: '123456',
      child: Row(
        children: [
          GrafitInputOtpSlot(index: 0),
          GrafitInputOtpSlot(index: 1),
          GrafitInputOtpSlot(index: 2),
          GrafitInputOtpSlot(index: 3),
          GrafitInputOtpSlot(index: 4),
          GrafitInputOtpSlot(index: 5),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Opacity(
      opacity: 0.5,
      child: GrafitInputOtp(
        length: 6,
        enabled: false,
        child: Row(
          children: [
            GrafitInputOtpSlot(index: 0),
            GrafitInputOtpSlot(index: 1),
            GrafitInputOtpSlot(index: 2),
            GrafitInputOtpSlot(index: 3),
            GrafitInputOtpSlot(index: 4),
            GrafitInputOtpSlot(index: 5),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Separator',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpCustomSeparator(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: 6,
      child: Row(
        children: [
          GrafitInputOtpGroup(
            children: [
              GrafitInputOtpSlot(index: 0),
              GrafitInputOtpSlot(index: 1),
              GrafitInputOtpSlot(index: 2),
            ],
          ),
          GrafitInputOtpSeparator(
            width: 32,
            height: 4,
          ),
          GrafitInputOtpGroup(
            children: [
              GrafitInputOtpSlot(index: 3),
              GrafitInputOtpSlot(index: 4),
              GrafitInputOtpSlot(index: 5),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitInputOtp,
  path: 'Form/InputOtp',
)
Widget inputOtpInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final length = context.knobs.int.label: 'Length', initialValue: 6);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showErrors = context.knobs.boolean(label: 'Show Errors', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: GrafitInputOtp(
      length: length,
      enabled: enabled,
      child: Row(
        children: List.generate(
          length,
          (index) => GrafitInputOtpSlot(
            index: index,
            hasError: showErrors && index >= 2,
          ),
        ),
      ),
    ),
  );
}

