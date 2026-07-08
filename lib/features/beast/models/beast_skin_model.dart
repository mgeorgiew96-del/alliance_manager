import 'beast_skin_type.dart';

class BeastSkinModel {
  const BeastSkinModel({
    required this.type,
    required this.level,
    required this.maxLevel,
  });

  final BeastSkinType type;
  final int level;
  final int maxLevel;
}