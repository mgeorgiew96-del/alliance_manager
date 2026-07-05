import 'package:flutter/material.dart';

import '../../../shared/enums/member_rank.dart';
import '../../../shared/theme/am_spacing.dart';

class RankFilterChips extends StatelessWidget {
  const RankFilterChips({
    super.key,
    required this.selectedRank,
    required this.onChanged,
  });

  final MemberRank? selectedRank;
  final ValueChanged<MemberRank?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AMSpacing.sm,
      runSpacing: AMSpacing.sm,
      children: [
        ChoiceChip(
          label: const Text('All'),
          selected: selectedRank == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final rank in MemberRank.values)
          ChoiceChip(
            label: Text(rank.name.toUpperCase()),
            selected: selectedRank == rank,
            onSelected: (_) => onChanged(rank),
          ),
      ],
    );
  }
}