import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import '../../primitives/focusable.dart';

/// Input sizes
enum GrafitInputSize {
  sm,
  md,
  lg,
}

/// Text input field component
class GrafitInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final String? helperText;
  final GrafitInputSize size;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const GrafitInput({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.onTap,
    this.prefix,
    this.suffix,
    this.errorText,
    this.helperText,
    this.size = GrafitInputSize.md,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  State<GrafitInput> createState() => _GrafitInputState();
}

class _GrafitInputState extends State<GrafitInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;
    final hasError = widget.errorText != null;
    final effectiveEnabled = widget.enabled && !widget.readOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _buildLabel(context, colors),
          const SizedBox(height: 6),
        ],
        MouseRegion(
          cursor: effectiveEnabled ? SystemMouseCursors.text : MouseCursor.defer,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GrafitFocusable(
            focusNode: _focusNode,
            child: Container(
              decoration: _buildDecoration(context, colors, hasError),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                onTap: widget.onTap,
                style: _getTextStyle(colors),
                decoration: _buildInputDecoration(colors, hasError),
              ),
            ),
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 4),
          _buildHelperText(context, colors, hasError),
        ],
      ],
    );
  }

  Widget _buildLabel(BuildContext context, GrafitColorScheme colors) {
    final pikpoTheme = Theme.of(context).extension<GrafitTheme>()!;
    return Text(
      widget.label!,
      style: pikpoTheme.text.labelMedium?.copyWith(
        color: colors.foreground,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  BoxDecoration _buildDecoration(
    BuildContext context,
    GrafitColorScheme colors,
    bool hasError,
  ) {
    final borderColor = hasError
        ? colors.destructive
        : _isFocused
            ? colors.ring
            : _isHovered
                ? colors.input
                : colors.border;

    return BoxDecoration(
      color: widget.enabled ? colors.background : colors.muted,
      border: Border.all(
        color: borderColor,
        width: _isFocused ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(colors.radius * 8),
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

  InputDecoration _buildInputDecoration(GrafitColorScheme colors, bool hasError) {
    final effectiveEnabled = widget.enabled && !widget.readOnly;

    return InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(
        color: colors.mutedForeground,
        fontSize: _getFontSize(),
      ),
      prefixIcon: widget.prefix != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.prefix,
            )
          : null,
      suffixIcon: widget.suffix != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.suffix,
            )
          : null,
      border: InputBorder.none,
      contentPadding: _getContentPadding(),
      isDense: true,
    );
  }

  TextStyle _getTextStyle(GrafitColorScheme colors) {
    return TextStyle(
      color: widget.enabled ? colors.foreground : colors.mutedForeground,
      fontSize: _getFontSize(),
    );
  }

  double _getFontSize() {
    return switch (widget.size) {
      GrafitInputSize.sm => 13.0,
      GrafitInputSize.md => 14.0,
      GrafitInputSize.lg => 15.0,
    };
  }

  EdgeInsets _getContentPadding() {
    return switch (widget.size) {
      GrafitInputSize.sm => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      GrafitInputSize.md => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      GrafitInputSize.lg => const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
    };
  }

  Widget _buildHelperText(BuildContext context, GrafitColorScheme colors, bool hasError) {
    final text = hasError ? widget.errorText! : widget.helperText!;
    final textColor = hasError ? colors.destructive : colors.mutedForeground;
    final pikpoTheme = Theme.of(context).extension<GrafitTheme>()!;

    return Text(
      text,
      style: pikpoTheme.text.labelSmall?.copyWith(
        color: textColor,
      ),
    );
  }
}
