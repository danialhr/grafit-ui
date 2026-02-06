import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _progressValue = 0.3;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Feedback Components'),
        elevation: 0,
        actions: const [
          // Add GrafitSonner to the app
          GrafitSonner(position: GrafitToastPosition.bottomRight),
        ],
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert Section
              _buildSectionHeader('Alert'),
              const SizedBox(height: 16),
              _buildAlertSection(context, theme),
              const SizedBox(height: 32),

              // Progress Section
              _buildSectionHeader('Progress'),
              const SizedBox(height: 16),
              _buildProgressSection(context, theme),
              const SizedBox(height: 32),

              // Skeleton Section
              _buildSectionHeader('Skeleton'),
              const SizedBox(height: 16),
              _buildSkeletonSection(context, theme),
              const SizedBox(height: 32),

              // Sonner/Toast Section
              _buildSectionHeader('Sonner (Toast)'),
              const SizedBox(height: 16),
              _buildSonnerSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildAlertSection(BuildContext context, GrafitTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAlert(
          context,
          title: 'Information',
          description: 'This is an informational message for you.',
          variant: GrafitAlertVariant.value,
          icon: Icons.info,
        ),
        const SizedBox(height: 16),
        _buildAlert(
          context,
          title: 'Warning',
          description: 'Please review this warning before proceeding.',
          variant: GrafitAlertVariant.warning,
          icon: Icons.warning,
        ),
        const SizedBox(height: 16),
        _buildAlert(
          context,
          title: 'Error',
          description: 'Something went wrong. Please try again.',
          variant: GrafitAlertVariant.destructive,
          icon: Icons.error,
        ),
      ],
    );
  }

  Widget _buildAlert(
    BuildContext context, {
    required String title,
    required String description,
    required GrafitAlertVariant variant,
    required IconData icon,
  }) {
    return GrafitAlert(
      title: title,
      description: description,
      variant: variant,
      icon: icon,
    );
  }

  Widget _buildProgressSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Progress Indicators'),
            const SizedBox(height: 24),

            // Linear Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GrafitText.labelMedium('Loading...'),
                    GrafitText.labelMedium('${(_progressValue * 100).toInt()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: theme.colors.muted,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Indeterminate Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GrafitText.labelMedium('Indeterminate'),
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],
            ),
            const SizedBox(height: 24),

            // Circular Progress Demo Button
            GrafitButton(
              label: _isLoading ? 'Loading...' : 'Start Loading',
              variant: GrafitButtonVariant.primary,
              loading: _isLoading,
              onPressed: () => _toggleLoading(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
      if (_isLoading) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _isLoading = false);
            GrafitSonner.showSuccess(context, description: 'Loading complete!');
          }
        });
      }
    });
  }

  Widget _buildSkeletonSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Skeleton Loaders'),
            const SizedBox(height: 24),
            _buildCardSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSkeleton() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSonnerSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Toast Notifications'),
            const SizedBox(height: 8),
            GrafitText.muted('Click the buttons below to show different toast variants.'),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitButton(
                  label: 'Basic',
                  variant: GrafitButtonVariant.outline,
                  onPressed: () => _showBasicToast(context),
                ),
                GrafitButton(
                  label: 'Success',
                  variant: GrafitButtonVariant.primary,
                  onPressed: () => _showSuccessToast(context),
                ),
                GrafitButton(
                  label: 'Error',
                  variant: GrafitButtonVariant.destructive,
                  onPressed: () => _showErrorToast(context),
                ),
                GrafitButton(
                  label: 'Warning',
                  variant: GrafitButtonVariant.secondary,
                  onPressed: () => _showWarningToast(context),
                ),
                GrafitButton(
                  label: 'Info',
                  variant: GrafitButtonVariant.ghost,
                  onPressed: () => _showInfoToast(context),
                ),
                GrafitButton(
                  label: 'Loading',
                  variant: GrafitButtonVariant.outline,
                  onPressed: () => _showLoadingToast(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBasicToast(BuildContext context) {
    GrafitSonner.showToast(
      context,
      title: 'Basic Toast',
      description: 'This is a basic toast notification',
    );
  }

  void _showSuccessToast(BuildContext context) {
    GrafitSonner.showSuccess(
      context,
      title: 'Success!',
      description: 'Your changes have been saved successfully.',
    );
  }

  void _showErrorToast(BuildContext context) {
    GrafitSonner.showError(
      context,
      title: 'Error!',
      description: 'Something went wrong. Please try again.',
    );
  }

  void _showWarningToast(BuildContext context) {
    GrafitSonner.showWarning(
      context,
      title: 'Warning',
      description: 'Please review your input before proceeding.',
    );
  }

  void _showInfoToast(BuildContext context) {
    GrafitSonner.showInfo(
      context,
      title: 'New Message',
      description: 'You have received a new message.',
    );
  }

  void _showLoadingToast(BuildContext context) {
    final id = GrafitSonner.showLoading(
      context,
      title: 'Processing...',
      description: 'Please wait while we process your request.',
    );

    Future.delayed(const Duration(seconds: 3), () {
      GrafitSonner.dismiss(context, id);
      GrafitSonner.showSuccess(context, description: 'Processing complete!');
    });
  }
}
