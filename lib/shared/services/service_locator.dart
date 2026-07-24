import '../mock/mock_account_repository.dart';
import '../mock/mock_auth_service.dart';
import '../mock/mock_member_repository.dart';
import 'auth_service.dart';
import 'session_service.dart';

final SessionService sessionService = SessionService();

final AuthService authService = MockAuthService(
  accountRepository: MockAccountRepository(),
  memberRepository: MockMemberRepository(),
  sessionService: sessionService,
);
