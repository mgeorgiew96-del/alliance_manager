import '../enums/member_rank.dart';
import '../enums/member_status.dart';
import '../enums/troop_type.dart';
import '../models/member_model.dart';

final mockMembers = [
  MemberModel(
  amId: 'AM-1360-001',
  playerName: 'aHTu',
  realmId: '1360',
  currentAllianceId: '1360_APX',
  rank: MemberRank.r4,
  status: MemberStatus.active,
  castleLevel: 42,
  frontlineTroop: TroopType.cavalry,
  backlineTroop: TroopType.mage,
  overallProgress: 0,
),
];