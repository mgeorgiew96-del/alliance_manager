import '../enums/member_rank.dart';

bool isAllianceAdministrator(MemberRank rank) {
  return rank == MemberRank.r5 || rank == MemberRank.r4;
}
