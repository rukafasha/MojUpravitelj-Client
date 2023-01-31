// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Person {
  final int personId;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final int? companyId;
  final int userAccountId;
  final bool isActive;
  Person({
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.companyId,
    required this.userAccountId,
    required this.isActive,
  });

  Person copyWith({
    int? personId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    int? companyId,
    int? userAccountId,
    bool? isActive,
  }) {
    return Person(
      personId: personId ?? this.personId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      companyId: companyId ?? this.companyId,
      userAccountId: userAccountId ?? this.userAccountId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'personId': personId,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'companyId': companyId,
      'userAccountId': userAccountId,
      'isActive': isActive,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      personId: map['personId'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      companyId: map['companyId'] != null ? map['companyId'] as int : null,
      userAccountId: map['userAccountId'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Person(personId: $personId, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, companyId: $companyId, userAccountId: $userAccountId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.personId == personId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.companyId == companyId &&
        other.userAccountId == userAccountId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return personId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        dateOfBirth.hashCode ^
        companyId.hashCode ^
        userAccountId.hashCode ^
        isActive.hashCode;
  }
}
