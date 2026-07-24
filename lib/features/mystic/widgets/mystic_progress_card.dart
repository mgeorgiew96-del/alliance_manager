import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';

class MysticProgressCard extends StatelessWidget {
  const MysticProgressCard({
    super.key,
    required this.overallProgress,
    required this.troopProgress,
    required this.trackedSkills,
    required this.totalSkills,
    required this.prioritySkills,
    required this.lastUpdated,
  });

  /// Progress values are normalized from 0.0 to 1.0.
  final double overallProgress;

  /// Each troop progress value is normalized from 0.0 to 1.0.
  final Map<String, double> troopProgress;

  final int trackedSkills;
  final int totalSkills;
  final int prioritySkills;
  final DateTime? lastUpdated;

  double _normalized(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }

  String _percentage(double value) {
    return '${(_normalized(value) * 100).toStringAsFixed(1)}%';
  }

  String _lastUpdatedText() {
    final value = lastUpdated;

    if (value == null) {
      return 'Not saved yet';
    }

    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Mystic Progress',
            style: AMTextStyles.title.copyWith(fontSize: 20),
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Two active troop types contribute 40% each. '
            'Angels contribute 20%.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.lg),
          _ProgressLine(
            label: 'Overall',
            value: _normalized(overallProgress),
            percentageText: _percentage(overallProgress),
            emphasized: true,
          ),
          for (final entry in troopProgress.entries) ...[
            const SizedBox(height: AMSpacing.md),
            _ProgressLine(
              label: entry.key,
              value: _normalized(entry.value),
              percentageText: _percentage(entry.value),
            ),
          ],
          const SizedBox(height: AMSpacing.md),
          const Divider(color: Colors.white12),
          const SizedBox(height: AMSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Tracked',
                  value: '$trackedSkills / $totalSkills',
                  icon: Icons.check_circle_outline,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Priority',
                  value: '$prioritySkills',
                  icon: Icons.star_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            'Last updated: ${_lastUpdatedText()}',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.percentageText,
    this.emphasized = false,
  });

  final String label;

  /// Normalized value from 0.0 to 1.0.
  final double value;

  final String percentageText;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AMTextStyles.body.copyWith(
                  fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ),
            Text(
              percentageText,
              style: TextStyle(
                color: AMColors.goldLight,
                fontWeight: FontWeight.w900,
                fontSize: emphasized ? 18 : 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AMSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            minHeight: emphasized ? 11 : 9,
            value: value.clamp(0.0, 1.0).toDouble(),
            backgroundColor: AMColors.panelLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AMColors.gold),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AMColors.gold, size: 22),
        const SizedBox(width: AMSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AMTextStyles.body),
              Text(label, style: AMTextStyles.muted),
            ],
          ),
        ),
      ],
    );
  }
}
