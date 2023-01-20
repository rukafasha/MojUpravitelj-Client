// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final int commentId;
  final int personId;
  final int reportId;
  final String content;
  final bool isActive;
  Comment({
    required this.commentId,
    required this.personId,
    required this.reportId,
    required this.content,
    required this.isActive,
  });

  Comment copyWith({
    int? commentId,
    int? personId,
    int? reportId,
    String? content,
    bool? isActive,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      personId: personId ?? this.personId,
      reportId: reportId ?? this.reportId,
      content: content ?? this.content,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'personId': personId,
      'reportId': reportId,
      'content': content,
      'isActive': isActive,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as int,
      personId: map['personId'] as int,
      reportId: map['reportId'] as int,
      content: map['content'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(commentId: $commentId, personId: $personId, reportId: $reportId, content: $content, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.personId == personId &&
        other.reportId == reportId &&
        other.content == content &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        personId.hashCode ^
        reportId.hashCode ^
        content.hashCode ^
        isActive.hashCode;
  }
}
