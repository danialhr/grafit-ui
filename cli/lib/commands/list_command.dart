import 'package:args/command_runner.dart';

class ListCommand extends Command<void> {
  @override
  String get name => 'list';

  @override
  String get description => 'List all available components';

  @override
  Future<void> run() async {
    print('Available Components:');
    print('');

    // TODO: Load from component registry
    final components = _getAllComponents();

    // Group by category
    final categories = <String, List<Map<String, dynamic>>>{};
    for (final component in components) {
      final category = component['category'] as String;
      categories.putIfAbsent(category, () => []);
      categories[category]!.add(component);
    }

    // Display by category
    for (final entry in categories.entries) {
      print('${entry.key.toUpperCase()}');
      for (final component in entry.value) {
        final name = component['name'] as String;
        final description = component['description'] as String;
        print('  $name - $description');
      }
      print('');
    }

    print('Total: ${components.length} components');
  }

  List<Map<String, dynamic>> _getAllComponents() {
    return [
      // Layout (5)
      {'name': 'container', 'category': 'Layout', 'description': 'Container with styling'},
      {'name': 'grid', 'category': 'Layout', 'description': 'Grid layout component'},
      {'name': 'stack', 'category': 'Layout', 'description': 'Stack layout component'},
      {'name': 'separator', 'category': 'Layout', 'description': 'Visual separator/divider'},
      {'name': 'aspect-ratio', 'category': 'Layout', 'description': 'Aspect ratio container'},

      // Typography (3)
      {'name': 'text', 'category': 'Typography', 'description': 'Text with styles'},
      {'name': 'heading', 'category': 'Typography', 'description': 'Heading component'},
      {'name': 'kbd', 'category': 'Typography', 'description': 'Keyboard key display'},

      // Form Controls (15)
      {'name': 'button', 'category': 'Form', 'description': 'Button with variants'},
      {'name': 'button-group', 'category': 'Form', 'description': 'Group of buttons'},
      {'name': 'input', 'category': 'Form', 'description': 'Text input field'},
      {'name': 'input-group', 'category': 'Form', 'description': 'Input with add-ons'},
      {'name': 'input-otp', 'category': 'Form', 'description': 'OTP input fields'},
      {'name': 'textarea', 'category': 'Form', 'description': 'Multi-line text input'},
      {'name': 'checkbox', 'category': 'Form', 'description': 'Checkbox input'},
      {'name': 'radio-group', 'category': 'Form', 'description': 'Radio button group'},
      {'name': 'switch', 'category': 'Form', 'description': 'Toggle switch'},
      {'name': 'slider', 'category': 'Form', 'description': 'Range slider'},
      {'name': 'select', 'category': 'Form', 'description': 'Select dropdown'},
      {'name': 'native-select', 'category': 'Form', 'description': 'Native select dropdown'},
      {'name': 'combobox', 'category': 'Form', 'description': 'Combobox input'},
      {'name': 'field', 'category': 'Form', 'description': 'Form field wrapper'},
      {'name': 'label', 'category': 'Form', 'description': 'Form field label'},

      // Data Display (8)
      {'name': 'badge', 'category': 'Data Display', 'description': 'Badge/label component'},
      {'name': 'card', 'category': 'Data Display', 'description': 'Card container'},
      {'name': 'avatar', 'category': 'Data Display', 'description': 'User avatar'},
      {'name': 'table', 'category': 'Data Display', 'description': 'Data table'},
      {'name': 'data-table', 'category': 'Data Display', 'description': 'Advanced data table'},
      {'name': 'hover-card', 'category': 'Data Display', 'description': 'Card on hover'},
      {'name': 'empty', 'category': 'Data Display', 'description': 'Empty state placeholder'},
      {'name': 'item', 'category': 'Data Display', 'description': 'List item component'},

      // Feedback (7)
      {'name': 'alert', 'category': 'Feedback', 'description': 'Alert banner'},
      {'name': 'alert-dialog', 'category': 'Feedback', 'description': 'Alert modal dialog'},
      {'name': 'toast', 'category': 'Feedback', 'description': 'Toast notification (Sonner)'},
      {'name': 'progress', 'category': 'Feedback', 'description': 'Progress indicator'},
      {'name': 'skeleton', 'category': 'Feedback', 'description': 'Loading skeleton'},
      {'name': 'spinner', 'category': 'Feedback', 'description': 'Loading spinner'},

      // Navigation (7)
      {'name': 'tabs', 'category': 'Navigation', 'description': 'Tabbed navigation'},
      {'name': 'dropdown-menu', 'category': 'Navigation', 'description': 'Dropdown menu'},
      {'name': 'navigation-menu', 'category': 'Navigation', 'description': 'Navigation menu'},
      {'name': 'breadcrumb', 'category': 'Navigation', 'description': 'Breadcrumb navigation'},
      {'name': 'menubar', 'category': 'Navigation', 'description': 'Menu bar'},
      {'name': 'pagination', 'category': 'Navigation', 'description': 'Pagination controls'},
      {'name': 'sidebar', 'category': 'Navigation', 'description': 'Collapsible sidebar'},

      // Overlay (8)
      {'name': 'dialog', 'category': 'Overlay', 'description': 'Modal dialog'},
      {'name': 'sheet', 'category': 'Overlay', 'description': 'Slide-out sheet'},
      {'name': 'drawer', 'category': 'Overlay', 'description': 'Side drawer'},
      {'name': 'popover', 'category': 'Overlay', 'description': 'Popover overlay'},
      {'name': 'tooltip', 'category': 'Overlay', 'description': 'Tooltip popup'},
      {'name': 'context-menu', 'category': 'Overlay', 'description': 'Right-click menu'},
      {'name': 'command', 'category': 'Overlay', 'description': 'Command palette'},
      {'name': 'collapsible', 'category': 'Overlay', 'description': 'Collapsible content'},

      // Specialized (5)
      {'name': 'calendar', 'category': 'Specialized', 'description': 'Calendar widget'},
      {'name': 'date-picker', 'category': 'Specialized', 'description': 'Date picker'},
      {'name': 'carousel', 'category': 'Specialized', 'description': 'Image/content carousel'},
      {'name': 'toggle', 'category': 'Specialized', 'description': 'Toggle button'},
      {'name': 'toggle-group', 'category': 'Specialized', 'description': 'Toggle button group'},
      {'name': 'resizable', 'category': 'Specialized', 'description': 'Resizable panels'},
      {'name': 'scroll-area', 'category': 'Specialized', 'description': 'Scrollable area'},
      {'name': 'direction', 'category': 'Specialized', 'description': 'Direction indicators'},
    ];
  }
}
