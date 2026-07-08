import 'beast_progress_model.dart';
import 'beast_skin_model.dart';
import 'beast_skill_model.dart';
import 'beast_talent_model.dart';
import 'beast_type.dart';

class BeastModel {
  const BeastModel({
    required this.type,
    required this.level,
    required this.progress,
    required this.skills,
    required this.talents,
    required this.skins,
  });

  final BeastType type;

  /// Current beast level.
  final int level;

  /// Progress summary.
  final BeastProgressModel progress;

  /// Skills (shared between all beasts).
  final List<BeastSkillModel> skills;

  /// Beast-specific talent tree.
  final List<BeastTalentModel> talents;

  /// All six skins.
  final List<BeastSkinModel> skins;
}