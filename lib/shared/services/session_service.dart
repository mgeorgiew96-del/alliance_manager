import '../models/account_model.dart';
import '../models/member_model.dart';

class SessionService {
  AccountModel? _account;
  MemberModel? _member;

  AccountModel? get account => _account;
  MemberModel? get member => _member;

  bool get isLoggedIn => _account != null && _member != null;

  void startSession({
    required AccountModel account,
    required MemberModel member,
  }) {
    _account = account;
    _member = member;
  }

  void clearSession() {
    _account = null;
    _member = null;
  }
}