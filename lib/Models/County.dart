
import 'dart:convert';

class County {
  final int countyId;
  final String countyName;
  final int countryId;
  final bool isActive;
  County({
    required this.countyId,
    required this.countyName,
    required this.countryId,
    required this.isActive,
  });

  County copyWith({
    int? countyId,
    String? countyName,
    int? countryId,
    bool? isActive,
  }) {
    return County(
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

  factory County.fromMap(Map<String, dynamic> map) {
    return County(
      countyId: map['countyId'] as int,
      countyName: map['countyName'] as String,
      countryId: map['countryId'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory County.fromJson(String source) =>
      County.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Country(countyId: $countyId, countyName: $countyName, countryId: $countryId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant County other) {
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
