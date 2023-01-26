// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Country {
  final int countyId;
  final String countyName;
  final int countryId;
  final bool isActive;
  Country({
    required this.countyId,
    required this.countyName,
    required this.countryId,
    required this.isActive,
  });

  Country copyWith({
    int? countyId,
    String? countyName,
    int? countryId,
    bool? isActive,
  }) {
    return Country(
      countyId: countyId ?? this.countyId,
      countyName: countyName ?? this.countyName,
      countryId: countryId ?? this.countryId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countyId': countyId,
      'countyName': countyName,
      'countryId': countryId,
      'isActive': isActive,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countyId: map['countyId'] as int,
      countyName: map['countyName'] as String,
      countryId: map['countryId'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Country(countyId: $countyId, countyName: $countyName, countryId: $countryId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.countyId == countyId &&
        other.countyName == countyName &&
        other.countryId == countryId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return countyId.hashCode ^
        countyName.hashCode ^
        countryId.hashCode ^
        isActive.hashCode;
  }
}
