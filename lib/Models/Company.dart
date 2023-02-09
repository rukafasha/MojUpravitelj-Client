// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Company {
  final int companyId;
  final String companyName;
  Company({
    required this.companyId,
    required this.companyName,
  });

  Company copyWith({
    int? companyId,
    String? companyName,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyId': companyId,
      'companyName': companyName,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      companyId: map['companyId'] as int,
      companyName: map['companyName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Company(companyId: $companyId, companyName: $companyName)';

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.companyId == companyId &&
        other.companyName == companyName;
  }

  @override
  int get hashCode =>
      companyId.hashCode ^ companyName.hashCode;
}
