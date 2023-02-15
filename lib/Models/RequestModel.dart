class RequestModel {
  final int requestId;
  final int ownerId;
  final int tenantId;
  final int appartmentId;
  final bool? approved;
  final String firstName;
  final String lastName;
  final String address;
  final String county;
  final String country;

  const RequestModel({
    required this.requestId,
    required this.ownerId,
    required this.tenantId,
    required this.appartmentId,
    required this.approved,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.county,
    required this.country,
  });

  static RequestModel fromJson(json) => RequestModel(
        requestId: json["requestId"],
        ownerId: json["ownerId"],
        tenantId: json["tenantId"],
        appartmentId: json["appartmentId"],
        approved: json["approved"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        county: json["county"],
        country: json["country"],
      );
}
