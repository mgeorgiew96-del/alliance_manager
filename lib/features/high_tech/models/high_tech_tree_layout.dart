import 'dart:ui';

class HighTechTreeNodePosition {
  const HighTechTreeNodePosition({required this.nodeId, required this.center});

  final String nodeId;
  final Offset center;
}

class HighTechTreeConnection {
  const HighTechTreeConnection({
    required this.fromNodeId,
    required this.toNodeId,
  });

  final String fromNodeId;
  final String toNodeId;
}

class HighTechTreeLayout {
  const HighTechTreeLayout({
    required this.canvasSize,
    required this.nodes,
    required this.connections,
  });

  final Size canvasSize;
  final List<HighTechTreeNodePosition> nodes;
  final List<HighTechTreeConnection> connections;

  Offset centerFor(String nodeId) {
    for (final node in nodes) {
      if (node.nodeId == nodeId) {
        return node.center;
      }
    }

    throw StateError('No High Tech tree position found for node: $nodeId');
  }
}

const double highTechNodeWidth = 142;
const double highTechNodeHeight = 126;

const HighTechTreeLayout highTechTreeLayout = HighTechTreeLayout(
  canvasSize: Size(900, 3640),
  nodes: [
    HighTechTreeNodePosition(nodeId: 'manage_food_1', center: Offset(285, 100)),
    HighTechTreeNodePosition(nodeId: 'manage_wood_1', center: Offset(615, 100)),
    HighTechTreeNodePosition(
      nodeId: 'manage_stone_1',
      center: Offset(285, 290),
    ),
    HighTechTreeNodePosition(nodeId: 'manage_iron_1', center: Offset(615, 290)),
    HighTechTreeNodePosition(
      nodeId: 'superior_leadership_1',
      center: Offset(450, 480),
    ),
    HighTechTreeNodePosition(
      nodeId: 'melee_attack_1',
      center: Offset(285, 670),
    ),
    HighTechTreeNodePosition(
      nodeId: 'ranged_attack_1',
      center: Offset(615, 670),
    ),
    HighTechTreeNodePosition(nodeId: 'melee_hp_1', center: Offset(285, 860)),
    HighTechTreeNodePosition(nodeId: 'ranged_hp_1', center: Offset(615, 860)),
    HighTechTreeNodePosition(
      nodeId: 'superior_angel_attack_1',
      center: Offset(450, 1050),
    ),
    HighTechTreeNodePosition(
      nodeId: 'superior_angel_hp_1',
      center: Offset(450, 1240),
    ),
    HighTechTreeNodePosition(
      nodeId: 'elite_blade_1',
      center: Offset(285, 1430),
    ),
    HighTechTreeNodePosition(
      nodeId: 'invasion_blade_1',
      center: Offset(615, 1430),
    ),
    HighTechTreeNodePosition(
      nodeId: 'elite_shield_1',
      center: Offset(285, 1620),
    ),
    HighTechTreeNodePosition(
      nodeId: 'invasion_shield_1',
      center: Offset(615, 1620),
    ),
    HighTechTreeNodePosition(
      nodeId: 'rally_decree_1',
      center: Offset(450, 1810),
    ),
    HighTechTreeNodePosition(
      nodeId: 'manage_food_2',
      center: Offset(285, 2000),
    ),
    HighTechTreeNodePosition(
      nodeId: 'manage_wood_2',
      center: Offset(615, 2000),
    ),
    HighTechTreeNodePosition(
      nodeId: 'manage_stone_2',
      center: Offset(285, 2190),
    ),
    HighTechTreeNodePosition(
      nodeId: 'manage_iron_2',
      center: Offset(615, 2190),
    ),
    HighTechTreeNodePosition(
      nodeId: 'superior_leadership_2',
      center: Offset(450, 2380),
    ),
    HighTechTreeNodePosition(
      nodeId: 'melee_attack_2',
      center: Offset(285, 2570),
    ),
    HighTechTreeNodePosition(
      nodeId: 'ranged_attack_2',
      center: Offset(615, 2570),
    ),
    HighTechTreeNodePosition(nodeId: 'melee_hp_2', center: Offset(285, 2760)),
    HighTechTreeNodePosition(nodeId: 'ranged_hp_2', center: Offset(615, 2760)),
    HighTechTreeNodePosition(
      nodeId: 'superior_angel_attack_2',
      center: Offset(450, 2950),
    ),
    HighTechTreeNodePosition(
      nodeId: 'superior_angel_hp_2',
      center: Offset(450, 3140),
    ),

    // The four final Version II nodes sit on an extended lower branch.
    HighTechTreeNodePosition(
      nodeId: 'elite_blade_2',
      center: Offset(115, 3330),
    ),
    HighTechTreeNodePosition(
      nodeId: 'invasion_blade_2',
      center: Offset(785, 3330),
    ),
    HighTechTreeNodePosition(
      nodeId: 'elite_shield_2',
      center: Offset(115, 3520),
    ),
    HighTechTreeNodePosition(
      nodeId: 'invasion_shield_2',
      center: Offset(785, 3520),
    ),
  ],
  connections: [
    HighTechTreeConnection(
      fromNodeId: 'manage_food_1',
      toNodeId: 'manage_stone_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_wood_1',
      toNodeId: 'manage_iron_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_stone_1',
      toNodeId: 'superior_leadership_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_iron_1',
      toNodeId: 'superior_leadership_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_leadership_1',
      toNodeId: 'melee_attack_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_leadership_1',
      toNodeId: 'ranged_attack_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'melee_attack_1',
      toNodeId: 'melee_hp_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'ranged_attack_1',
      toNodeId: 'ranged_hp_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'melee_hp_1',
      toNodeId: 'superior_angel_attack_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'ranged_hp_1',
      toNodeId: 'superior_angel_attack_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_attack_1',
      toNodeId: 'superior_angel_hp_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_hp_1',
      toNodeId: 'elite_blade_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_hp_1',
      toNodeId: 'invasion_blade_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'elite_blade_1',
      toNodeId: 'elite_shield_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'invasion_blade_1',
      toNodeId: 'invasion_shield_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'elite_shield_1',
      toNodeId: 'rally_decree_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'invasion_shield_1',
      toNodeId: 'rally_decree_1',
    ),
    HighTechTreeConnection(
      fromNodeId: 'rally_decree_1',
      toNodeId: 'manage_food_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'rally_decree_1',
      toNodeId: 'manage_wood_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_food_2',
      toNodeId: 'manage_stone_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_wood_2',
      toNodeId: 'manage_iron_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_stone_2',
      toNodeId: 'superior_leadership_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'manage_iron_2',
      toNodeId: 'superior_leadership_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_leadership_2',
      toNodeId: 'melee_attack_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_leadership_2',
      toNodeId: 'ranged_attack_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'melee_attack_2',
      toNodeId: 'melee_hp_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'ranged_attack_2',
      toNodeId: 'ranged_hp_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'melee_hp_2',
      toNodeId: 'superior_angel_attack_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'ranged_hp_2',
      toNodeId: 'superior_angel_attack_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_attack_2',
      toNodeId: 'superior_angel_hp_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_hp_2',
      toNodeId: 'elite_blade_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'superior_angel_hp_2',
      toNodeId: 'invasion_blade_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'elite_blade_2',
      toNodeId: 'elite_shield_2',
    ),
    HighTechTreeConnection(
      fromNodeId: 'invasion_blade_2',
      toNodeId: 'invasion_shield_2',
    ),
  ],
);
