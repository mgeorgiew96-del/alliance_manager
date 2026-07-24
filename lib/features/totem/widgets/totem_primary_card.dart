import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../models/totem_data.dart';
import '../models/totem_definition.dart';
import 'totem_selected_card.dart';

class TotemPrimaryCard extends StatelessWidget {
  const TotemPrimaryCard({
    super.key,
    required this.definition,
    required this.data,
    required this.onLevelChanged,
    required this.onSkillLevelChanged,
  });

  final TotemDefinition definition;
  final TotemData data;
  final ValueChanged<int> onLevelChanged;
  final ValueChanged<int> onSkillLevelChanged;

  @override
  Widget build(BuildContext context) {
    return TotemSelectedCard(
      roleLabel: 'PRIMARY TOTEM',
      roleIcon: Icons.workspace_premium_rounded,
      accentColor: AMColors.gold,
      definition: definition,
      data: data,
      artworkSize: 172,
      onLevelChanged: onLevelChanged,
      onSkillLevelChanged: onSkillLevelChanged,
    );
  }
}
