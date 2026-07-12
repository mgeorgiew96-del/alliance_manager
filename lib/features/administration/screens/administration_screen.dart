import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/widgets/am_page.dart';
import '../widgets/admin_module_card.dart';
import '../widgets/admin_section_header.dart';

class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () {
                  context.go('/dashboard');
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: AMSpacing.sm),
              const Expanded(
                child: AdminSectionHeader(
                  title: 'ADMINISTRATION',
                  description:
                      'Manage alliance progression rules, '
                      'priorities, permissions, and member data.',
                ),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.lg),
          AdminModuleCard(
            title: 'Beast',
            description:
                'Configure Beast category weights, tracked items, '
                'target levels, and priorities.',
            icon: Icons.pets,
            buttonText: 'OPEN BEAST PRIORITIES',
            onPressed: () {
              context.go('/admin/beast/priorities');
            },
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Equipment',
            description:
                'Configure equipment progress rules and item '
                'priorities.',
            icon: Icons.shield,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Artifacts',
            description:
                'Configure tracked artifacts, crowns, stars, and '
                'progress targets.',
            icon: Icons.auto_awesome,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Colossus',
            description:
                'Configure Colossus priorities and troop-dependent '
                'tracking rules.',
            icon: Icons.smart_toy,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Mystic',
            description:
                'Configure frontline, backline, and Angels Mystic '
                'priorities.',
            icon: Icons.blur_on,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'High Tech',
            description:
                'Configure tracked High Tech nodes and priority '
                'targets.',
            icon: Icons.hub,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Totem',
            description:
                'Configure Totem selection, tracked upgrades, and '
                'target levels.',
            icon: Icons.workspace_premium,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Titan',
            description:
                'Configure Titan level, tier, phase, step, and '
                'talent priorities.',
            icon: Icons.whatshot,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Decorations',
            description:
                'Configure Garden, Decoration Sets, Statues, and '
                'Illusion progress rules.',
            icon: Icons.park,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
          const SizedBox(height: AMSpacing.md),
          const AdminModuleCard(
            title: 'Permissions',
            description:
                'Manage alliance permissions and administrative '
                'access.',
            icon: Icons.admin_panel_settings,
            buttonText: 'COMING SOON',
            onPressed: null,
            isComingSoon: true,
          ),
        ],
      ),
    );
  }
}
