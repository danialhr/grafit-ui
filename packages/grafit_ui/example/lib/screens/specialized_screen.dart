import 'package:flutter/material.dart';
import 'package:grafit_ui/grafit_ui.dart';

class SpecializedScreen extends StatefulWidget {
  const SpecializedScreen({super.key});

  @override
  State<SpecializedScreen> createState() => _SpecializedScreenState();
}

class _SpecializedScreenState extends State<SpecializedScreen> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.colors.background,
        title: const Text('Specialized Components'),
        elevation: 0,
      ),
      body: GrafitScrollArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Section
              _buildSectionHeader('Calendar'),
              const SizedBox(height: 16),
              _buildCalendarSection(context, theme),
              const SizedBox(height: 32),

              // Carousel Section
              _buildSectionHeader('Carousel'),
              const SizedBox(height: 16),
              _buildCarouselSection(context, theme),
              const SizedBox(height: 32),

              // Resizable Section
              _buildSectionHeader('Resizable'),
              const SizedBox(height: 16),
              _buildResizableSection(context, theme),
              const SizedBox(height: 32),

              // Drawer Section
              _buildSectionHeader('Drawer'),
              const SizedBox(height: 16),
              _buildDrawerSection(context, theme),
              const SizedBox(height: 32),

              // Scroll Area Section
              _buildSectionHeader('Scroll Area'),
              const SizedBox(height: 16),
              _buildScrollAreaSection(context, theme),
              const SizedBox(height: 32),

              // Accordion Section
              _buildSectionHeader('Accordion'),
              const SizedBox(height: 16),
              _buildAccordionSection(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return GrafitText.headlineSmall(title);
  }

  Widget _buildCalendarSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Calendar'),
            const SizedBox(height: 8),
            GrafitText.muted('A calendar component for date selection.'),
            const SizedBox(height: 16),
            GrafitCalendar(
              mode: GrafitCalendarMode.single,
              initialDate: _selectedDate,
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
            if (_selectedDate != null) ...[
              const SizedBox(height: 16),
              const GrafitSeparator(),
              const SizedBox(height: 16),
              GrafitText.labelMedium('Selected Date: ${_formatDate(_selectedDate!)}'),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildCarouselSection(BuildContext context, GrafitTheme theme) {
    final carouselItems = [
      _buildCarouselItem('First Slide', 'Description for the first slide', theme.colors.primary),
      _buildCarouselItem('Second Slide', 'Description for the second slide', theme.colors.secondary),
      _buildCarouselItem('Third Slide', 'Description for the third slide', theme.colors.accent),
    ];

    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Carousel'),
            const SizedBox(height: 8),
            GrafitText.muted('A responsive carousel component with touch support.'),
            const SizedBox(height: 16),
            GrafitCarousel(
              items: carouselItems,
              height: 200,
              autoPlayDelay: 5.0,
              showArrows: true,
              showIndicators: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String title, String description, Color color) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(theme.colors.radius * 8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GrafitText.headlineMedium(
              title,
              style: GrafitTextStyle.headlineMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            GrafitText.muted(
              description,
              style: GrafitTextStyle.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResizableSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Resizable'),
            const SizedBox(height: 8),
            GrafitText.muted('Drag the handle to resize the panels.'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GrafitResizablePanel(
                initialRatio: 0.5,
                direction: GrafitResizableDirection.horizontal,
                firstChild: Container(
                  decoration: BoxDecoration(
                    color: theme.colors.muted.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(theme.colors.radius * 4),
                  ),
                  child: Center(
                    child: GrafitText.muted('Panel 1 - Drag right to resize'),
                  ),
                ),
                secondChild: Container(
                  decoration: BoxDecoration(
                    color: theme.colors.muted.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(theme.colors.radius * 4),
                  ),
                  child: Center(
                    child: GrafitText.muted('Panel 2 - Drag left to resize'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Drawer'),
            const SizedBox(height: 8),
            GrafitText.muted('A drawer that slides in from the edge of the screen.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GrafitButton(
                  label: 'Open Left Drawer',
                  variant: GrafitButtonVariant.primary,
                  onPressed: () => _openDrawer(context, GrafitDrawerSide.left),
                ),
                GrafitButton(
                  label: 'Open Right Drawer',
                  variant: GrafitButtonVariant.secondary,
                  onPressed: () => _openDrawer(context, GrafitDrawerSide.right),
                ),
                GrafitButton(
                  label: 'Open Top Drawer',
                  variant: GrafitButtonVariant.outline,
                  onPressed: () => _openDrawer(context, GrafitDrawerSide.top),
                ),
                GrafitButton(
                  label: 'Open Bottom Drawer',
                  variant: GrafitButtonVariant.ghost,
                  onPressed: () => _openDrawer(context, GrafitDrawerSide.bottom),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDrawer(BuildContext context, GrafitDrawerSide side) {
    GrafitDrawer.open(
      context,
      side: side,
      child: SizedBox(
        width: side == GrafitDrawerSide.left || side == GrafitDrawerSide.right ? 300 : null,
        height: side == GrafitDrawerSide.top || side == GrafitDrawerSide.bottom ? 250 : null,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GrafitText.titleLarge('Drawer'),
                  GrafitButton(
                    variant: GrafitButtonVariant.ghost,
                    size: GrafitButtonSize.icon,
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const GrafitSeparator(),
              const SizedBox(height: 16),
              _buildDrawerItem(Icons.home, 'Home', () {}),
              _buildDrawerItem(Icons.settings, 'Settings', () {}),
              _buildDrawerItem(Icons.person, 'Profile', () {}),
              _buildDrawerItem(Icons.help, 'Help', () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            GrafitText.bodyMedium(label),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollAreaSection(BuildContext context, GrafitTheme theme) {
    // Generate long content
    final longContent = List.generate(
      20,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GrafitCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GrafitText.titleMedium('Item ${index + 1}'),
                const SizedBox(height: 8),
                GrafitText.muted('This is item number ${index + 1} in the scrollable area.'),
              ],
            ),
          ),
        ),
      ),
    );

    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Scroll Area'),
            const SizedBox(height: 8),
            GrafitText.muted('A scrollable container with custom scrollbar styling.'),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: GrafitScrollArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: longContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordionSection(BuildContext context, GrafitTheme theme) {
    return GrafitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GrafitText.titleMedium('Accordion'),
            const SizedBox(height: 8),
            GrafitText.muted('Vertically stacked headers that can expand to reveal content.'),
            const SizedBox(height: 16),
            GrafitAccordion(
              items: [
                GrafitAccordionItem(
                  title: 'Is it accessible?',
                  description: 'Yes. It adheres to the WAI-ARIA design pattern.',
                  content: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: GrafitText.muted('The accordion component follows WAI-ARIA guidelines for accessibility. It supports keyboard navigation, screen readers, and proper ARIA attributes.'),
                  ),
                ),
                GrafitAccordionItem(
                  title: 'Is it styled?',
                  description: 'Yes. It comes with default styles.',
                  content: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: GrafitText.muted('The accordion is styled using the Grafit theme system. You can customize the appearance using theme extensions or custom styles.'),
                  ),
                ),
                GrafitAccordionItem(
                  title: 'Can I use it in my project?',
                  description: 'Yes. It\'s open source and free to use.',
                  content: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: GrafitText.muted('Grafit UI is open source and available under the MIT license. Feel free to use it in your personal and commercial projects.'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
