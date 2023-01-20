// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppartmentPerson {
  final int id;
  final int personId;
  final int appartmentId;
  final bool isActive;
  AppartmentPerson({
    required this.id,
    required this.personId,
    required this.appartmentId,
    required this.isActive,
  });

  AppartmentPerson copyWith({
    int? id,
    int? personId,
    int? appartmentId,
    bool? isActive,
  }) {
    return AppartmentPerson(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      appartmentId: appartmentId ?? this.appartmentId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'personId': personId,
      'appartmentId': appartmentId,
      'isActive': isActive,
    };
  }

  factory AppartmentPerson.fromMap(Map<String, dynamic> map) {
    return AppartmentPerson(
      id: map['id'] as int,
      personId: map['personId'] as int,
      appartmentId: map['appartmentId'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppartmentPerson.fromJson(String source) =>
      AppartmentPerson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppartmentPerson(id: $id, personId: $personId, appartmentId: $appartmentId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant AppartmentPerson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.personId == personId &&
        other.appartmentId == appartmentId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personId.hashCode ^
        appartmentId.hashCode ^
        isActive.hashCode;
  }
}
