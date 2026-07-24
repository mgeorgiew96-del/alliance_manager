import '../beast_skin_type.dart';

class BeastSkinDefinition {
  const BeastSkinDefinition({
    required this.type,
    required this.name,
    required this.minLevel,
    required this.maxLevel,
    this.description = '',
  });

  final BeastSkinType type;
  final String name;
  final int minLevel;
  final int maxLevel;
  final String description;
}
