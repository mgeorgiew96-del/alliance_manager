import 'package:flutter/material.dart';

import '../../features/equipment/models/equipment_jewel_type.dart';
import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_asset_image.dart';
import 'am_card.dart';
import 'am_progress_bar.dart';

class AMEquipmentSlotCard extends StatelessWidget {
  const AMEquipmentSlotCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.progress,
    required this.trackedEnhancementCount,
    required this.totalEnhancementCount,
    required this.jewelType,
    required this.jewelLevels,
    required this.onOpen,
    this.warningText,
  });

  final String title;
  final String imagePath;

  final double progress;

  final int trackedEnhancementCount;
  final int totalEnhancementCount;

  final EquipmentJewelType jewelType;
  final List<int> jewelLevels;

  final String? warningText;
  final VoidCallback onOpen;

  bool get _isComplete {
    return progress >= 1;
  }

  String get _jewelName {
    final rawName = jewelType.name;

    if (rawName.isEmpty) {
      return rawName;
    }

    return '${rawName[0].toUpperCase()}'
        '${rawName.substring(1)}';
  }

  String get _jewelLevelsText {
    if (jewelLevels.isEmpty) {
      return 'No jewels';
    }

    return jewelLevels
        .asMap()
        .entries
        .map((entry) => 'Jewel ${entry.key + 1}: Lv. ${entry.value}')
        .join('  •  ');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final progressColor = _isComplete ? Colors.green : colorScheme.primary;

    return AMCard(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AMSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: progressColor,
                      width: _isComplete ? 2 : 1.2,
                    ),
                    boxShadow: [
                      if (_isComplete)
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.22),
                          blurRadius: 16,
                        ),
                    ],
                  ),
                  child: AMAssetImage(
                    path: imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(15),
                    fallbackIcon: Icons.inventory_2_outlined,
                    fallbackIconSize: 64,
                  ),
                ),
              ),
              const SizedBox(height: AMSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: AMTextStyles.subtitle,
                    ),
                  ),
                  if (_isComplete)
                    const Text(
                      'MAX',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    )
                  else
                    const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: AMSpacing.sm),
              AMProgressBar(progress: progress),
              const SizedBox(height: AMSpacing.sm),
              Row(
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: AMTextStyles.body,
                  ),
                  const Spacer(),
                  Text(
                    '$trackedEnhancementCount / '
                    '$totalEnhancementCount tracked',
                    style: AMTextStyles.muted,
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AMSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_jewelName JEWELS', style: AMTextStyles.body),
                    const SizedBox(height: AMSpacing.xs),
                    Text(_jewelLevelsText, style: AMTextStyles.muted),
                  ],
                ),
              ),
              if (warningText != null && warningText!.trim().isNotEmpty) ...[
                const SizedBox(height: AMSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: AMSpacing.sm),
                    Expanded(
                      child: Text(warningText!, style: AMTextStyles.muted),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
