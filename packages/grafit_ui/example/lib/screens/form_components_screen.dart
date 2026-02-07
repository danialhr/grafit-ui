import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class FormComponentsScreen extends StatefulWidget {
  const FormComponentsScreen({super.key});

  @override
  State<FormComponentsScreen> createState() => _FormComponentsScreenState();
}

class _FormComponentsScreenState extends State<FormComponentsScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _textareaController = TextEditingController();

  bool _switchValue = true;
  bool _checkbox1 = false;
  bool _checkbox2 = true;
  bool _checkbox3 = false;
  double _sliderValue = 50.0;

  @override
  void dispose() {
    _textController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _textareaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Form Components'),
        elevation: 0,
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons Section
              _buildSectionHeader('Buttons'),
              const SizedBox(height: 16),
              _buildButtonsSection(context, theme),
              const SizedBox(height: 32),

              // Inputs Section
              _buildSectionHeader('Inputs'),
              const SizedBox(height: 16),
              _buildInputsSection(context, theme),
              const SizedBox(height: 32),

              // Checkbox & Switch Section
              _buildSectionHeader('Checkbox & Switch'),
              const SizedBox(height: 16),
              _buildCheckboxSwitchSection(context, theme),
              const SizedBox(height: 32),

              // Slider Section
              _buildSectionHeader('Slider'),
              const SizedBox(height: 16),
              _buildSliderSection(context, theme),
              const SizedBox(height: 32),

              // Textarea Section
              _buildSectionHeader('Textarea'),
              const SizedBox(height: 16),
              _buildTextareaSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildButtonsSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Button Variants'),
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
                  label: 'Outline',
                  variant: GrafitButtonVariant.outline,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Ghost',
                  variant: GrafitButtonVariant.ghost,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Destructive',
                  variant: GrafitButtonVariant.destructive,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Link',
                  variant: GrafitButtonVariant.link,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            GrafitText.titleMedium('Button Sizes'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GrafitButton(
                  label: 'Small',
                  variant: GrafitButtonVariant.primary,
                  size: GrafitButtonSize.sm,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Medium',
                  variant: GrafitButtonVariant.primary,
                  size: GrafitButtonSize.md,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Large',
                  variant: GrafitButtonVariant.primary,
                  size: GrafitButtonSize.lg,
                  onPressed: () {},
                ),
                GrafitButton(
                  variant: GrafitButtonVariant.primary,
                  size: GrafitButtonSize.icon,
                  icon: Icons.favorite,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            GrafitText.titleMedium('Button States'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitButton(
                  label: 'Default',
                  variant: GrafitButtonVariant.primary,
                  onPressed: () {},
                ),
                GrafitButton(
                  label: 'Disabled',
                  variant: GrafitButtonVariant.primary,
                  onPressed: null,
                ),
                GrafitButton(
                  label: 'Loading',
                  variant: GrafitButtonVariant.primary,
                  loading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputsSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Input Fields'),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Username',
              hint: 'Enter your username',
              prefix: const Icon(Icons.person_outline, size: 18),
              controller: _textController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Email',
              hint: 'Enter your email',
              prefix: const Icon(Icons.email_outlined, size: 18),
              controller: _emailController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Password',
              hint: 'Enter your password',
              prefix: const Icon(Icons.lock_outline, size: 18),
              obscureText: true,
              controller: _passwordController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Disabled Input',
              hint: 'This input is disabled',
              enabled: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'With Error',
              hint: 'Enter valid value',
              errorText: 'This field is required',
              prefix: const Icon(Icons.error_outline, size: 18),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxSwitchSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Checkboxes'),
            const SizedBox(height: 16),
            Row(
              children: [
                GrafitCheckbox(
                  value: _checkbox1,
                  onChanged: (value) => setState(() => _checkbox1 = value ?? false),
                  label: 'Accept terms and conditions',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GrafitCheckbox(
                  value: _checkbox2,
                  onChanged: (value) => setState(() => _checkbox2 = value ?? false),
                  label: 'Subscribe to newsletter',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GrafitCheckbox(
                  value: _checkbox3,
                  onChanged: null,
                  label: 'Disabled checkbox',
                ),
              ],
            ),
            const SizedBox(height: 24),
            GrafitSeparator(),
            const SizedBox(height: 24),
            GrafitText.titleMedium('Switches'),
            const SizedBox(height: 16),
            Row(
              children: [
                GrafitSwitch(
                  value: _switchValue,
                  onChanged: (value) => setState(() => _switchValue = value),
                  label: 'Enable notifications',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Slider'),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GrafitText.labelMedium('Volume'),
                    GrafitText.labelMedium('${_sliderValue.toInt()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                GrafitSlider(
                  value: _sliderValue,
                  onChanged: (value) => setState(() => _sliderValue = value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextareaSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Textarea'),
            const SizedBox(height: 16),
            GrafitInput(
              label: 'Message',
              hint: 'Enter your message here...',
              controller: _textareaController,
              maxLines: 5,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
