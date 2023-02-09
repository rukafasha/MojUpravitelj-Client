import 'dart:convert';

class Report {
  final int id;
  final String title;
  final String description;
  final DateTime timeCreated;
  final DateTime? timeFinished;
  final int madeBy;
  final int? closedBy;
  final int status;
  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.timeCreated,
    this.timeFinished,
    required this.madeBy,
    this.closedBy,
    required this.status,
  });

  Report copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? timeCreated,
    DateTime? timeFinished,
    int? madeBy,
    int? closedBy,
    int? status,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeCreated: timeCreated ?? this.timeCreated,
      timeFinished: timeFinished ?? this.timeFinished,
      madeBy: madeBy ?? this.madeBy,
      closedBy: closedBy ?? this.closedBy,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
      'timeFinished': timeFinished?.millisecondsSinceEpoch,
      'madeBy': madeBy,
      'closedBy': closedBy,
      'status': status,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      timeCreated:
          DateTime.parse(map['timeCreated']),
      timeFinished: map['timeFinished'] != null
          ? DateTime.parse(map['timeFinished'])
          : null,
      madeBy: map['madeBy'] as int,
      closedBy: map['closedBy'] != null ? map['closedBy'] as int : null,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(id: $id, title: $title, description: $description, timeCreated: $timeCreated, timeFinished: $timeFinished, madeBy: $madeBy, closedBy: $closedBy, status: $status)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.timeCreated == timeCreated &&
        other.timeFinished == timeFinished &&
        other.madeBy == madeBy &&
        other.closedBy == closedBy &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        timeCreated.hashCode ^
        timeFinished.hashCode ^
        madeBy.hashCode ^
        closedBy.hashCode ^
        status.hashCode;
  }
}