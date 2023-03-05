// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Country {
  final int countryId;
  final String countryName;
  Country({
    required this.countryId,
    required this.countryName,
  });

  Country copyWith({
    int? countryId,
    String? countryName,
  }) {
    return Country(
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countryId': countryId,
      'countryName': countryName,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countryId: map['countryId'] as int,
      countryName: map['countryName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Country(countryId: $countryId, countryName: $countryName)';

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.countryId == countryId &&
        other.countryName == countryName;
  }

  @override
  int get hashCode =>
      countryId.hashCode ^ countryName.hashCode;
}
