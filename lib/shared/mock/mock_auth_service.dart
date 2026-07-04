import '../models/account_model.dart';
import '../models/member_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/member_repository.dart';
import '../services/auth_service.dart';

class MockAuthService implements AuthService {
  MockAuthService({
    required this.accountRepository,
    required this.memberRepository,
  });

  final AccountRepository accountRepository;
  final MemberRepository memberRepository;

  AccountModel? _currentAccount;
  MemberModel? _currentMember;

  @override
  Future<(AccountModel, MemberModel)?> login({
    required String amId,
    required String password,
  }) async {
    final account = await accountRepository.getByAmId(amId);

    if (account == null || !account.isActive) {
      return null;
    }

    // Temporary mock password check.
    // Later this will become a secure password hash check.
    if (password != account.passwordHash) {
      return null;
    }

    final member = await memberRepository.getByAmId(amId);

    if (member == null) {
      return null;
    }

    _currentAccount = account;
    _currentMember = member;

    return (account, member);
  }

  @override
  Future<void> logout() async {
    _currentAccount = null;
    _currentMember = null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentAccount != null && _currentMember != null;
  }
}