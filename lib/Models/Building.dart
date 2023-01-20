// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Building {
  final int buildingId;
  final String address;
  final int numberOfAppartment;
  final int countyId;
  final int companyId;
  final int? representativeId;
  final bool isActive;
  Building({
    required this.buildingId,
    required this.address,
    required this.numberOfAppartment,
    required this.countyId,
    required this.companyId,
    this.representativeId,
    required this.isActive,
  });

  Building copyWith({
    int? buildingId,
    String? address,
    int? numberOfAppartment,
    int? countyId,
    int? companyId,
    int? representativeId,
    bool? isActive,
  }) {
    return Building(
      buildingId: buildingId ?? this.buildingId,
      address: address ?? this.address,
      numberOfAppartment: numberOfAppartment ?? this.numberOfAppartment,
      countyId: countyId ?? this.countyId,
      companyId: companyId ?? this.companyId,
      representativeId: representativeId ?? this.representativeId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'buildingId': buildingId,
      'address': address,
      'numberOfAppartment': numberOfAppartment,
      'countyId': countyId,
      'companyId': companyId,
      'representativeId': representativeId,
      'isActive': isActive,
    };
  }

  factory Building.fromMap(Map<String, dynamic> map) {
    return Building(
      buildingId: map['buildingId'] as int,
      address: map['address'] as String,
      numberOfAppartment: map['numberOfAppartment'] as int,
      countyId: map['countyId'] as int,
      companyId: map['companyId'] as int,
      representativeId: map['representativeId'] != null
          ? map['representativeId'] as int
          : null,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Building.fromJson(String source) =>
      Building.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Building(buildingId: $buildingId, address: $address, numberOfAppartment: $numberOfAppartment, countyId: $countyId, companyId: $companyId, representativeId: $representativeId, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Building other) {
    if (identical(this, other)) return true;

    return other.buildingId == buildingId &&
        other.address == address &&
        other.numberOfAppartment == numberOfAppartment &&
        other.countyId == countyId &&
        other.companyId == companyId &&
        other.representativeId == representativeId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return buildingId.hashCode ^
        address.hashCode ^
        numberOfAppartment.hashCode ^
        countyId.hashCode ^
        companyId.hashCode ^
        representativeId.hashCode ^
        isActive.hashCode;
  }
}
