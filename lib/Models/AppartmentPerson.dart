// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppartmentPerson {
  final int id;
  final int personId;
  final int appartmentId;
  AppartmentPerson({
    required this.id,
    required this.personId,
    required this.appartmentId,
  });

  AppartmentPerson copyWith({
    int? id,
    int? personId,
    int? appartmentId,
  }) {
    return AppartmentPerson(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      appartmentId: appartmentId ?? this.appartmentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'personId': personId,
      'appartmentId': appartmentId,
    };
  }

  factory AppartmentPerson.fromMap(Map<String, dynamic> map) {
    return AppartmentPerson(
      id: map['id'] as int,
      personId: map['personId'] as int,
      appartmentId: map['appartmentId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppartmentPerson.fromJson(String source) =>
      AppartmentPerson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppartmentPerson(id: $id, personId: $personId, appartmentId: $appartmentId)';
  }

  @override
  bool operator ==(covariant AppartmentPerson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.personId == personId &&
        other.appartmentId == appartmentId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personId.hashCode ^
        appartmentId.hashCode;
  }
}
