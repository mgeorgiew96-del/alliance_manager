import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_asset_image.dart';
import 'am_card.dart';
import 'am_progress_bar.dart';

class AMCastleModuleCard extends StatelessWidget {
  const AMCastleModuleCard({
    super.key,
    required this.title,
    required this.progress,
    required this.onOpen,
    this.icon,
    this.imagePath,
    this.description,
    this.isAvailable = true,
  }) : assert(
         icon != null || imagePath != null,
         'Provide either icon or imagePath.',
       );

  final String title;

  /// Optional Material icon used as fallback or when no artwork exists.
  final IconData? icon;

  /// Optional custom module artwork.
  final String? imagePath;

  /// Progress from 0.0 to 1.0.
  final double progress;

  final VoidCallback onOpen;
  final String? description;
  final bool isAvailable;

  double get _safeProgress {
    return progress.clamp(0, 1).toDouble();
  }

  String get _percentageText {
    return '${(_safeProgress * 100).toStringAsFixed(1)}%';
  }

  String get _statusLabel {
    final percent = _safeProgress * 100;

    if (percent <= 20) {
      return 'Critical';
    }

    if (percent <= 50) {
      return 'Needs Work';
    }

    if (percent <= 80) {
      return 'Good';
    }

    return 'Excellent';
  }

  IconData get _statusIcon {
    final percent = _safeProgress * 100;

    if (percent <= 20) {
      return Icons.error_outline;
    }

    if (percent <= 50) {
      return Icons.trending_up;
    }

    if (percent <= 80) {
      return Icons.thumb_up_alt_outlined;
    }

    return Icons.verified_outlined;
  }

  IconData get _fallbackIcon {
    return icon ?? Icons.castle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Opacity(
        opacity: isAvailable ? 1 : 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModuleArtwork(
                  imagePath: imagePath,
                  fallbackIcon: _fallbackIcon,
                ),
                const SizedBox(width: AMSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AMTextStyles.subtitle),
                      if (description != null &&
                          description!.trim().isNotEmpty) ...[
                        const SizedBox(height: AMSpacing.xs),
                        Text(description!, style: AMTextStyles.muted),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.lg),
            Row(
              children: [
                Expanded(child: Text('Progress', style: AMTextStyles.body)),
                Text(_percentageText, style: AMTextStyles.subtitle),
              ],
            ),
            const SizedBox(height: AMSpacing.sm),
            AMProgressBar(progress: _safeProgress),
            const SizedBox(height: AMSpacing.sm),
            Row(
              children: [
                Icon(_statusIcon, size: 18),
                const SizedBox(width: AMSpacing.xs),
                Text(_statusLabel, style: AMTextStyles.muted),
              ],
            ),
            const SizedBox(height: AMSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isAvailable ? onOpen : null,
                icon: Icon(
                  isAvailable ? Icons.arrow_forward : Icons.lock_clock,
                ),
                label: Text(isAvailable ? 'OPEN' : 'COMING SOON'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleArtwork extends StatelessWidget {
  const _ModuleArtwork({required this.imagePath, required this.fallbackIcon});

  final String? imagePath;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.14),
            blurRadius: 12,
          ),
        ],
      ),
      child: imagePath == null
          ? Icon(fallbackIcon, size: 34)
          : AMAssetImage(
              path: imagePath!,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(15),
              fallbackIcon: fallbackIcon,
              fallbackIconSize: 34,
            ),
    );
  }
}
