import '../models/member_model.dart';

abstract class MemberRepository {
  Future<MemberModel?> getByAmId(String amId);

  Future<void> create(MemberModel member);

  Future<void> update(MemberModel member);

  Future<void> delete(String amId);

  Future<List<MemberModel>> getAllianceMembers(String allianceId);
}