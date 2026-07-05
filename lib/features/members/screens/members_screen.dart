import 'package:flutter/material.dart';

import '../../../shared/enums/member_rank.dart';
import '../../../shared/mock/mock_member_data.dart';
import '../../../shared/models/member_model.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_page.dart';
import '../widgets/alliance_summary_card.dart';
import '../widgets/member_card.dart';
import '../widgets/rank_filter_chips.dart';
import 'package:go_router/go_router.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  MemberRank? _selectedRank;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();

    final List<MemberModel> filteredMembers = mockMembers.where((member) {
      final matchesSearch =
          member.playerName.toLowerCase().contains(query) ||
          member.amId.toLowerCase().contains(query);

      final matchesRank =
          _selectedRank == null || member.rank == _selectedRank;

      return matchesSearch && matchesRank;
    }).toList();

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alliance Members',
            style: AMTextStyles.title,
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            '${filteredMembers.length} / 100 members',
            style: AMTextStyles.subtitle,
          ),
          const SizedBox(height: AMSpacing.lg),

          AllianceSummaryCard(members: mockMembers),

          const SizedBox(height: AMSpacing.lg),

          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by name or AM ID...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: AMSpacing.md),

          RankFilterChips(
            selectedRank: _selectedRank,
            onChanged: (rank) {
              setState(() {
                _selectedRank = rank;
              });
            },
          ),

          const SizedBox(height: AMSpacing.lg),

          for (final member in filteredMembers)
            MemberCard(  member: member,  onTap: () {context.go('/member/${member.amId}');},
),
        ],
      ),
    );
  }
}