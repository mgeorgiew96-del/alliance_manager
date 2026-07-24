import 'package:flutter/material.dart';

import '../../../shared/models/member_model.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, this.onTap});

  final MemberModel member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AMCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.playerName, style: AMTextStyles.title),
              const SizedBox(height: AMSpacing.sm),

              Text(member.amId, style: AMTextStyles.body),
              const SizedBox(height: AMSpacing.sm),

              Text(
                'Rank: ${member.rank.name.toUpperCase()}',
                style: AMTextStyles.body,
              ),

              Text(
                'Castle Level: ${member.castleLevel}',
                style: AMTextStyles.body,
              ),

              Text(
                'Frontline: ${member.frontlineTroop.name}',
                style: AMTextStyles.body,
              ),

              Text(
                'Backline: ${member.backlineTroop.name}',
                style: AMTextStyles.body,
              ),

              Text(
                'Progress: ${member.overallProgress.toStringAsFixed(1)}%',
                style: AMTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
