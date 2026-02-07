import '../config/config_manager.dart';

/// Represents a single component from the registry
class ComponentInfo {
  final String name;
  final String upstream;
  final String flutterPath;
  final String metadataPath;
  final String category;
  final String status;
  final int parity;
  final String? lastChecked;
  final String? lastSynced;

  ComponentInfo({
    required this.name,
    required this.upstream,
    required this.flutterPath,
    required this.metadataPath,
    required this.category,
    required this.status,
    required this.parity,
    this.lastChecked,
    this.lastSynced,
  });

  factory ComponentInfo.fromYaml(
    String name,
    Map<String, dynamic> data,
    Map<String, String> categories,
  ) {
    final categoryKey = data['category'] as String?;
    final category = categories[categoryKey] ?? categoryKey ?? 'unknown';

    return ComponentInfo(
      name: name,
      upstream: data['upstream'] as String? ?? name,
      flutterPath: data['flutter'] as String? ?? '',
      metadataPath: data['metadata'] as String? ?? '',
      category: category,
      status: data['status'] as String? ?? 'unknown',
      parity: (data['parity'] as num?)?.toInt() ?? 0,
      lastChecked: data['lastChecked'] as String?,
      lastSynced: data['lastSynced'] as String?,
    );
  }

  bool get isImplemented => status == 'implemented';
  bool get isFullySynced => parity == 100;
}

/// Loaded registry data
class ComponentRegistry {
  final Map<String, dynamic> upstream;
  final Map<String, ComponentInfo> components;
  final Map<String, String> categories;

  ComponentRegistry({
    required this.upstream,
    required this.components,
    required this.categories,
  });

  List<ComponentInfo> getComponentsByCategory(String category) {
    return components.values
        .where((c) => c.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  ComponentInfo? getComponent(String name) {
    return components[name];
  }

  List<String> getCategories() {
    return categories.values.toSet().toList()..sort();
  }
}