import '../../features/beast/models/beast_type.dart';
import '../../features/colossus/models/colossus_type.dart';
import '../../features/equipment/models/equipment_slot_type.dart';

abstract final class AMAssets {
  static const String imagesRoot = 'assets/images';

  static const BeastAssetPaths beast = BeastAssetPaths._();
  static const EquipmentAssetPaths equipment = EquipmentAssetPaths._();
  static const ArtifactAssetPaths artifacts = ArtifactAssetPaths._();
  static const ColossusAssetPaths colossus = ColossusAssetPaths._();
  static const CommonAssetPaths common = CommonAssetPaths._();
}

class CommonAssetPaths {
  const CommonAssetPaths._();

  static const String _root = AMAssets.imagesRoot;

  String banner(String bannerId) {
    return '$_root/banners/$bannerId.png';
  }

  String logo(String logoId) {
    return '$_root/logo/$logoId.png';
  }

  String moduleIcon(String moduleId) {
    return '$_root/module_icons/$moduleId.png';
  }
}

class BeastAssetPaths {
  const BeastAssetPaths._();

  static const String _root = '${AMAssets.imagesRoot}/beast';

  String overview(BeastType beastType) {
    return '$_root/overview/${beastType.name}.webp';
  }

  String skill(String skillId) {
    return '$_root/skills/$skillId.png';
  }

  String talent({
    required BeastType beastType,
    required String talentId,
  }) {
    return '$_root/talents/${beastType.name}/$talentId.png';
  }

  String skin({
    required BeastType beastType,
    required String skinId,
  }) {
    return '$_root/skins/${beastType.name}/$skinId.png';
  }
}

class EquipmentAssetPaths {
  const EquipmentAssetPaths._();

  static const String _root = '${AMAssets.imagesRoot}/equipment';

  String slot(EquipmentSlotType slotType) {
    return '$_root/slots/${slotType.name}.png';
  }

  String slotById(String slotId) {
    return '$_root/slots/$slotId.png';
  }

  String jewel(String jewelId) {
    return '$_root/jewels/$jewelId.png';
  }

  String banner() {
    return '$_root/equipment_banner.webp';
  }
}

class ArtifactAssetPaths {
  const ArtifactAssetPaths._();

  static const String _root = '${AMAssets.imagesRoot}/artifacts';

  String artifact(String fileName) {
    return '$_root/artifacts/$fileName';
  }

  String crown(String fileName) {
    return '$_root/crowns/$fileName';
  }
}

class ColossusAssetPaths {
  const ColossusAssetPaths._();

  static const String _root = '${AMAssets.imagesRoot}/colossus';

  String artwork(ColossusType colossusType) {
    return '$_root/artwork/${colossusType.name}.png';
  }

  String skill(String skillId) {
    return '$_root/skills/$skillId.png';
  }

  String specialSkill({
    required ColossusType colossusType,
    required int skillNumber,
  }) {
    return '$_root/special_skills/'
        '${colossusType.name}_skill_$skillNumber.png';
  }
}