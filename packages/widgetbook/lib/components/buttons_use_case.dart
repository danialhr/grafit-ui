import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget buttonsUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    defaultValue: GrafitButtonVariant.primary,
    values: GrafitButtonVariant.values.toList(),
    labelBuilder: (v) => v.name,
  );
  
  final size = context.knobs.object.dropdown(
    label: 'Size',
    defaultValue: GrafitButtonSize.md,
    values: GrafitButtonSize.values.toList(),
    labelBuilder: (v) => v.name,
  );
  
  final fullWidth = context.knobs.boolean(
    label: 'Full Width',
    defaultValue: false,
  );
  
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    defaultValue: false,
  );
  
  final loading = context.knobs.boolean(
    label: 'Loading',
    defaultValue: false,
  );
  
  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    defaultValue: false,
  );

  final labelText = context.knobs.string(
    label: 'Label',
    defaultValue: 'Button',
  );

  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Individual button preview
          GrafitButton(
            label: labelText.isNotEmpty ? labelText : null,
            variant: variant,
            size: size,
            fullWidth: fullWidth,
            disabled: disabled,
            loading: loading,
            icon: showIcon ? Icons.favorite : null,
            onPressed: disabled || loading ? null : () {},
          ),
          const SizedBox(height: 48),
          
          // All variants showcase
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All Variants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GrafitButton(
                label: 'Primary',
                variant: GrafitButtonVariant.primary,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Secondary',
                variant: GrafitButtonVariant.secondary,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Ghost',
                variant: GrafitButtonVariant.ghost,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Outline',
                variant: GrafitButtonVariant.outline,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Link',
                variant: GrafitButtonVariant.link,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Destructive',
                variant: GrafitButtonVariant.destructive,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // All sizes showcase
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All Sizes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GrafitButton(
                label: 'Small',
                size: GrafitButtonSize.sm,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Medium',
                size: GrafitButtonSize.md,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Large',
                size: GrafitButtonSize.lg,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // With icons showcase
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'With Icons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GrafitButton(
                label: 'With Icon',
                icon: Icons.favorite,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Leading',
                leading: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Trailing',
                trailing: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Loading',
                loading: true,
                onPressed: () {},
              ),
              GrafitButton(
                label: 'Disabled',
                disabled: true,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Icon buttons
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Icon Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GrafitButton(
                icon: Icons.favorite,
                size: GrafitButtonSize.icon,
                variant: GrafitButtonVariant.primary,
                onPressed: () {},
              ),
              GrafitButton(
                icon: Icons.bookmark,
                size: GrafitButtonSize.icon,
                variant: GrafitButtonVariant.secondary,
                onPressed: () {},
              ),
              GrafitButton(
                icon: Icons.share,
                size: GrafitButtonSize.icon,
                variant: GrafitButtonVariant.ghost,
                onPressed: () {},
              ),
              GrafitButton(
                icon: Icons.delete,
                size: GrafitButtonSize.icon,
                variant: GrafitButtonVariant.destructive,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
