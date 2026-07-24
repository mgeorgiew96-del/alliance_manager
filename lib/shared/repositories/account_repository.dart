import '../models/account_model.dart';

abstract class AccountRepository {
  Future<AccountModel?> getByAmId(String amId);

  Future<void> create(AccountModel account);

  Future<void> update(AccountModel account);

  Future<void> delete(String amId);

  Future<void> incrementFailedAttempts(String amId);

  Future<void> resetFailedAttempts(String amId);
}
