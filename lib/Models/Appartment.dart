import 'dart:convert';

class Appartment {
  final int appartmentId;
  final int appartmentNumber;
  final int buildingId;
  final int numberOfPeople;

  Appartment({
    required this.appartmentId,
    required this.appartmentNumber,
    required this.buildingId,
    required this.numberOfPeople,
  });

  Appartment copyWith({
    int? appartmentId,
    int? appartmentNumber,
    int? buildingId,
    int? numberOfPeople,
  }) {
    return Appartment(
      appartmentId: appartmentId ?? this.appartmentId,
      appartmentNumber: appartmentNumber ?? this.appartmentNumber,
      buildingId: buildingId ?? this.buildingId,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appartmentId': appartmentId,
      'appartmentNumber': appartmentNumber,
      'buildingId': buildingId,
      'numberOfPeople': numberOfPeople,
    };
  }

  factory Appartment.fromMap(Map<String, dynamic> map) {
    return Appartment(
      appartmentId: map['appartmentId'] as int,
      appartmentNumber: map['appartmentNumber'] as int,
      buildingId: map['buildingId'] as int,
      numberOfPeople: map['numberOfPeople'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Appartment.fromJson(String source) =>
      Appartment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Appartment(appartmentId: $appartmentId, appartmentNumber: $appartmentNumber, buildingId: $buildingId, numberOfPeople: $numberOfPeople)';
  }

  @override
  bool operator ==(covariant Appartment other) {
    if (identical(this, other)) return true;

    return other.appartmentId == appartmentId &&
        other.appartmentNumber == appartmentNumber &&
        other.buildingId == buildingId &&
        other.numberOfPeople == numberOfPeople;
  }

  @override
  int get hashCode {
    return appartmentId.hashCode ^
        appartmentNumber.hashCode ^
        buildingId.hashCode ^
        numberOfPeople.hashCode;
  }
}
