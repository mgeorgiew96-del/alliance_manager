import '../enums/member_rank.dart';
import '../enums/permission.dart';

class RoleModel {
  const RoleModel({
    required this.rank,
    required this.name,
    required this.permissions,
  });

  final MemberRank rank;
  final String name;
  final Set<Permission> permissions;

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  RoleModel copyWith({
    MemberRank? rank,
    String? name,
    Set<Permission>? permissions,
  }) {
    return RoleModel(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
    );
  }
}
