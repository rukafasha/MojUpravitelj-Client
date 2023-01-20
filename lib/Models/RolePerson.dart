// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RolePerson {
  final int id;
  final int personId;
  final int roleId;
  final bool isActive;
  RolePerson({
    required this.id,
    required this.personId,
    required this.roleId,
    required this.isActive,
  });

  RolePerson copyWith({
    int? id,
    int? personId,
    int? roleId,
    bool? isActive,
  }) {
    return RolePerson(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      roleId: roleId ?? this.roleId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'personId': personId,
      'roleId': roleId,
      'isActive': isActive,
    };
  }

  factory RolePerson.fromMap(Map<String, dynamic> map) {
    return RolePerson(
      id: map['id'] as int,
      personId: map['personId'] as int,
      roleId: map['roleId'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RolePerson.fromJson(String source) =>
      RolePerson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RolePerson(id: $id, personId: $personId, roleId: $roleId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant RolePerson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.personId == personId &&
        other.roleId == roleId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personId.hashCode ^
        roleId.hashCode ^
        isActive.hashCode;
  }
}
