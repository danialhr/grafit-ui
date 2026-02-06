import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Overlay Components'),
        elevation: 0,
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Section
              _buildSectionHeader('Dialog'),
              const SizedBox(height: 16),
              _buildDialogSection(context, theme),
              const SizedBox(height: 32),

              // Alert Dialog Section
              _buildSectionHeader('Alert Dialog'),
              const SizedBox(height: 16),
              _buildAlertDialogSection(context, theme),
              const SizedBox(height: 32),

              // Popover Section
              _buildSectionHeader('Popover'),
              const SizedBox(height: 16),
              _buildPopoverSection(context, theme),
              const SizedBox(height: 32),

              // Tooltip Section
              _buildSectionHeader('Tooltip'),
              const SizedBox(height: 16),
              _buildTooltipSection(context, theme),
              const SizedBox(height: 32),

              // Hover Card Section
              _buildSectionHeader('Hover Card'),
              const SizedBox(height: 16),
              _buildHoverCardSection(context, theme),
              const SizedBox(height: 32),

              // Context Menu Section
              _buildSectionHeader('Context Menu'),
              const SizedBox(height: 16),
              _buildContextMenuSection(context, theme),
              const SizedBox(height: 32),

              // Sheet Section
              _buildSectionHeader('Sheet'),
              const SizedBox(height: 16),
              _buildSheetSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildDialogSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Dialog'),
            const SizedBox(height: 8),
            GrafitText.muted('A modal dialog that can be used to display content.'),
            const SizedBox(height: 16),
            GrafitButton(
              label: 'Open Dialog',
              variant: GrafitButtonVariant.primary,
              onPressed: () => _showDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    GrafitDialog.show(
      context,
      title: 'Are you sure?',
      description: 'This action cannot be undone. This will permanently delete your account and remove your data from our servers.',
      confirmText: 'Confirm',
      cancelText: 'Cancel',
      onConfirm: () {
        GrafitSonner.showSuccess(context, description: 'Account deleted successfully');
      },
    );
  }

  Widget _buildAlertDialogSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Alert Dialog'),
            const SizedBox(height: 8),
            GrafitText.muted('An alert dialog for critical information that requires user attention.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitButton(
                  label: 'Show Alert',
                  variant: GrafitButtonVariant.destructive,
                  onPressed: () => _showAlertDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    GrafitAlertDialog.show(
      context,
      title: 'Delete Account',
      description: 'Are you sure you want to delete your account? All of your data will be permanently removed.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () {
        Navigator.of(context).pop();
        GrafitSonner.showSuccess(context, description: 'Account deleted');
      },
    );
  }

  Widget _buildPopoverSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Popover'),
            const SizedBox(height: 8),
            GrafitText.muted('Displays rich content in a portal, triggered by a button.'),
            const SizedBox(height: 16),
            GrafitPopover(
              trigger: GrafitButton(
                label: 'Open Popover',
                variant: GrafitButtonVariant.outline,
                onPressed: () {},
              ),
              content: const GrafitCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitText.titleMedium('Popover Content'),
                      SizedBox(height: 8),
                      GrafitText.muted('This is the content of the popover. You can put any widget here.'),
                      SizedBox(height: 12),
                      GrafitButton(
                        label: 'Learn More',
                        variant: GrafitButtonVariant.primary,
                        size: GrafitButtonSize.sm,
                        onPressed: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Tooltip'),
            const SizedBox(height: 8),
            GrafitText.muted('Displays a hint when users hover over or focus on an element.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                GrafitTooltip(
                  message: 'This is a helpful tooltip',
                  child: GrafitButton(
                    label: 'Hover Me',
                    variant: GrafitButtonVariant.outline,
                    onPressed: () {},
                  ),
                ),
                GrafitTooltip(
                  message: 'Another tooltip example',
                  child: GrafitButton(
                    variant: GrafitButtonVariant.ghost,
                    icon: Icons.info_outline,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverCardSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Hover Card'),
            const SizedBox(height: 8),
            GrafitText.muted('Shows a card with additional information on hover.'),
            const SizedBox(height: 16),
            GrafitHoverCard(
              trigger: Row(
                children: [
                  GrafitAvatar.text(
                    initials: 'JD',
                    size: GrafitAvatarSize.sm,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafitText.labelMedium('@johndoe'),
                      GrafitText.muted('John Doe', style: GrafitTextStyle.bodySmall),
                    ],
                  ),
                ],
              ),
              content: GrafitCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GrafitAvatar.text(
                            initials: 'JD',
                            size: GrafitAvatarSize.md,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GrafitText.titleMedium('John Doe'),
                              GrafitText.muted('@johndoe'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GrafitText.muted('Software engineer and open source contributor.'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GrafitBadge.secondary('Followers'),
                          const SizedBox(width: 4),
                          GrafitText.labelMedium('1,234'),
                          const SizedBox(width: 16),
                          GrafitBadge.secondary('Following'),
                          const SizedBox(width: 4),
                          GrafitText.labelMedium('567'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Context Menu'),
            const SizedBox(height: 8),
            GrafitText.muted('Displays a menu with options when right-clicking.'),
            const SizedBox(height: 16),
            GrafitContextMenu(
              items: [
                GrafitContextMenuItem(
                  label: 'Copy',
                  icon: Icons.copy,
                  shortcut: 'Cmd+C',
                  onTap: () {
                    GrafitSonner.showSuccess(context, description: 'Copied to clipboard');
                  },
                ),
                GrafitContextMenuItem(
                  label: 'Paste',
                  icon: Icons.paste,
                  shortcut: 'Cmd+V',
                ),
                const GrafitContextMenuDivider(),
                GrafitContextMenuItem(
                  label: 'Delete',
                  icon: Icons.delete,
                  shortcut: 'Cmd+Del',
                  destructive: true,
                ),
              ],
              child: GrafitCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app_outlined, size: 48, color: theme.colors.mutedForeground),
                        const SizedBox(height: 16),
                        GrafitText.muted('Right-click anywhere on this card to open the context menu'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Sheet'),
            const SizedBox(height: 8),
            GrafitText.muted('A sheet that slides from the edge of the screen.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitButton(
                  label: 'Open Sheet',
                  variant: GrafitButtonVariant.primary,
                  onPressed: () => _showSheet(context, GrafitSheetSide.right),
                ),
                GrafitButton(
                  label: 'Bottom Sheet',
                  variant: GrafitButtonVariant.secondary,
                  onPressed: () => _showSheet(context, GrafitSheetSide.bottom),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, GrafitSheetSide side) {
    GrafitSheet.open(
      context,
      side: side,
      child: SizedBox(
        width: side == GrafitSheetSide.right || side == GrafitSheetSide.left ? 400 : null,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GrafitText.titleLarge('Sheet Title'),
                  GrafitButton(
                    variant: GrafitButtonVariant.ghost,
                    size: GrafitButtonSize.icon,
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const GrafitSeparator(),
              const SizedBox(height: 16),
              GrafitText.muted('This is the sheet content. Sheets are useful for displaying additional information or actions without leaving the current context.'),
              const SizedBox(height: 24),
              const GrafitInput(
                label: 'Name',
                hint: 'Enter your name',
              ),
              const SizedBox(height: 16),
              const GrafitTextarea(
                label: 'Description',
                hint: 'Enter a description',
                minLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GrafitButton(
                  label: 'Save Changes',
                  variant: GrafitButtonVariant.primary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    GrafitSonner.showSuccess(context, description: 'Changes saved');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
