import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Avatar component
class GrafitAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final Widget? fallback;
  final double size;
  final Color? backgroundColor;

  const GrafitAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.fallback,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GrafitTheme>()!;
    final colors = theme.colors;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.muted,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: _buildContent(colors),
      ),
    );
  }

  Widget _buildContent(GrafitColorScheme colors) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(colors);
        },
      );
    }

    if (fallback != null) {
      return fallback!;
    }

    return _buildFallback(colors);
  }

  Widget _buildFallback(GrafitColorScheme colors) {
    if (name != null && name!.isNotEmpty) {
      final initials = name!
          .split(' ')
          .take(2)
          .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
          .join();

      return Center(
        child: Text(
          initials,
          style: TextStyle(
            color: colors.foreground,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Icon(
      Icons.person,
      size: size * 0.5,
      color: colors.mutedForeground,
    );
  }
}

// Widgetbook use cases
@widgetbook.UseCase(
  name: 'Default',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarDefault(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: GrafitAvatar(
      name: 'John Doe',
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Initials',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarInitials(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitAvatar(name: 'Alice'),
        SizedBox(width: 8),
        GrafitAvatar(name: 'Bob Smith'),
        SizedBox(width: 8),
        GrafitAvatar(name: 'Charlie Brown Jr'),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Sizes',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarSizes(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GrafitAvatar(name: 'XS', size: 24),
        SizedBox(width: 8),
        GrafitAvatar(name: 'S', size: 32),
        SizedBox(width: 8),
        GrafitAvatar(name: 'M', size: 40),
        SizedBox(width: 8),
        GrafitAvatar(name: 'L', size: 56),
        SizedBox(width: 8),
        GrafitAvatar(name: 'XL', size: 80),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Image',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarWithImage(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitAvatar(
          imageUrl: 'https://i.pravatar.cc/150?img=1',
          name: 'Jane Doe',
          size: 40,
        ),
        SizedBox(width: 12),
        GrafitAvatar(
          imageUrl: 'https://i.pravatar.cc/150?img=2',
          name: 'Bob Smith',
          size: 56,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Fallback Icon',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarFallbackIcon(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitAvatar(size: 32),
        SizedBox(width: 8),
        GrafitAvatar(size: 40),
        SizedBox(width: 8),
        GrafitAvatar(size: 56),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Avatar Group',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarGroup(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        const GrafitAvatar(name: 'Alice', size: 36),
        Transform.translate(
          offset: const Offset(-12, 0),
          child: const GrafitAvatar(name: 'Bob', size: 36),
        ),
        Transform.translate(
          offset: const Offset(-24, 0),
          child: const GrafitAvatar(name: 'Charlie', size: 36),
        ),
        Transform.translate(
          offset: const Offset(-36, 0),
          child: const GrafitAvatar(name: 'Diana', size: 36),
        ),
        Transform.translate(
          offset: const Offset(-48, 0),
          child: GrafitAvatar(
            name: '',
            size: 36,
            fallback: Center(
              child: Text(
                '+5',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Fallback',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarCustomFallback(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        GrafitAvatar(
          size: 40,
          fallback: Icon(Icons.star, color: Colors.amber),
        ),
        SizedBox(width: 12),
        GrafitAvatar(
          size: 40,
          fallback: Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: GrafitAvatar,
  path: 'DataDisplay/Avatar',
)
Widget avatarInteractive(BuildContext context) {
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final name = context.knobs.string(label: 'Name', initialValue: 'John Doe');
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final size = context.knobs.double.slider(label: 'Size', initialValue: 40, min: 24, max: 120);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showImage = context.knobs.boolean(label: 'Show Image', initialValue: false);
  // Widgetbook-only: ignore undefined_getter, undefined_method, invalid_annotation_value
  final showFallback = context.knobs.boolean(label: 'Custom Fallback', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GrafitAvatar(
      name: name.isNotEmpty ? name : null,
      size: size,
      imageUrl: showImage ? 'https://i.pravatar.cc/150?img=3' : null,
      fallback: showFallback
          ? const Icon(Icons.star, color: Colors.amber)
          : null,
    ),
  );
}
