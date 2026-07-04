import '../models/account_model.dart';
import '../repositories/account_repository.dart';

class MockAccountRepository implements AccountRepository {
  final List<AccountModel> _accounts = [
   const AccountModel(
  amId: 'AM-1360-001',
  passwordHash: '1234',
  passwordSalt: 'mock',
  mustChangePassword: false,
  failedAttempts: 0,
  accountStatus: 'active',
),
  ];

  @override
  Future<AccountModel?> getByAmId(String amId) async {
    try {
      return _accounts.firstWhere((account) => account.amId == amId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> create(AccountModel account) async {}

  @override
  Future<void> update(AccountModel account) async {}

  @override
  Future<void> delete(String amId) async {}

  @override
  Future<void> incrementFailedAttempts(String amId) async {}

  @override
  Future<void> resetFailedAttempts(String amId) async {}
}