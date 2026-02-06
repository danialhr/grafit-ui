import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/theme_data.dart';

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
