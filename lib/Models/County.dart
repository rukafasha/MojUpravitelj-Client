
import 'dart:convert';

class County {
  final int countyId;
  final String countyName;
  final int countryId;
  County({
    required this.countyId,
    required this.countyName,
    required this.countryId,
  });

  County copyWith({
    int? countyId,
    String? countyName,
    int? countryId,
  }) {
    return County(
      countyId: countyId ?? this.countyId,
      countyName: countyName ?? this.countyName,
      countryId: countryId ?? this.countryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countyId': countyId,
      'countyName': countyName,
      'countryId': countryId,
    };
  }

  factory County.fromMap(Map<String, dynamic> map) {
    return County(
      countyId: map['countyId'] as int,
      countyName: map['countyName'] as String,
      countryId: map['countryId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory County.fromJson(String source) =>
      County.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Country(countyId: $countyId, countyName: $countyName, countryId: $countryId)';
  }

  @override
  bool operator ==(covariant County other) {
    if (identical(this, other)) return true;

    return other.countyId == countyId &&
        other.countyName == countyName &&
        other.countryId == countryId;
  }

  @override
  int get hashCode {
    return countyId.hashCode ^
        countyName.hashCode ^
        countryId.hashCode;
  }
}
