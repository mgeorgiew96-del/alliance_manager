import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../mock/mock_beast_data.dart';
import '../models/beast_model.dart';
import '../models/beast_type.dart';
import '../widgets/beast_overview_card.dart';
import '../widgets/beast_selector.dart';

class BeastScreen extends StatefulWidget {
  const BeastScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  @override
  State<BeastScreen> createState() => _BeastScreenState();
}

class _BeastScreenState extends State<BeastScreen> {
  BeastType _selectedBeast = BeastType.panda;

  BeastModel get currentBeast {
    switch (_selectedBeast) {
      case BeastType.panda:
        return pandaBeast;
      case BeastType.dragon:
        return dragonBeast;
      case BeastType.pegasus:
        return pegasusBeast;
      case BeastType.phoenix:
        return phoenixBeast;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BeastOverviewCard(
            beast: currentBeast,
          ),

          const SizedBox(height: AMSpacing.lg),

          BeastSelector(
            selectedBeast: _selectedBeast,
            onChanged: (beast) {
              setState(() {
                _selectedBeast = beast;
              });
            },
          ),

          const SizedBox(height: AMSpacing.xl),

          AMPrimaryButton(  text: 'SKILLS',  icon: Icons.auto_fix_high,  onPressed: () => context.go('/member/${widget.amId}/beast/skills',
  ),
),

          const SizedBox(height: AMSpacing.md),

          AMPrimaryButton(
            text: 'TALENTS',
             icon: Icons.account_tree,
              onPressed: () => context.go( '/member/${widget.amId}/beast/talents/${_selectedBeast.name}',),
),

          const SizedBox(height: AMSpacing.md),

          AMPrimaryButton(
            text: 'SKINS',
            icon: Icons.palette,
            onPressed: () {},
          ),

          const SizedBox(height: AMSpacing.xl),

          AMPrimaryButton(
            text: 'BACK TO PROFILE',
            icon: Icons.arrow_back,
            onPressed: () => context.go('/member/${widget.amId}'),
          ),
        ],
      ),
    );
  }
}