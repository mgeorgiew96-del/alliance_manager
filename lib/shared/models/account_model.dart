class AccountModel {
  const AccountModel({
    required this.amId,
    required this.passwordHash,
    required this.passwordSalt,
    required this.mustChangePassword,
    required this.failedAttempts,
    required this.accountStatus,
    this.createdAt,
    this.lastLoginAt,
  });

  final String amId;
  final String passwordHash;
  final String passwordSalt;
  final bool mustChangePassword;
  final int failedAttempts;
  final String accountStatus;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  bool get isActive => accountStatus == 'active';

  AccountModel copyWith({
    String? amId,
    String? passwordHash,
    String? passwordSalt,
    bool? mustChangePassword,
    int? failedAttempts,
    String? accountStatus,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AccountModel(
      amId: amId ?? this.amId,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
