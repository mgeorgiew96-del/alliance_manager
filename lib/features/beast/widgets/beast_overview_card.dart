import 'package:flutter/material.dart';

import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/game/game_progress_bar.dart';
import '../../../shared/widgets/game/game_section_header.dart';
import '../models/beast_model.dart';

class BeastOverviewCard extends StatelessWidget {
  const BeastOverviewCard({super.key, required this.beast});

  final BeastModel beast;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GameSectionHeader(
            title: beast.type.name.toUpperCase(),
            subtitle: 'Level ${beast.level}',
          ),

          GameProgressBar(
            label: 'Overall Progress',
            progress: beast.progress.overallProgress,
          ),

          const SizedBox(height: 16),

          GameProgressBar(
            label: 'Skills',
            progress: beast.progress.skillsProgress,
          ),

          const SizedBox(height: 12),

          GameProgressBar(
            label: 'Talents',
            progress: beast.progress.talentsProgress,
          ),

          const SizedBox(height: 12),

          GameProgressBar(
            label: 'Skins',
            progress: beast.progress.skinsProgress,
          ),
        ],
      ),
    );
  }
}
