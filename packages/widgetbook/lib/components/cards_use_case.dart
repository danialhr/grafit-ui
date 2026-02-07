import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';

Widget cardsUseCase(BuildContext context) {
  final bordered = context.knobs.boolean(
    label: 'Bordered',
    defaultValue: true,
  );
  
  final shadow = context.knobs.boolean(
    label: 'Shadow',
    defaultValue: false,
  );
  
  final padding = context.knobs.double.slider(
    label: 'Padding',
    defaultValue: 16.0,
    min: 0,
    max: 32,
    divisions: 32,
  );

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Individual card preview
            GrafitCard(
              bordered: bordered,
              shadow: shadow,
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is a customizable card component with various options.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Basic cards showcase
            const Text(
              'Basic Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                const GrafitCard(
                  child: Text('Default Card'),
                ),
                const GrafitCard(
                  bordered: false,
                  child: Text('Without Border'),
                ),
                const GrafitCard(
                  shadow: true,
                  child: Text('With Shadow'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Card with header
            const Text(
              'Card with Header',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GrafitCard(
              child: Column(
                children: [
                  GrafitCardHeader(
                    title: 'Account',
                    description: 'Manage your account settings',
                    action: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
                  const Divider(),
                  GrafitCardContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: John Doe'),
                        SizedBox(height: 8),
                        Text('Email: john@example.com'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Card with footer
            const Text(
              'Card with Footer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GrafitCard(
              child: Column(
                children: [
                  const GrafitCardHeader(
                    title: 'Subscription',
                  ),
                  GrafitCardContent(
                    child: const Text('Your subscription expires in 5 days.'),
                  ),
                  GrafitCardFooter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GrafitButton(
                          label: 'Cancel',
                          variant: GrafitButtonVariant.ghost,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        GrafitButton(
                          label: 'Renew',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Full card structure
            const Text(
              'Complete Card Structure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GrafitCard(
              shadow: true,
              child: Column(
                children: [
                  GrafitCardHeader(
                    title: 'Project Alpha',
                    description: 'Product design and development',
                    action: GrafitButton(
                      label: 'Edit',
                      variant: GrafitButtonVariant.ghost,
                      size: GrafitButtonSize.sm,
                      onPressed: () {},
                    ),
                  ),
                  GrafitCardContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatItem('Status', 'In Progress', Icons.circle),
                        const SizedBox(height: 12),
                        _buildStatItem('Due Date', 'Dec 31, 2024', Icons.calendar_today),
                        const SizedBox(height: 12),
                        _buildStatItem('Team', '5 members', Icons.people),
                      ],
                    ),
                  ),
                  GrafitCardFooter(
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 12),
                        const SizedBox(width: 4),
                        const CircleAvatar(radius: 12),
                        const SizedBox(width: 4),
                        const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                        const Spacer(),
                        Text(
                          'Updated 2h ago',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
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

Widget _buildStatItem(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 16),
      const SizedBox(width: 8),
      Text(
        '$label:',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      const SizedBox(width: 4),
      Text(value),
    ],
  );
}
