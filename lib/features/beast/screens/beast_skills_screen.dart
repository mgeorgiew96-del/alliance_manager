import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../mock/mock_beast_data.dart';
import '../widgets/beast_skill_card.dart';

class BeastSkillsScreen extends StatelessWidget {
  const BeastSkillsScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  @override
  Widget build(BuildContext context) {
    // Temporary - later this will come from the selected beast.
    final beast = pandaBeast;

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final skill in beast.skills)
            BeastSkillCard(
              skill: skill,
              onIncrease: () {},
              onDecrease: () {},
            ),

          const SizedBox(height: AMSpacing.lg),

          AMPrimaryButton(
            text: 'BACK TO BEAST',
            icon: Icons.arrow_back,
            onPressed: () => context.go('/member/$amId/beast'),
          ),
        ],
      ),
    );
  }
}