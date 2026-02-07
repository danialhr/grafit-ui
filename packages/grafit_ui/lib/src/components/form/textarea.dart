import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Textarea component
class GrafitTextarea extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
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
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? label;
  final Widget? prefix;
  final Widget? suffix;

  const GrafitTextarea({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder,
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
    this.onEditingComplete,
    this.focusNode,
    this.errorText,
    this.label,
    this.prefix,
    this.suffix,
  });

  @override
  State<GrafitTextarea> createState() => _GrafitTextareaState();
}

class _GrafitTextareaState extends State<GrafitTextarea> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(GrafitTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && widget.value != null && widget.value != oldWidget.value) {
      _controller.text = widget.value;
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
    final hasError = widget.errorText != null;
    final hintText = widget.placeholder ?? widget.hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          widget.label!,
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(colors.radius * 6),
            border: Border.all(
              color: hasError
                  ? colors.destructive
                  : _focusNode.hasFocus
                      ? colors.ring
                      : colors.input,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: colors.ring.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: effectiveEnabled,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            onEditingComplete: widget.onEditingComplete,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            onChanged: widget.controller == null
                ? (value) {
                    widget.onChanged?.call(value);
                  }
                : null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: colors.mutedForeground,
                fontSize: 14,
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
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              isDense: true,
            ),
            style: TextStyle(
              color: colors.foreground,
              fontSize: 14,
            ),
            cursorColor: colors.primary,
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: colors.destructive,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      placeholder: 'Enter your message...',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Label',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaWithLabel(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Description'),
      placeholder: 'Enter a description...',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Value',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaWithValue(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Bio'),
      value: 'This is a pre-filled textarea with some text content.',
      placeholder: 'Tell us about yourself...',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Max Length',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaWithMaxLength(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Short Bio'),
      placeholder: 'Max 100 characters',
      maxLength: 100,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Error State',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Email'),
      placeholder: 'Enter your email',
      errorText: 'Please enter a valid email address',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Disabled Textarea'),
      placeholder: 'Cannot edit this field',
      enabled: false,
      value: 'This content is read-only',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Resizable',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaResizable(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: Text('Long Text'),
      placeholder: 'Enter a long message...',
      minLines: 3,
      maxLines: 10,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitTextarea,
  path: 'Form/Textarea',
)
Widget textareaInteractive(BuildContext context) {
  final placeholder = context.knobs.string(label: 'Placeholder', initialValue: 'Enter text...');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Has Error', initialValue: false);
  final minLines = context.knobs.int.slider(label: 'Min Lines', initialValue: 3, min: 1, max: 10);
  final maxLines = context.knobs.int.slider(label: 'Max Lines', initialValue: 5, min: 2, max: 15);
  final showLabel = context.knobs.boolean(label: 'Show Label', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitTextarea(
      label: showLabel ? const Text('Message') : null,
      placeholder: placeholder.isNotEmpty ? placeholder : null,
      enabled: enabled,
      errorText: hasError ? 'This field is required' : null,
      minLines: minLines,
      maxLines: maxLines,
    ),
  );
}
