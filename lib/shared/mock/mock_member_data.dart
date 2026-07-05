import '../enums/member_rank.dart';
import '../enums/member_status.dart';
import '../enums/troop_type.dart';
import '../models/member_model.dart';

final mockMembers = <MemberModel>[
  const MemberModel(
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
  MemberModel(
    amId: 'AM-1360-002',
    playerName: 'Shadowlight',
    realmId: '1360',
    currentAllianceId: '1360_APX',
    rank: MemberRank.r5,
    status: MemberStatus.active,
    castleLevel: 43,
    frontlineTroop: TroopType.cavalry,
    backlineTroop: TroopType.archer,
    overallProgress: 0,
  ),
  MemberModel(
    amId: 'AM-1360-003',
    playerName: 'Bingo',
    realmId: '1360',
    currentAllianceId: '1360_APX',
    rank: MemberRank.r3,
    status: MemberStatus.active,
    castleLevel: 43,
    frontlineTroop: TroopType.cavalry,
    backlineTroop: TroopType.mage,
    overallProgress: 0,
  ),
  MemberModel(
    amId: 'AM-1360-004',
    playerName: 'Mig Devil',
    realmId: '1360',
    currentAllianceId: '1360_APX',
    rank: MemberRank.r1,
    status: MemberStatus.active,
    castleLevel: 40,
    frontlineTroop: TroopType.infantry,
    backlineTroop: TroopType.mage,
    overallProgress: 0,
  ),
  
];