import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget inputsUseCase(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'Size',
    defaultValue: GrafitInputSize.md,
    values: GrafitInputSize.values.toList(),
    labelBuilder: (v) => v.name,
  );
  
  final enabled = context.knobs.boolean(
    label: 'Enabled',
    defaultValue: true,
  );
  
  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    defaultValue: false,
  );
  
  final obscureText = context.knobs.boolean(
    label: 'Obscure Text',
    defaultValue: false,
  );
  
  final hasLabel = context.knobs.boolean(
    label: 'Show Label',
    defaultValue: true,
  );
  
  final hasError = context.knobs.boolean(
    label: 'Show Error',
    defaultValue: false,
  );
  
  final hasHelper = context.knobs.boolean(
    label: 'Show Helper Text',
    defaultValue: true,
  );
  
  final hasPrefix = context.knobs.boolean(
    label: 'Show Prefix',
    defaultValue: false,
  );
  
  final hasSuffix = context.knobs.boolean(
    label: 'Show Suffix',
    defaultValue: false,
  );

  final labelText = context.knobs.string(
    label: 'Label',
    defaultValue: 'Email',
  );
  
  final hintText = context.knobs.string(
    label: 'Hint',
    defaultValue: 'Enter your email',
  );

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Individual input preview
              GrafitInput(
                label: hasLabel ? labelText : null,
                hint: hintText,
                size: size,
                enabled: enabled,
                readOnly: readOnly,
                obscureText: obscureText,
                errorText: hasError ? 'This field is required' : null,
                helperText: hasHelper ? 'We\'ll never share your email.' : null,
                prefix: hasPrefix ? const Icon(Icons.email_outlined) : null,
                suffix: hasSuffix ? const Icon(Icons.check_circle) : null,
              ),
              const SizedBox(height: 48),
              
              // All sizes showcase
              const Text(
                'All Sizes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const GrafitInput(
                label: 'Small Input',
                hint: 'Small size input',
                size: GrafitInputSize.sm,
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Medium Input',
                hint: 'Medium size input',
                size: GrafitInputSize.md,
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Large Input',
                hint: 'Large size input',
                size: GrafitInputSize.lg,
              ),
              const SizedBox(height: 24),
              
              // States showcase
              const Text(
                'States',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const GrafitInput(
                label: 'Default',
                hint: 'Default state',
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Disabled',
                hint: 'Disabled state',
                enabled: false,
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Read Only',
                hint: 'Read only state',
                readOnly: true,
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'With Error',
                hint: 'Error state',
                errorText: 'This field is required',
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Password',
                hint: 'Enter password',
                obscureText: true,
                suffix: Icon(Icons.visibility_off),
              ),
              const SizedBox(height: 24),
              
              // With prefix/suffix showcase
              const Text(
                'With Icons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const GrafitInput(
                label: 'Search',
                hint: 'Search...',
                prefix: Icon(Icons.search),
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Amount',
                hint: '0.00',
                prefix: Text('\$'),
                suffix: Text('USD'),
              ),
              const SizedBox(height: 12),
              const GrafitInput(
                label: 'Website',
                hint: 'https://example.com',
                prefix: Icon(Icons.link),
                suffix: Icon(Icons.check_circle, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
