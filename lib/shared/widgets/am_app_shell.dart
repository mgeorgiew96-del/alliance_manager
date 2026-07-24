import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/am_navigation_destination.dart';
import '../navigation/am_navigation_group.dart';
import '../navigation/am_navigation_subgroup.dart';
import '../navigation/am_navigation_tile.dart';
import '../permissions/admin_permissions.dart';
import '../services/service_locator.dart';
import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';

class AMAppShell extends StatelessWidget {
  const AMAppShell({super.key, required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  static const double _desktopBreakpoint = 900;
  static const double _panelWidth = 300;

  @override
  Widget build(BuildContext context) {
    final member = sessionService.member;

    final canAccessAdministration =
        member != null && isAllianceAdministrator(member.rank);

    final navigationData = _NavigationData(
      memberAmId: member?.amId,
      canAccessAdministration: canAccessAdministration,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final useDesktopNavigation = constraints.maxWidth >= _desktopBreakpoint;

        if (useDesktopNavigation) {
          return Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: _panelWidth,
                  child: _NavigationPanel(
                    navigationData: navigationData,
                    currentPath: currentPath,
                    playerName: member?.playerName,
                    amId: member?.amId,
                    onDestinationSelected: (destination) {
                      _openDestination(
                        context: context,
                        destination: destination,
                      );
                    },
                    onSignOut: () {
                      context.go('/login');
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_pageTitle(currentPath)),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  tooltip: 'Open menu',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              },
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: _NavigationPanel(
                navigationData: navigationData,
                currentPath: currentPath,
                playerName: member?.playerName,
                amId: member?.amId,
                onDestinationSelected: (destination) {
                  if (destination.isAvailable) {
                    Navigator.of(context).pop();
                  }

                  _openDestination(context: context, destination: destination);
                },
                onSignOut: () {
                  Navigator.of(context).pop();
                  context.go('/login');
                },
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }

  void _openDestination({
    required BuildContext context,
    required AMNavigationDestination destination,
  }) {
    if (!destination.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${destination.title} is coming soon.')),
      );

      return;
    }

    context.go(destination.route);
  }

  String _pageTitle(String path) {
    if (path == '/command-room' || path == '/dashboard') {
      return 'Command Room';
    }

    if (path == '/members') {
      return 'Alliance Hall';
    }

    if (path.contains('/beast')) {
      return 'My Castle • Beast';
    }

    if (path.contains('/equipment')) {
      return 'My Castle • Equipment';
    }

    if (path.contains('/artifacts')) {
      return 'My Castle • Artifacts';
    }

    if (path.contains('/colossus')) {
      return 'My Castle • Colossus';
    }

    if (path.contains('/mystic')) {
      return 'My Castle • Mystic';
    }

    if (path.contains('/high-tech')) {
      return 'My Castle • High Tech';
    }

    if (path.contains('/totem')) {
      return 'My Castle • Totem';
    }

    if (path.contains('/titan')) {
      return 'My Castle • Titan';
    }

    if (path.contains('/decorations')) {
      return 'My Castle • Decorations';
    }

    if (path.contains('/statistics')) {
      return 'My Castle • Statistics';
    }

    if (path.startsWith('/member/')) {
      return 'My Castle';
    }

    if (path.startsWith('/war-room')) {
      return 'War Room';
    }

    if (path.startsWith('/hall-of-heroes')) {
      return 'Hall of Heroes';
    }

    if (path.startsWith('/battle-academy')) {
      return 'Battle Academy';
    }

    if (path.startsWith('/war-chronicle')) {
      return 'War Chronicle';
    }

    if (path.startsWith('/battlefield-glory')) {
      return 'Battlefield Glory';
    }

    if (path.startsWith('/admin') || path.startsWith('/royal-office')) {
      return 'Royal Office';
    }

    return 'Alliance Manager';
  }
}

class _NavigationPanel extends StatefulWidget {
  const _NavigationPanel({
    required this.navigationData,
    required this.currentPath,
    required this.playerName,
    required this.amId,
    required this.onDestinationSelected,
    required this.onSignOut,
  });

  final _NavigationData navigationData;
  final String currentPath;
  final String? playerName;
  final String? amId;

  final ValueChanged<AMNavigationDestination> onDestinationSelected;

  final VoidCallback onSignOut;

  @override
  State<_NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<_NavigationPanel> {
  late final Set<String> _expandedSections;
  late final Set<String> _expandedSubgroups;

  @override
  void initState() {
    super.initState();

    _expandedSections = <String>{};
    _expandedSubgroups = <String>{};

    _expandForCurrentPath(widget.currentPath);
  }

  @override
  void didUpdateWidget(covariant _NavigationPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPath != widget.currentPath) {
      _expandForCurrentPath(widget.currentPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.navigationData;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AMSpacing.sm,
                vertical: AMSpacing.md,
              ),
              children: [
                AMNavigationTile(
                  destination: data.commandRoom,
                  isSelected: _isDestinationSelected(data.commandRoom),
                  onTap: () {
                    widget.onDestinationSelected(data.commandRoom);
                  },
                ),
                const SizedBox(height: AMSpacing.xs),
                AMNavigationTile(
                  destination: data.allianceHall,
                  isSelected: _isDestinationSelected(data.allianceHall),
                  onTap: () {
                    widget.onDestinationSelected(data.allianceHall);
                  },
                ),
                const SizedBox(height: AMSpacing.xs),
                _buildMyCastleGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildWarRoomGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildHallOfHeroesGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildBattleAcademyGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildWarChronicleGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildBattlefieldGloryGroup(),
                const SizedBox(height: AMSpacing.xs),
                _buildRoyalOfficeGroup(),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildAccountSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AMSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ALLIANCE MANAGER', style: AMTextStyles.title),
          const SizedBox(height: AMSpacing.xs),
          Text('APX • Realm 1360', style: AMTextStyles.muted),
        ],
      ),
    );
  }

  Widget _buildMyCastleGroup() {
    return AMNavigationGroup(
      title: 'My Castle',
      icon: Icons.castle_outlined,
      destinations: widget.navigationData.castleDestinations,
      isExpanded: _isSectionExpanded('my-castle'),
      isSelected: _isCastlePath(widget.currentPath),
      onExpansionChanged: () {
        _toggleSection('my-castle');
      },
      onDestinationSelected: widget.onDestinationSelected,
      isDestinationSelected: _isDestinationSelected,
    );
  }

  Widget _buildWarRoomGroup() {
    return AMNavigationGroup(
      title: 'War Room',
      icon: Icons.sports_martial_arts,
      destinations: widget.navigationData.warRoomDestinations,
      isExpanded: _isSectionExpanded('war-room'),
      isSelected: widget.currentPath.startsWith('/war-room'),
      onExpansionChanged: () {
        _toggleSection('war-room');
      },
      onDestinationSelected: widget.onDestinationSelected,
      isDestinationSelected: _isDestinationSelected,
    );
  }

  Widget _buildHallOfHeroesGroup() {
    final data = widget.navigationData;

    return _NestedNavigationSection(
      title: 'Hall of Heroes',
      icon: Icons.emoji_events_outlined,
      isExpanded: _isSectionExpanded('hall-of-heroes'),
      isSelected: widget.currentPath.startsWith('/hall-of-heroes'),
      onExpansionChanged: () {
        _toggleSection('hall-of-heroes');
      },
      children: [
        AMNavigationSubgroup(
          title: 'Rankings',
          icon: Icons.leaderboard_outlined,
          destinations: data.rankingDestinations,
          isExpanded: _isSubgroupExpanded('hall-rankings'),
          isSelected: _isAnyDestinationSelected(data.rankingDestinations),
          onExpansionChanged: () {
            _toggleSubgroup('hall-rankings');
          },
          onDestinationSelected: widget.onDestinationSelected,
          isDestinationSelected: _isDestinationSelected,
        ),
        const SizedBox(height: AMSpacing.xs),
        AMNavigationSubgroup(
          title: 'Reports',
          icon: Icons.assessment_outlined,
          destinations: data.reportDestinations,
          isExpanded: _isSubgroupExpanded('hall-reports'),
          isSelected: _isAnyDestinationSelected(data.reportDestinations),
          onExpansionChanged: () {
            _toggleSubgroup('hall-reports');
          },
          onDestinationSelected: widget.onDestinationSelected,
          isDestinationSelected: _isDestinationSelected,
        ),
      ],
    );
  }

  Widget _buildBattleAcademyGroup() {
    return AMNavigationGroup(
      title: 'Battle Academy',
      icon: Icons.menu_book_outlined,
      destinations: widget.navigationData.academyDestinations,
      isExpanded: _isSectionExpanded('battle-academy'),
      isSelected: widget.currentPath.startsWith('/battle-academy'),
      onExpansionChanged: () {
        _toggleSection('battle-academy');
      },
      onDestinationSelected: widget.onDestinationSelected,
      isDestinationSelected: _isDestinationSelected,
    );
  }

  Widget _buildWarChronicleGroup() {
    return AMNavigationGroup(
      title: 'War Chronicle',
      icon: Icons.notifications_outlined,
      destinations: widget.navigationData.notificationDestinations,
      isExpanded: _isSectionExpanded('war-chronicle'),
      isSelected: widget.currentPath.startsWith('/war-chronicle'),
      onExpansionChanged: () {
        _toggleSection('war-chronicle');
      },
      onDestinationSelected: widget.onDestinationSelected,
      isDestinationSelected: _isDestinationSelected,
    );
  }

  Widget _buildBattlefieldGloryGroup() {
    return AMNavigationGroup(
      title: 'Battlefield Glory',
      icon: Icons.military_tech_outlined,
      destinations: widget.navigationData.battlefieldGloryDestinations,
      isExpanded: _isSectionExpanded('battlefield-glory'),
      isSelected: widget.currentPath.startsWith('/battlefield-glory'),
      onExpansionChanged: () {
        _toggleSection('battlefield-glory');
      },
      onDestinationSelected: widget.onDestinationSelected,
      isDestinationSelected: _isDestinationSelected,
    );
  }

  Widget _buildRoyalOfficeGroup() {
    final data = widget.navigationData;

    return _NestedNavigationSection(
      title: 'Royal Office',
      icon: Icons.settings_outlined,
      isExpanded: _isSectionExpanded('royal-office'),
      isSelected:
          widget.currentPath.startsWith('/royal-office') ||
          widget.currentPath.startsWith('/admin'),
      onExpansionChanged: () {
        _toggleSection('royal-office');
      },
      children: [
        for (
          var index = 0;
          index < data.royalOfficeDestinations.length;
          index++
        ) ...[
          AMNavigationTile(
            destination: data.royalOfficeDestinations[index],
            isSelected: _isDestinationSelected(
              data.royalOfficeDestinations[index],
            ),
            isCompact: true,
            onTap: () {
              widget.onDestinationSelected(data.royalOfficeDestinations[index]);
            },
          ),
          if (index < data.royalOfficeDestinations.length - 1)
            const SizedBox(height: AMSpacing.xs),
        ],
        const SizedBox(height: AMSpacing.xs),
        AMNavigationSubgroup(
          title: 'Administration',
          icon: Icons.admin_panel_settings_outlined,
          destinations: data.administrationDestinations,
          isExpanded: _isSubgroupExpanded('royal-administration'),
          isSelected: _isAnyDestinationSelected(
            data.administrationDestinations,
          ),
          onExpansionChanged: () {
            _toggleSubgroup('royal-administration');
          },
          onDestinationSelected: widget.onDestinationSelected,
          isDestinationSelected: _isDestinationSelected,
        ),
        if (data.controlRoomDestinations.isNotEmpty) ...[
          const SizedBox(height: AMSpacing.xs),
          AMNavigationSubgroup(
            title: 'Control Room',
            icon: Icons.security_outlined,
            destinations: data.controlRoomDestinations,
            isExpanded: _isSubgroupExpanded('royal-control-room'),
            isSelected: _isAnyDestinationSelected(data.controlRoomDestinations),
            onExpansionChanged: () {
              _toggleSubgroup('royal-control-room');
            },
            onDestinationSelected: widget.onDestinationSelected,
            isDestinationSelected: _isDestinationSelected,
          ),
        ],
      ],
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.playerName != null) ...[
            Text(
              widget.playerName!,
              style: AMTextStyles.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.amId != null) ...[
              const SizedBox(height: AMSpacing.xs),
              Text(widget.amId!, style: AMTextStyles.muted),
            ],
            const SizedBox(height: AMSpacing.md),
          ],
          OutlinedButton.icon(
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout),
            label: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }

  bool _isDestinationSelected(AMNavigationDestination destination) {
    final path = widget.currentPath;

    switch (destination.title) {
      case 'Command Room':
        return path == '/command-room' || path == '/dashboard';

      case 'Alliance Hall':
        return path == '/members';

      case 'Overview':
        return _isCastleOverviewPath(path);

      case 'Beast':
        return path.contains('/beast') && !path.startsWith('/admin');

      case 'Equipment':
        return path.contains('/equipment');

      case 'Artifacts':
        return path.contains('/artifacts');

      case 'Colossus':
        return path.contains('/colossus');

      case 'Mystic':
        return path.contains('/mystic');

      case 'High Tech':
        return path.contains('/high-tech');

      case 'Totem':
        return path.contains('/totem');

      case 'Titan':
        return path.contains('/titan');

      case 'Decorations':
        return path.contains('/decorations');

      case 'Statistics':
        return path.contains('/statistics');

      case 'Administration Overview':
        return path == '/admin';

      case 'Beast Priorities':
        return path == '/admin/beast/priorities';

      default:
        return destination.isAvailable && path == destination.route;
    }
  }

  bool _isAnyDestinationSelected(List<AMNavigationDestination> destinations) {
    return destinations.any(_isDestinationSelected);
  }

  bool _isSectionExpanded(String sectionKey) {
    return _expandedSections.contains(sectionKey);
  }

  bool _isSubgroupExpanded(String subgroupKey) {
    return _expandedSubgroups.contains(subgroupKey);
  }

  void _toggleSection(String sectionKey) {
    setState(() {
      if (_expandedSections.contains(sectionKey)) {
        _expandedSections.remove(sectionKey);
      } else {
        _expandedSections.add(sectionKey);
      }
    });
  }

  void _toggleSubgroup(String subgroupKey) {
    setState(() {
      if (_expandedSubgroups.contains(subgroupKey)) {
        _expandedSubgroups.remove(subgroupKey);
      } else {
        _expandedSubgroups.add(subgroupKey);
      }
    });
  }

  void _expandForCurrentPath(String path) {
    if (_isCastlePath(path)) {
      _expandedSections.add('my-castle');
    }

    if (path.startsWith('/war-room')) {
      _expandedSections.add('war-room');
    }

    if (path.startsWith('/hall-of-heroes')) {
      _expandedSections.add('hall-of-heroes');

      if (path.contains('/rankings')) {
        _expandedSubgroups.add('hall-rankings');
      }

      if (path.contains('/reports')) {
        _expandedSubgroups.add('hall-reports');
      }
    }

    if (path.startsWith('/battle-academy')) {
      _expandedSections.add('battle-academy');
    }

    if (path.startsWith('/war-chronicle')) {
      _expandedSections.add('war-chronicle');
    }

    if (path.startsWith('/battlefield-glory')) {
      _expandedSections.add('battlefield-glory');
    }

    if (path.startsWith('/royal-office') || path.startsWith('/admin')) {
      _expandedSections.add('royal-office');
    }

    if (path.startsWith('/admin')) {
      _expandedSubgroups.add('royal-administration');
      _expandedSubgroups.add('royal-control-room');
    }
  }

  bool _isCastlePath(String path) {
    return path.startsWith('/member/') || path.startsWith('/my-castle/');
  }

  bool _isCastleOverviewPath(String path) {
    if (!path.startsWith('/member/')) {
      return false;
    }

    final segments = Uri.parse(path).pathSegments;

    return segments.length == 2;
  }
}

class _NestedNavigationSection extends StatelessWidget {
  const _NestedNavigationSection({
    required this.title,
    required this.icon,
    required this.isExpanded,
    required this.isSelected,
    required this.onExpansionChanged,
    required this.children,
  });

  final String title;
  final IconData icon;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onExpansionChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onExpansionChanged,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AMSpacing.md,
                vertical: AMSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(icon, color: isSelected ? colorScheme.primary : null),
                  const SizedBox(width: AMSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AMTextStyles.body,
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              top: AMSpacing.xs,
              left: AMSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

class _NavigationData {
  _NavigationData({
    required String? memberAmId,
    required bool canAccessAdministration,
  }) : commandRoom = const AMNavigationDestination(
         title: 'Command Room',
         icon: Icons.dashboard_outlined,
         route: '/command-room',
       ),
       allianceHall = const AMNavigationDestination(
         title: 'Alliance Hall',
         icon: Icons.groups_outlined,
         route: '/members',
       ),
       castleDestinations = _buildCastleDestinations(memberAmId),
       warRoomDestinations = _buildWarRoomDestinations(canAccessAdministration),
       rankingDestinations = _buildRankingDestinations(),
       reportDestinations = _buildReportDestinations(),
       academyDestinations = _buildAcademyDestinations(),
       notificationDestinations = _buildNotificationDestinations(),
       battlefieldGloryDestinations = _buildBattlefieldGloryDestinations(),
       royalOfficeDestinations = _buildRoyalOfficeDestinations(),
       administrationDestinations = _buildAdministrationDestinations(
         canAccessAdministration,
       ),
       controlRoomDestinations = _buildControlRoomDestinations(
         canAccessAdministration,
       );

  final AMNavigationDestination commandRoom;
  final AMNavigationDestination allianceHall;

  final List<AMNavigationDestination> castleDestinations;

  final List<AMNavigationDestination> warRoomDestinations;

  final List<AMNavigationDestination> rankingDestinations;

  final List<AMNavigationDestination> reportDestinations;

  final List<AMNavigationDestination> academyDestinations;

  final List<AMNavigationDestination> notificationDestinations;

  final List<AMNavigationDestination> battlefieldGloryDestinations;

  final List<AMNavigationDestination> royalOfficeDestinations;

  final List<AMNavigationDestination> administrationDestinations;

  final List<AMNavigationDestination> controlRoomDestinations;

  static List<AMNavigationDestination> _buildCastleDestinations(
    String? memberAmId,
  ) {
    final hasMember = memberAmId != null;

    final overviewRoute = hasMember ? '/member/$memberAmId' : '/command-room';

    return [
      AMNavigationDestination(
        title: 'Overview',
        icon: Icons.home_outlined,
        route: overviewRoute,
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'Beast',
        icon: Icons.pets_outlined,
        route: hasMember ? '/member/$memberAmId/beast' : '/command-room',
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'Equipment',
        icon: Icons.shield_outlined,
        route: hasMember ? '/member/$memberAmId/equipment' : '/command-room',
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'Artifacts',
        icon: Icons.diamond_outlined,
        route: hasMember ? '/member/$memberAmId/artifacts' : '/command-room',
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'Colossus',
        icon: Icons.smart_toy_outlined,
        route: hasMember ? '/member/$memberAmId/colossus' : '/command-room',
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'Mystic',
        icon: Icons.auto_awesome_outlined,
        route: hasMember ? '/member/$memberAmId/mystic' : '/command-room',
        isAvailable: hasMember,
      ),
      AMNavigationDestination(
        title: 'High Tech',
        icon: Icons.account_tree_outlined,
        route: hasMember
            ? '/member/$memberAmId/high-tech'
            : '/command-room',
        isAvailable: hasMember,
      ),
      const AMNavigationDestination(
        title: 'Totem',
        icon: Icons.flare_outlined,
        route: '/my-castle/totem',
        isAvailable: false,
      ),
      const AMNavigationDestination(
        title: 'Titan',
        icon: Icons.bolt_outlined,
        route: '/my-castle/titan',
        isAvailable: false,
      ),
      const AMNavigationDestination(
        title: 'Decorations',
        icon: Icons.park_outlined,
        route: '/my-castle/decorations',
        isAvailable: false,
      ),
      const AMNavigationDestination(
        title: 'Statistics',
        icon: Icons.bar_chart_outlined,
        route: '/my-castle/statistics',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildWarRoomDestinations(
    bool canAccessAdministration,
  ) {
    return [
      const AMNavigationDestination(
        title: 'Military Campaigns',
        icon: Icons.flag_outlined,
        route: '/war-room/campaigns',
        isAvailable: false,
      ),
      const AMNavigationDestination(
        title: 'War Schedule',
        icon: Icons.calendar_month_outlined,
        route: '/war-room/schedule',
        isAvailable: false,
      ),
      const AMNavigationDestination(
        title: 'Event History',
        icon: Icons.history_outlined,
        route: '/war-room/history',
        isAvailable: false,
      ),
      if (canAccessAdministration)
        const AMNavigationDestination(
          title: 'Create Event',
          icon: Icons.add_circle_outline,
          route: '/war-room/create-event',
          isAvailable: false,
          isAdministration: true,
        ),
    ];
  }

  static List<AMNavigationDestination> _buildRankingDestinations() {
    return const [
      AMNavigationDestination(
        title: 'Overall Progress',
        icon: Icons.workspace_premium_outlined,
        route: '/hall-of-heroes/rankings/overall-progress',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Castle Rankings',
        icon: Icons.castle_outlined,
        route: '/hall-of-heroes/rankings/castle',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Event Rankings',
        icon: Icons.event_available_outlined,
        route: '/hall-of-heroes/rankings/events',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Activity Rankings',
        icon: Icons.local_fire_department_outlined,
        route: '/hall-of-heroes/rankings/activity',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Achievements • V2',
        icon: Icons.military_tech_outlined,
        route: '/hall-of-heroes/rankings/achievements',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildReportDestinations() {
    return const [
      AMNavigationDestination(
        title: 'Progress Report',
        icon: Icons.trending_up_outlined,
        route: '/hall-of-heroes/reports/progress',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Activity Report',
        icon: Icons.insights_outlined,
        route: '/hall-of-heroes/reports/activity',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Event Report',
        icon: Icons.event_note_outlined,
        route: '/hall-of-heroes/reports/events',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildAcademyDestinations() {
    return const [
      AMNavigationDestination(
        title: 'Castle Guide',
        icon: Icons.castle_outlined,
        route: '/battle-academy/castle-guide',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Event Guide',
        icon: Icons.event_outlined,
        route: '/battle-academy/event-guide',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Tips and Tricks',
        icon: Icons.lightbulb_outline,
        route: '/battle-academy/tips',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Archives',
        icon: Icons.inventory_2_outlined,
        route: '/battle-academy/archives',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildNotificationDestinations() {
    return const [
      AMNavigationDestination(
        title: 'Alliance',
        icon: Icons.groups_outlined,
        route: '/war-chronicle/alliance',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Events',
        icon: Icons.event_outlined,
        route: '/war-chronicle/events',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'System',
        icon: Icons.settings_suggest_outlined,
        route: '/war-chronicle/system',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildBattlefieldGloryDestinations() {
    return const [
      AMNavigationDestination(
        title: 'Alliance Performance',
        icon: Icons.timeline_outlined,
        route: '/battlefield-glory/alliance-performance',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildRoyalOfficeDestinations() {
    return const [
      AMNavigationDestination(
        title: 'General',
        icon: Icons.tune_outlined,
        route: '/royal-office/general',
        isAvailable: false,
      ),
      AMNavigationDestination(
        title: 'Account',
        icon: Icons.manage_accounts_outlined,
        route: '/royal-office/account',
        isAvailable: false,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildAdministrationDestinations(
    bool canAccessAdministration,
  ) {
    return [
      AMNavigationDestination(
        title: 'Administration Overview',
        icon: Icons.admin_panel_settings_outlined,
        route: '/admin',
        isAvailable: canAccessAdministration,
        isAdministration: true,
      ),
      const AMNavigationDestination(
        title: 'Alliance Settings',
        icon: Icons.settings_outlined,
        route: '/royal-office/administration/alliance-settings',
        isAvailable: false,
        isAdministration: true,
      ),
      const AMNavigationDestination(
        title: 'Permissions',
        icon: Icons.lock_person_outlined,
        route: '/royal-office/administration/permissions',
        isAvailable: false,
        isAdministration: true,
      ),
    ];
  }

  static List<AMNavigationDestination> _buildControlRoomDestinations(
    bool canAccessAdministration,
  ) {
    if (!canAccessAdministration) {
      return const [];
    }

    return const [
      AMNavigationDestination(
        title: 'Create Account / Temp Password',
        icon: Icons.person_add_alt_outlined,
        route: '/admin/accounts',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Member Approval',
        icon: Icons.how_to_reg_outlined,
        route: '/admin/member-approval',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Member Management',
        icon: Icons.manage_accounts_outlined,
        route: '/admin/member-management',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Event Management',
        icon: Icons.event_note_outlined,
        route: '/admin/event-management',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Priority Settings',
        icon: Icons.low_priority_outlined,
        route: '/admin/priorities',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Progress Configuration',
        icon: Icons.tune_outlined,
        route: '/admin/progress-configuration',
        isAvailable: false,
        isAdministration: true,
      ),
      AMNavigationDestination(
        title: 'Beast Priorities',
        icon: Icons.pets_outlined,
        route: '/admin/beast/priorities',
        isAvailable: true,
        isAdministration: true,
      ),
    ];
  }
}
