import '../models/account_model.dart';
import '../models/member_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/member_repository.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

class MockAuthService implements AuthService {
  MockAuthService({
    required this.accountRepository,
    required this.memberRepository,
    SessionService? sessionService,
  }) : _sessionService = sessionService ?? SessionService();

  final AccountRepository accountRepository;
  final MemberRepository memberRepository;
  final SessionService _sessionService;

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

    if (password != account.passwordHash) {
      return null;
    }

    final member = await memberRepository.getByAmId(amId);

    if (member == null) {
      return null;
    }

    _currentAccount = account;
    _currentMember = member;

    _sessionService.startSession(
      account: account,
      member: member,
    );

    return (account, member);
  }

  @override
  Future<void> logout() async {
    _currentAccount = null;
    _currentMember = null;

    _sessionService.clearSession();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentAccount != null && _currentMember != null;
  }
}