import 'package:flutter/material.dart';

class AMAssetImage extends StatelessWidget {
  const AMAssetImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.fallbackIcon = Icons.image_not_supported_outlined,
    this.fallbackIconSize = 28,
  });

  final String path;

  final double? width;
  final double? height;

  /// Convenience value for square images.
  /// When supplied, it overrides width and height.
  final double? size;

  final BoxFit fit;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;

  final IconData fallbackIcon;
  final double fallbackIconSize;

  double? get _resolvedWidth {
    return size ?? width;
  }

  double? get _resolvedHeight {
    return size ?? height;
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      path,
      width: _resolvedWidth,
      height: _resolvedHeight,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: _resolvedWidth,
          height: _resolvedHeight,
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(fallbackIcon, size: fallbackIconSize),
        );
      },
    );

    final radius = borderRadius;

    if (radius == null) {
      return image;
    }

    return ClipRRect(borderRadius: radius, child: image);
  }
}
