import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../primitives/focusable.dart';

/// Alignment options for input group addons
enum GrafitInputGroupAlign {
  inlineStart,
  inlineEnd,
  blockStart,
  blockEnd,
}

/// Size options for input group buttons
enum GrafitInputGroupButtonSize {
  xs,
  sm,
  iconXs,
  iconSm,
}

/// Input Group container component
/// Groups input fields with prefix/suffix elements like text, icons, or buttons
class GrafitInputGroup extends StatefulWidget {
  final Widget child;
  final Widget? left;
  final Widget? right;
  final Widget? top;
  final Widget? bottom;
  final bool disabled;
  final bool hasError;
  final String? errorText;
  final String? helperText;
  final VoidCallback? onTap;

  const GrafitInputGroup({
    super.key,
    required this.child,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.disabled = false,
    this.hasError = false,
    this.errorText,
    this.helperText,
    this.onTap,
  });

  @override
  State<GrafitInputGroup> createState() => _GrafitInputGroupState();
}

class _GrafitInputGroupState extends State<GrafitInputGroup> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final hasBlockStart = widget.top != null;
    final hasBlockEnd = widget.bottom != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.errorText != null || widget.helperText != null) ...[
          _buildHelperText(context, colors),
          const SizedBox(height: 6),
        ],
        GrafitFocusable(
          focusNode: _focusNode,
          child: GestureDetector(
            onTap: widget.onTap ??
                () {
                  // Focus the first input field in the group
                  final inputContext = _focusNode.context;
                  if (inputContext != null) {
                    _focusNode.requestFocus();
                  }
                },
            child: Container(
              decoration: _buildDecoration(colors, hasBlockStart, hasBlockEnd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.top != null)
                    GrafitInputGroupTopAddon(
                      child: widget.top!,
                      disabled: widget.disabled,
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.left != null)
                        GrafitInputGroupLeftAddon(
                          child: widget.left!,
                          disabled: widget.disabled,
                          onTap: widget.onTap,
                        ),
                      Expanded(
                        child: _wrapChild(colors),
                      ),
                      if (widget.right != null)
                        GrafitInputGroupRightAddon(
                          child: widget.right!,
                          disabled: widget.disabled,
                          onTap: widget.onTap,
                        ),
                    ],
                  ),
                  if (widget.bottom != null)
                    GrafitInputGroupBottomAddon(
                      child: widget.bottom!,
                      disabled: widget.disabled,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wrapChild(GrafitColorScheme colors) {
    return widget.child;
  }

  BoxDecoration _buildDecoration(
    GrafitColorScheme colors,
    bool hasBlockStart,
    bool hasBlockEnd,
  ) {
    final borderColor = widget.hasError
        ? colors.destructive
        : _isFocused
            ? colors.ring
            : colors.border;

    final backgroundColor = widget.disabled
        ? colors.muted.withOpacity(0.3)
        : colors.background;

    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: _isFocused ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(colors.radius * 6),
      boxShadow: _isFocused
          ? [
              BoxShadow(
                color: colors.ring.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }

  Widget _buildHelperText(BuildContext context, GrafitColorScheme colors) {
    final text = widget.hasError ? widget.errorText! : widget.helperText!;
    final textColor = widget.hasError ? colors.destructive : colors.mutedForeground;
    final pikpoTheme = Theme.of(context).extension<GrafitTheme>()!;

    return Text(
      text,
      style: pikpoTheme.text.labelSmall?.copyWith(
        color: textColor,
      ),
    );
  }
}

/// Left addon component for input groups
class GrafitInputGroupLeftAddon extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final VoidCallback? onTap;

  const GrafitInputGroupLeftAddon({
    super.key,
    required this.child,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: colors.border,
              width: 1,
            ),
          ),
        ),
        child: Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: DefaultTextStyle(
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: colors.mutedForeground,
                size: 16,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Right addon component for input groups
class GrafitInputGroupRightAddon extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final VoidCallback? onTap;

  const GrafitInputGroupRightAddon({
    super.key,
    required this.child,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colors.border,
              width: 1,
            ),
          ),
        ),
        child: Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: DefaultTextStyle(
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: colors.mutedForeground,
                size: 16,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Top addon component for input groups (block-start)
class GrafitInputGroupTopAddon extends StatelessWidget {
  final Widget child;
  final bool disabled;

  const GrafitInputGroupTopAddon({
    super.key,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: DefaultTextStyle(
          style: TextStyle(
            color: colors.mutedForeground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: colors.mutedForeground,
              size: 16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Bottom addon component for input groups (block-end)
class GrafitInputGroupBottomAddon extends StatelessWidget {
  final Widget child;
  final bool disabled;

  const GrafitInputGroupBottomAddon({
    super.key,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.border,
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: DefaultTextStyle(
          style: TextStyle(
            color: colors.mutedForeground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: colors.mutedForeground,
              size: 16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Text element component for input groups
class GrafitInputGroupText extends StatelessWidget {
  final String text;
  final IconData? icon;

  const GrafitInputGroupText(
    this.text, {
    super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16),
          const SizedBox(width: 8),
        ],
        Text(text),
      ],
    );
  }
}

/// Button component specifically for input groups
class GrafitInputGroupButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GrafitInputGroupButtonSize size;
  final bool disabled;
  final GrafitButtonVariant variant;

  const GrafitInputGroupButton({
    super.key,
    this.label,
    this.icon,
    this.onPressed,
    this.size = GrafitInputGroupButtonSize.xs,
    this.disabled = false,
    this.variant = GrafitButtonVariant.ghost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveDisabled = disabled || onPressed == null;
    final padding = _getPadding();
    final borderRadius = _getBorderRadius(colors.radius);

    return Opacity(
      opacity: effectiveDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: effectiveDisabled ? null : onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _getBackgroundColor(colors),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && label != null) ...[
                Icon(icon, size: _getIconSize()),
                const SizedBox(width: 6),
              ] else if (icon != null) ...[
                Icon(icon, size: _getIconSize()),
              ],
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    color: colors.mutedForeground,
                    fontSize: _getFontSize(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(GrafitColorScheme colors) {
    return switch (variant) {
      GrafitButtonVariant.ghost => Colors.transparent,
      GrafitButtonVariant.secondary => colors.secondary,
      GrafitButtonVariant.outline => Colors.transparent,
      _ => Colors.transparent,
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      GrafitInputGroupButtonSize.xs => const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
      GrafitInputGroupButtonSize.sm => const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
      GrafitInputGroupButtonSize.iconXs => const EdgeInsets.all(6),
      GrafitInputGroupButtonSize.iconSm => const EdgeInsets.all(8),
    };
  }

  BorderRadius _getBorderRadius(double radius) {
    return BorderRadius.circular(radius * 4);
  }

  double _getIconSize() {
    return switch (size) {
      GrafitInputGroupButtonSize.xs => 14.0,
      GrafitInputGroupButtonSize.sm => 16.0,
      GrafitInputGroupButtonSize.iconXs => 14.0,
      GrafitInputGroupButtonSize.iconSm => 16.0,
    };
  }

  double _getFontSize() {
    return switch (size) {
      GrafitInputGroupButtonSize.xs => 13.0,
      GrafitInputGroupButtonSize.sm => 14.0,
      GrafitInputGroupButtonSize.iconXs => 13.0,
      GrafitInputGroupButtonSize.iconSm => 14.0,
    };
  }
}

/// Input field specifically designed for input groups
class GrafitInputGroupInput extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const GrafitInputGroupInput({
    super.key,
    this.value,
    this.onChanged,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  State<GrafitInputGroupInput> createState() => _GrafitInputGroupInputState();
}

class _GrafitInputGroupInputState extends State<GrafitInputGroupInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(GrafitInputGroupInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.value != null &&
        widget.value != oldWidget.value) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveEnabled = widget.enabled && !widget.readOnly;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: effectiveEnabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.controller == null ? widget.onChanged : null,
      onSubmitted: widget.onSubmitted,
      style: TextStyle(
        color: widget.enabled ? colors.foreground : colors.mutedForeground,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: colors.mutedForeground,
          fontSize: 14,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
        counterText: '',
      ),
      cursorColor: colors.primary,
    );
  }
}

/// Textarea specifically designed for input groups
class GrafitInputGroupTextarea extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const GrafitInputGroupTextarea({
    super.key,
    this.value,
    this.onChanged,
    this.hint,
    this.minLines = 3,
    this.maxLines = 5,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  State<GrafitInputGroupTextarea> createState() =>
      _GrafitInputGroupTextareaState();
}

class _GrafitInputGroupTextareaState extends State<GrafitInputGroupTextarea> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(GrafitInputGroupTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.value != null &&
        widget.value != oldWidget.value) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    final effectiveEnabled = widget.enabled && !widget.readOnly;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: effectiveEnabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.controller == null ? widget.onChanged : null,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: colors.mutedForeground,
          fontSize: 14,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        isDense: true,
        counterText: '',
      ),
      style: TextStyle(
        color: colors.foreground,
        fontSize: 14,
      ),
      cursorColor: colors.primary,
    );
  }
}

/// Button variant enum (reused from button.dart)
enum GrafitButtonVariant {
  primary,
  secondary,
  ghost,
  link,
  destructive,
  outline,
}
