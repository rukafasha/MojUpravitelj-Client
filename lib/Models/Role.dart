// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Role {
  final int roleId;
  final String roleName;
  final String roleDescription;
  Role({
    required this.roleId,
    required this.roleName,
    required this.roleDescription,
  });

  Role copyWith({
    int? roleId,
    String? roleName,
    String? roleDescription,
  }) {
    return Role(
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      roleDescription: roleDescription ?? this.roleDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roleId': roleId,
      'roleName': roleName,
      'roleDescription': roleDescription,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      roleId: map['roleId'] as int,
      roleName: map['roleName'] as String,
      roleDescription: map['roleDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) =>
      Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Role(roleId: $roleId, roleName: $roleName, roleDescription: $roleDescription)';
  }

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.roleId == roleId &&
        other.roleName == roleName &&
        other.roleDescription == roleDescription;
  }

  @override
  int get hashCode {
    return roleId.hashCode ^
        roleName.hashCode ^
        roleDescription.hashCode;
  }
}
