import '../enums/member_rank.dart';
import '../enums/member_status.dart';
import '../enums/troop_type.dart';

class MemberModel {
  const MemberModel({
    required this.amId,
    required this.playerName,
    required this.realmId,
    required this.currentAllianceId,
    required this.rank,
    required this.status,
    required this.castleLevel,
    required this.frontlineTroop,
    required this.backlineTroop,
    required this.overallProgress,
    this.warAndOrderPlayerId,
    this.createdAt,
    this.lastLoginAt,
    this.mustChangePassword = false,
  });

  final String amId;

  final String playerName;

  final String? warAndOrderPlayerId;

  final String realmId;

  final String currentAllianceId;

  final MemberRank rank;

  final MemberStatus status;

  final int castleLevel;

  final TroopType frontlineTroop;

  final TroopType backlineTroop;

  /// Progress from 0.0 to 100.0
  final double overallProgress;

  final DateTime? createdAt;

  final DateTime? lastLoginAt;

  final bool mustChangePassword;

  MemberModel copyWith({
    String? amId,
    String? playerName,
    String? warAndOrderPlayerId,
    String? realmId,
    String? currentAllianceId,
    MemberRank? rank,
    MemberStatus? status,
    int? castleLevel,
    TroopType? frontlineTroop,
    TroopType? backlineTroop,
    double? overallProgress,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? mustChangePassword,
  }) {
    return MemberModel(
      amId: amId ?? this.amId,
      playerName: playerName ?? this.playerName,
      warAndOrderPlayerId: warAndOrderPlayerId ?? this.warAndOrderPlayerId,
      realmId: realmId ?? this.realmId,
      currentAllianceId: currentAllianceId ?? this.currentAllianceId,
      rank: rank ?? this.rank,
      status: status ?? this.status,
      castleLevel: castleLevel ?? this.castleLevel,
      frontlineTroop: frontlineTroop ?? this.frontlineTroop,
      backlineTroop: backlineTroop ?? this.backlineTroop,
      overallProgress: overallProgress ?? this.overallProgress,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
    );
  }
}
