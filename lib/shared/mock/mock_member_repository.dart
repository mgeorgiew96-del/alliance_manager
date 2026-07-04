import '../models/member_model.dart';
import '../repositories/member_repository.dart';
import 'mock_member_data.dart';

class MockMemberRepository implements MemberRepository {
  @override
  Future<MemberModel?> getByAmId(String amId) async {
    try {
      return mockMembers.firstWhere((member) => member.amId == amId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> create(MemberModel member) async {}

  @override
  Future<void> update(MemberModel member) async {}

  @override
  Future<void> delete(String amId) async {}

  @override
  Future<List<MemberModel>> getAllianceMembers(String allianceId) async {
    return mockMembers
        .where((member) => member.currentAllianceId == allianceId)
        .toList();
  }
}