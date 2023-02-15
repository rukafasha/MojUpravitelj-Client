class ModelBuildingsByAddress {
  final int buildingId;
  final String address;
  final int numberOfApartments;
  final String countyName;
  final String countryName;
  final int? representativeId;
  final String? representativeFirstName;
  final String? representativeLastName;
  final int companyId;
  final String companyName;

  const ModelBuildingsByAddress({
    required this.buildingId,
    required this.address,
    required this.numberOfApartments,
    required this.countyName,
    required this.countryName,
    required this.representativeId,
    required this.representativeFirstName,
    required this.representativeLastName,
    required this.companyId,
    required this.companyName,
  });

  static ModelBuildingsByAddress fromJson(json) => ModelBuildingsByAddress(
        buildingId: json["buildingId"],
        address: json["address"],
        numberOfApartments: json["numberOfApartments"],
        countyName: json["countyName"],
        countryName: json["countryName"],
        representativeId: json["representativeId"],
        representativeFirstName: json["representativeFirstName"],
        representativeLastName: json["representativeLastName"],
        companyId: json["companyId"],
        companyName: json["companyName"],
      );
}
