import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import '../models/component.dart';

/// Manages the component registry for Grafit UI
class ComponentRegistry {
  /// Path to the grafit_ui package
  late final String _grafitUiPath;

  /// Cache of loaded components
  final Map<String, GrafitComponent> _cache = {};

  ComponentRegistry([String? basePath]) {
    // Determine the path to grafit_ui package
    if (basePath != null) {
      _grafitUiPath = basePath;
    } else {
      // Default: assume we're in the monorepo structure
      final cliPath = p.dirname(p.dirname(p.fromUri(Platform.script)));
      _grafitUiPath = p.normalize(p.join(cliPath, '..', 'packages', 'grafit_ui'));
    }
  }

  /// Get all components from the registry
  List<GrafitComponent> getAllComponents() {
    if (_cache.isNotEmpty) {
      return _cache.values.toList();
    }

    _loadComponentsFromRegistry();
    return _cache.values.toList();
  }

  /// Get a specific component by name
  GrafitComponent? getComponent(String name) {
    if (_cache.isEmpty) {
      _loadComponentsFromRegistry();
    }
    return _cache[name.toLowerCase()];
  }

  /// Get components by category
  List<GrafitComponent> getComponentsByCategory(String category) {
    return getAllComponents()
        .where((c) => c.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Check if a component exists
  bool hasComponent(String name) {
    return getComponent(name) != null;
  }

  /// Get all categories
  List<String> getCategories() {
    return getAllComponents()
        .map((c) => c.category)
        .toSet()
        .toList()
      ..sort();
  }

  /// Load components from the grafit_ui package structure
  void _loadComponentsFromRegistry() {
    final libPath = p.join(_grafitUiPath, 'lib');
    
    if (!Directory(libPath).existsSync()) {
      print('Warning: grafit_ui package not found at $_grafitUiPath');
      return;
    }

    // Load from the main grafit_ui.dart export file
    final mainFile = File(p.join(libPath, 'grafit_ui.dart'));
    if (!mainFile.existsSync()) {
      return;
    }

    final content = mainFile.readAsStringSync();
    
    // Parse component categories from the export statements
    final categories = {
      'form': 'Form',
      'layout': 'Layout',
      'typography': 'Typography',
      'navigation': 'Navigation',
      'overlay': 'Overlay',
      'feedback': 'Feedback',
      'data-display': 'Data Display',
      'specialized': 'Specialized',
    };

    // Define all known components with their metadata
    final components = _defineAllComponents();

    for (final component in components) {
      _cache[component.name.toLowerCase()] = component;
    }
  }

  /// Define all available components with their metadata
  List<GrafitComponent> _defineAllComponents() {
    return [
      // Form Components (17)
      GrafitComponent(
        name: 'button',
        category: 'form',
        description: 'Button component with variants (default, destructive, outline, ghost, link)',
        sourcePath: 'lib/src/components/form/button.dart',
        dartPath: 'lib/src/components/form/button.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'button-group',
        category: 'form',
        description: 'Group of buttons with connected styling',
        sourcePath: 'lib/src/components/form/button_group.dart',
        dartPath: 'lib/src/components/form/button_group.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'input',
        category: 'form',
        description: 'Text input field with decoration and error states',
        sourcePath: 'lib/src/components/form/input.dart',
        dartPath: 'lib/src/components/form/input.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'input-group',
        category: 'form',
        description: 'Input with add-ons (prefix/suffix)',
        sourcePath: 'lib/src/components/form/input_group.dart',
        dartPath: 'lib/src/components/form/input_group.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'input-otp',
        category: 'form',
        description: 'OTP input fields with auto-focus',
        sourcePath: 'lib/src/components/form/input_otp.dart',
        dartPath: 'lib/src/components/form/input_otp.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'textarea',
        category: 'form',
        description: 'Multi-line text input component',
        sourcePath: 'lib/src/components/form/textarea.dart',
        dartPath: 'lib/src/components/form/textarea.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'checkbox',
        category: 'form',
        description: 'Checkbox input component',
        sourcePath: 'lib/src/components/form/checkbox.dart',
        dartPath: 'lib/src/components/form/checkbox.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'radio-group',
        category: 'form',
        description: 'Radio button group component',
        sourcePath: 'lib/src/components/form/radio_group.dart',
        dartPath: 'lib/src/components/form/radio_group.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'switch',
        category: 'form',
        description: 'Toggle switch component',
        sourcePath: 'lib/src/components/form/switch.dart',
        dartPath: 'lib/src/components/form/switch.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'slider',
        category: 'form',
        description: 'Range slider component',
        sourcePath: 'lib/src/components/form/slider.dart',
        dartPath: 'lib/src/components/form/slider.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'select',
        category: 'form',
        description: 'Custom select dropdown component',
        sourcePath: 'lib/src/components/form/select.dart',
        dartPath: 'lib/src/components/form/select.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'native-select',
        category: 'form',
        description: 'Native platform select dropdown',
        sourcePath: 'lib/src/components/form/native_select.dart',
        dartPath: 'lib/src/components/form/native_select.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'combobox',
        category: 'form',
        description: 'Combobox input with search/filter',
        sourcePath: 'lib/src/components/form/combobox.dart',
        dartPath: 'lib/src/components/form/combobox.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'field',
        category: 'form',
        description: 'Form field wrapper with label and error',
        sourcePath: 'lib/src/components/form/field.dart',
        dartPath: 'lib/src/components/form/field.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'label',
        category: 'form',
        description: 'Form field label component',
        sourcePath: 'lib/src/components/form/label.dart',
        dartPath: 'lib/src/components/form/label.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'toggle',
        category: 'form',
        description: 'Toggle button component',
        sourcePath: 'lib/src/components/form/toggle.dart',
        dartPath: 'lib/src/components/form/toggle.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'toggle-group',
        category: 'form',
        description: 'Toggle button group component',
        sourcePath: 'lib/src/components/form/toggle_group.dart',
        dartPath: 'lib/src/components/form/toggle_group.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'form',
        category: 'form',
        description: 'Form widget with validation',
        sourcePath: 'lib/src/components/form/form.dart',
        dartPath: 'lib/src/components/form/form.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'auto-form',
        category: 'form',
        description: 'Auto-generated form from schema',
        sourcePath: 'lib/src/components/form/auto_form.dart',
        dartPath: 'lib/src/components/form/auto_form.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'date-picker',
        category: 'form',
        description: 'Date picker widget',
        sourcePath: 'lib/src/components/form/date_picker.dart',
        dartPath: 'lib/src/components/form/date_picker.dart',
        status: 'stable',
        parity: 100,
      ),

      // Layout Components (4)
      GrafitComponent(
        name: 'card',
        category: 'layout',
        description: 'Card container component',
        sourcePath: 'lib/src/components/layout/card.dart',
        dartPath: 'lib/src/components/layout/card.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'separator',
        category: 'layout',
        description: 'Visual separator/divider',
        sourcePath: 'lib/src/components/layout/separator.dart',
        dartPath: 'lib/src/components/layout/separator.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'accordion',
        category: 'layout',
        description: 'Collapsible accordion component',
        sourcePath: 'lib/src/components/layout/accordion.dart',
        dartPath: 'lib/src/components/layout/accordion.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'aspect-ratio',
        category: 'specialized',
        description: 'Aspect ratio container',
        sourcePath: 'lib/src/components/specialized/aspect_ratio.dart',
        dartPath: 'lib/src/components/specialized/aspect_ratio.dart',
        status: 'stable',
        parity: 100,
      ),

      // Typography Components (2)
      GrafitComponent(
        name: 'text',
        category: 'typography',
        description: 'Text with predefined styles',
        sourcePath: 'lib/src/components/typography/text.dart',
        dartPath: 'lib/src/components/typography/text.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'kbd',
        category: 'typography',
        description: 'Keyboard key display',
        sourcePath: 'lib/src/components/typography/kbd.dart',
        dartPath: 'lib/src/components/typography/kbd.dart',
        status: 'stable',
        parity: 100,
      ),

      // Navigation Components (6)
      GrafitComponent(
        name: 'tabs',
        category: 'navigation',
        description: 'Tabbed navigation',
        sourcePath: 'lib/src/components/navigation/tabs.dart',
        dartPath: 'lib/src/components/navigation/tabs.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'dropdown-menu',
        category: 'navigation',
        description: 'Dropdown menu component',
        sourcePath: 'lib/src/components/navigation/dropdown_menu.dart',
        dartPath: 'lib/src/components/navigation/dropdown_menu.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'navigation-menu',
        category: 'navigation',
        description: 'Navigation menu component',
        sourcePath: 'lib/src/components/navigation/navigation_menu.dart',
        dartPath: 'lib/src/components/navigation/navigation_menu.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'breadcrumb',
        category: 'navigation',
        description: 'Breadcrumb navigation',
        sourcePath: 'lib/src/components/navigation/breadcrumb.dart',
        dartPath: 'lib/src/components/navigation/breadcrumb.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'menubar',
        category: 'navigation',
        description: 'Menu bar component',
        sourcePath: 'lib/src/components/navigation/menubar.dart',
        dartPath: 'lib/src/components/navigation/menubar.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'sidebar',
        category: 'navigation',
        description: 'Collapsible sidebar',
        sourcePath: 'lib/src/components/navigation/sidebar.dart',
        dartPath: 'lib/src/components/navigation/sidebar.dart',
        status: 'stable',
        parity: 100,
      ),

      // Overlay Components (7)
      GrafitComponent(
        name: 'dialog',
        category: 'overlay',
        description: 'Modal dialog',
        sourcePath: 'lib/src/components/overlay/dialog.dart',
        dartPath: 'lib/src/components/overlay/dialog.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'sheet',
        category: 'overlay',
        description: 'Slide-out sheet',
        sourcePath: 'lib/src/components/specialized/sheet.dart',
        dartPath: 'lib/src/components/specialized/sheet.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'drawer',
        category: 'overlay',
        description: 'Side drawer',
        sourcePath: 'lib/src/components/specialized/drawer.dart',
        dartPath: 'lib/src/components/specialized/drawer.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'popover',
        category: 'overlay',
        description: 'Popover overlay',
        sourcePath: 'lib/src/components/overlay/popover.dart',
        dartPath: 'lib/src/components/overlay/popover.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'tooltip',
        category: 'overlay',
        description: 'Tooltip popup',
        sourcePath: 'lib/src/components/overlay/tooltip.dart',
        dartPath: 'lib/src/components/overlay/tooltip.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'context-menu',
        category: 'overlay',
        description: 'Right-click context menu',
        sourcePath: 'lib/src/components/overlay/context_menu.dart',
        dartPath: 'lib/src/components/overlay/context_menu.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'command',
        category: 'overlay',
        description: 'Command palette',
        sourcePath: 'lib/src/components/overlay/command.dart',
        dartPath: 'lib/src/components/overlay/command.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'hover-card',
        category: 'overlay',
        description: 'Card on hover',
        sourcePath: 'lib/src/components/overlay/hover_card.dart',
        dartPath: 'lib/src/components/overlay/hover_card.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'alert-dialog',
        category: 'overlay',
        description: 'Alert modal dialog',
        sourcePath: 'lib/src/components/overlay/alert_dialog.dart',
        dartPath: 'lib/src/components/overlay/alert_dialog.dart',
        status: 'stable',
        parity: 100,
      ),

      // Feedback Components (5)
      GrafitComponent(
        name: 'alert',
        category: 'feedback',
        description: 'Alert banner',
        sourcePath: 'lib/src/components/feedback/alert.dart',
        dartPath: 'lib/src/components/feedback/alert.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'progress',
        category: 'feedback',
        description: 'Progress indicator',
        sourcePath: 'lib/src/components/feedback/progress.dart',
        dartPath: 'lib/src/components/feedback/progress.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'skeleton',
        category: 'feedback',
        description: 'Loading skeleton',
        sourcePath: 'lib/src/components/feedback/skeleton.dart',
        dartPath: 'lib/src/components/feedback/skeleton.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'sonner',
        category: 'feedback',
        description: 'Toast notification (Sonner)',
        sourcePath: 'lib/src/components/feedback/sonner.dart',
        dartPath: 'lib/src/components/feedback/sonner.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'spinner',
        category: 'feedback',
        description: 'Loading spinner',
        sourcePath: 'lib/src/components/feedback/spinner.dart',
        dartPath: 'lib/src/components/feedback/spinner.dart',
        status: 'stable',
        parity: 100,
      ),

      // Data Display Components (7)
      GrafitComponent(
        name: 'badge',
        category: 'data-display',
        description: 'Badge/label component',
        sourcePath: 'lib/src/components/data-display/badge.dart',
        dartPath: 'lib/src/components/data-display/badge.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'avatar',
        category: 'data-display',
        description: 'User avatar',
        sourcePath: 'lib/src/components/data-display/avatar.dart',
        dartPath: 'lib/src/components/data-display/avatar.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'item',
        category: 'data-display',
        description: 'List item component',
        sourcePath: 'lib/src/components/data-display/item.dart',
        dartPath: 'lib/src/components/data-display/item.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'data-table',
        category: 'data-display',
        description: 'Advanced data table',
        sourcePath: 'lib/src/components/data-display/data_table.dart',
        dartPath: 'lib/src/components/data-display/data_table.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'pagination',
        category: 'data-display',
        description: 'Pagination controls',
        sourcePath: 'lib/src/components/data-display/pagination.dart',
        dartPath: 'lib/src/components/data-display/pagination.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'empty',
        category: 'data-display',
        description: 'Empty state placeholder',
        sourcePath: 'lib/src/components/data-display/empty.dart',
        dartPath: 'lib/src/components/data-display/empty.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'table',
        category: 'data-display',
        description: 'Basic table component',
        sourcePath: 'lib/src/components/data-display/table.dart',
        dartPath: 'lib/src/components/data-display/table.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'chart',
        category: 'data-display',
        description: 'Chart component',
        sourcePath: 'lib/src/components/data-display/chart.dart',
        dartPath: 'lib/src/components/data-display/chart.dart',
        status: 'stable',
        parity: 100,
      ),

      // Specialized Components (7)
      GrafitComponent(
        name: 'calendar',
        category: 'specialized',
        description: 'Calendar widget',
        sourcePath: 'lib/src/components/specialized/calendar.dart',
        dartPath: 'lib/src/components/specialized/calendar.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'carousel',
        category: 'specialized',
        description: 'Image/content carousel',
        sourcePath: 'lib/src/components/specialized/carousel.dart',
        dartPath: 'lib/src/components/specialized/carousel.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'resizable',
        category: 'specialized',
        description: 'Resizable panels',
        sourcePath: 'lib/src/components/specialized/resizable.dart',
        dartPath: 'lib/src/components/specialized/resizable.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'scroll-area',
        category: 'specialized',
        description: 'Scrollable area',
        sourcePath: 'lib/src/components/specialized/scroll_area.dart',
        dartPath: 'lib/src/components/specialized/scroll_area.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'collapsible',
        category: 'specialized',
        description: 'Collapsible content',
        sourcePath: 'lib/src/components/specialized/collapsible.dart',
        dartPath: 'lib/src/components/specialized/collapsible.dart',
        status: 'stable',
        parity: 100,
      ),
      GrafitComponent(
        name: 'direction',
        category: 'specialized',
        description: 'Direction indicators',
        sourcePath: 'lib/src/components/specialized/direction.dart',
        dartPath: 'lib/src/components/specialized/direction.dart',
        status: 'stable',
        parity: 100,
      ),
    ];
  }
}
