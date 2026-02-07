import 'package:yaml/yaml.dart';

/// Represents a Grafit UI component with its metadata
class GrafitComponent {
  /// Component name (e.g., 'button', 'input')
  final String name;

  /// Component category (e.g., 'forms', 'navigation', 'layout')
  final String category;

  /// Human-readable description
  final String description;

  /// Path to source template files
  final String sourcePath;

  /// Path to generated Dart file
  final String dartPath;

  /// Component status (e.g., 'stable', 'beta', 'alpha')
  final String status;

  /// Parity score (0-100) compared to reference implementation
  final int parity;

  /// List of dependencies (other components this requires)
  final List<String> dependencies;

  /// List of files included in this component
  final List<String> files;

  /// Documentation path
  final String? docsPath;

  GrafitComponent({
    required this.name,
    required this.category,
    required this.description,
    required this.sourcePath,
    required this.dartPath,
    required this.status,
    required this.parity,
    this.dependencies = const [],
    this.files = const [],
    this.docsPath,
  });

  /// Create component from YAML map
  factory GrafitComponent.fromYaml(Map<String, dynamic> yaml) {
    return GrafitComponent(
      name: yaml['name'] as String,
      category: yaml['category'] as String? ?? 'uncategorized',
      description: yaml['description'] as String? ?? '',
      sourcePath: yaml['sourcePath'] as String? ?? '',
      dartPath: yaml['dartPath'] as String? ?? '',
      status: yaml['status'] as String? ?? 'stable',
      parity: yaml['parity'] as int? ?? 100,
      dependencies: (yaml['dependencies'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      files: (yaml['files'] as List?)?.map((e) => e.toString()).toList() ?? [],
      docsPath: yaml['docs'] as String?,
    );
  }

  /// Create component from YAML node
  factory GrafitComponent.fromYamlNode(YamlMap yaml) {
    final map = <String, dynamic>{};
    for (final entry in yaml.entries) {
      map[entry.key.toString()] = entry.value;
    }
    return GrafitComponent.fromYaml(map);
  }

  /// Create component from JSON map (registry)
  factory GrafitComponent.fromJson(Map<String, dynamic> json) {
    return GrafitComponent(
      name: json['name'] as String,
      category: json['category'] as String? ?? 'uncategorized',
      description: json['description'] as String? ?? '',
      sourcePath: '',
      dartPath: '',
      status: 'stable',
      parity: 100,
      dependencies: (json['dependencies'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      files: (json['files'] as List?)?.map((e) => e.toString()).toList() ?? [],
      docsPath: json['docs'] as String?,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'sourcePath': sourcePath,
      'dartPath': dartPath,
      'status': status,
      'parity': parity,
      'dependencies': dependencies,
      'files': files,
      if (docsPath != null) 'docs': docsPath,
    };
  }

  /// Check if component is stable
  bool get isStable => status == 'stable';

  /// Check if component is in development
  bool get isBeta => status == 'beta' || status == 'alpha';

  /// Check if component has full parity
  bool get hasFullParity => parity >= 90;

  @override
  String toString() {
    return 'GrafitComponent(name: $name, category: $category, status: $status, parity: $parity%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GrafitComponent && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// Component category enum
enum ComponentCategory {
  form('Form', 'Form controls and input components'),
  layout('Layout', 'Layout and container components'),
  typography('Typography', 'Text and typography components'),
  navigation('Navigation', 'Navigation and menu components'),
  overlay('Overlay', 'Overlay and modal components'),
  feedback('Feedback', 'Feedback and notification components'),
  dataDisplay('Data Display', 'Data display and presentation components'),
  specialized('Specialized', 'Specialized utility components');

  final String displayName;
  final String description;

  const ComponentCategory(this.displayName, this.description);

  String get value => name;

  static ComponentCategory fromString(String value) {
    return ComponentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ComponentCategory.specialized,
    );
  }
}

/// Component status enum
enum ComponentStatus {
  stable('Stable', 'Ready for production use'),
  beta('Beta', 'Under active development'),
  alpha('Alpha', 'Experimental feature'),
  deprecated('Deprecated', 'Will be removed in future');

  final String displayName;
  final String description;

  const ComponentStatus(this.displayName, this.description);

  String get value => name;

  static ComponentStatus fromString(String value) {
    return ComponentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ComponentStatus.stable,
    );
  }
}
