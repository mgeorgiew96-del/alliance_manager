import '../models/account_model.dart';
import '../models/member_model.dart';

abstract class AuthService {
  Future<(AccountModel, MemberModel)?> login({
    required String amId,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();
}
