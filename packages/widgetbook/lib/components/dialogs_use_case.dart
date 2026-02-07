import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget dialogsUseCase(BuildContext context) {
  final showCancel = context.knobs.boolean(
    label: 'Show Cancel Button',
    defaultValue: true,
  );
  
  final confirmText = context.knobs.string(
    label: 'Confirm Text',
    defaultValue: 'Confirm',
  );
  
  final cancelText = context.knobs.string(
    label: 'Cancel Text',
    defaultValue: 'Cancel',
  );

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Simple dialog button
            GrafitButton(
              label: 'Show Simple Dialog',
              onPressed: () {
                GrafitDialog.show(
                  context,
                  title: 'Are you sure?',
                  description: 'This action cannot be undone.',
                  confirmText: confirmText,
                  cancelText: cancelText,
                  showCancel: showCancel,
                  onConfirm: () {
                    debugPrint('Confirmed');
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Dialog with content
            GrafitButton(
              label: 'Show Dialog with Content',
              variant: GrafitButtonVariant.secondary,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => GrafitDialog(
                    title: 'Delete Account',
                    description: 'Are you sure you want to delete your account?',
                    confirmText: confirmText,
                    cancelText: cancelText,
                    showCancel: showCancel,
                    onConfirm: () {
                      Navigator.of(context).pop();
                    },
                    content: const Text(
                      'This will permanently delete your account and remove all your data from our servers.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Custom actions dialog
            GrafitButton(
              label: 'Show Custom Actions',
              variant: GrafitButtonVariant.outline,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).extension<GrafitTheme>()!.colors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Theme.of(context).extension<GrafitTheme>()!.colors.radius * 8,
                      ),
                    ),
                    title: Text(
                      'Choose an option',
                      style: TextStyle(
                        color: Theme.of(context).extension<GrafitTheme>()!.colors.foreground,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.copy),
                          title: const Text('Copy'),
                          onTap: () => Navigator.of(context).pop('copy'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.cut),
                          title: const Text('Cut'),
                          onTap: () => Navigator.of(context).pop('cut'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () => Navigator.of(context).pop('delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            
            // Dialog examples showcase
            const Text(
              'Dialog Examples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Example cards showing different dialog types
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3,
              children: [
                _buildDialogExampleCard(
                  context,
                  title: 'Alert',
                  description: 'Important notification',
                  icon: Icons.warning,
                  color: Colors.orange,
                  onTap: () => _showAlertDialog(context),
                ),
                _buildDialogExampleCard(
                  context,
                  title: 'Confirm',
                  description: 'Confirm destructive action',
                  icon: Icons.dangerous,
                  color: Colors.red,
                  onTap: () => _showConfirmDialog(context),
                ),
                _buildDialogExampleCard(
                  context,
                  title: 'Info',
                  description: 'Additional information',
                  icon: Icons.info,
                  color: Colors.blue,
                  onTap: () => _showInfoDialog(context),
                ),
                _buildDialogExampleCard(
                  context,
                  title: 'Success',
                  description: 'Operation completed',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onTap: () => _showSuccessDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDialogExampleCard(
  BuildContext context, {
  required String title,
  required String description,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context).extension<GrafitTheme>()!;
  
  return GrafitCard(
    padding: EdgeInsets.zero,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.colors.radius * 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showAlertDialog(BuildContext context) {
  GrafitDialog.show(
    context,
    title: 'Attention Required',
    description: 'Your session will expire in 5 minutes. Please save your work.',
    confirmText: 'Got it',
    showCancel: false,
  );
}

void _showConfirmDialog(BuildContext context) {
  GrafitDialog.show(
    context,
    title: 'Delete Item',
    description: 'This action cannot be undone. Are you sure you want to continue?',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    onConfirm: () {
      debugPrint('Item deleted');
    },
  );
}

void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => GrafitDialog(
      title: 'About Grafit UI',
      confirmText: 'Close',
      showCancel: false,
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Grafit UI is a Flutter component library based on shadcn/ui.'),
          SizedBox(height: 12),
          Text('It provides beautiful, accessible components that you can copy and paste into your apps.'),
          SizedBox(height: 12),
          Text('Version: 0.1.0'),
        ],
      ),
    ),
  );
}

void _showSuccessDialog(BuildContext context) {
  GrafitDialog.show(
    context,
    title: 'Success!',
    description: 'Your changes have been saved successfully.',
    confirmText: 'Awesome',
    showCancel: false,
  );
}
