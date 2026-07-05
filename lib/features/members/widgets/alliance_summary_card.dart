import 'package:flutter/material.dart';

import '../../../shared/enums/member_rank.dart';
import '../../../shared/mock/mock_alliance_configuration.dart';
import '../../../shared/models/member_model.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';

class AllianceSummaryCard extends StatelessWidget {
  const AllianceSummaryCard({
    super.key,
    required this.members,
  });

  final List<MemberModel> members;

  int _count(MemberRank rank) {
    return members.where((member) => member.rank == rank).length;
  }

  @override
  Widget build(BuildContext context) {
    final r5 = _count(MemberRank.r5);
    final r4 = _count(MemberRank.r4);
    final r3 = _count(MemberRank.r3);
    final r2 = _count(MemberRank.r2);
    final r1 = _count(MemberRank.r1);

    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alliance Structure', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.md),
          _SummaryRow(label: 'Leader', value: '$r5 / ${mockAllianceConfiguration.maxR5}'),
          _SummaryRow(label: 'Deputies', value: '$r4 / ${mockAllianceConfiguration.maxR4}'),
          _SummaryRow(label: 'Officers', value: '$r3 / ${mockAllianceConfiguration.maxR3}'),
          _SummaryRow(label: 'Elite', value: '$r2 / ${mockAllianceConfiguration.maxR2}'),
          _SummaryRow(label: 'Members', value: '$r1'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AMTextStyles.body),
          Text(value, style: AMTextStyles.body),
        ],
      ),
    );
  }
}