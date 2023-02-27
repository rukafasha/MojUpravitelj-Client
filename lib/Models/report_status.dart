// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReportStatus {
  final int reportStatusId;
  final String statusDescription;
  ReportStatus({
    required this.reportStatusId,
    required this.statusDescription,
  });

  ReportStatus copyWith({
    int? reportStatusId,
    String? statusDescription,
  }) {
    return ReportStatus(
      reportStatusId: reportStatusId ?? this.reportStatusId,
      statusDescription: statusDescription ?? this.statusDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reportStatusId': reportStatusId,
      'statusDescription': statusDescription,
    };
  }

  factory ReportStatus.fromMap(Map<String, dynamic> map) {
    return ReportStatus(
      reportStatusId: map['reportStatusId'] as int,
      statusDescription: map['statusDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportStatus.fromJson(String source) =>
      ReportStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReportStatus(reportStatusId: $reportStatusId, statusDescription: $statusDescription)';

  @override
  bool operator ==(covariant ReportStatus other) {
    if (identical(this, other)) return true;

    return other.reportStatusId == reportStatusId &&
        other.statusDescription == statusDescription;
  }

  @override
  int get hashCode =>
      reportStatusId.hashCode ^ statusDescription.hashCode;
}
