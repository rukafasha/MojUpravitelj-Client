// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAccount {
  final int userAccountId;
  final String username;
  final String password;
  final bool isActive;
  UserAccount({
    required this.userAccountId,
    required this.username,
    required this.password,
    required this.isActive,
  });

  UserAccount copyWith({
    int? userAccountId,
    String? username,
    String? password,
    bool? isActive,
  }) {
    return UserAccount(
      userAccountId: userAccountId ?? this.userAccountId,
      username: username ?? this.username,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userAccountId': userAccountId,
      'username': username,
      'password': password,
      'isActive': isActive,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      userAccountId: map['userAccountId'] as int,
      username: map['username'] as String,
      password: map['password'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) =>
      UserAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAccount(userAccountId: $userAccountId, username: $username, password: $password, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant UserAccount other) {
    if (identical(this, other)) return true;

    return other.userAccountId == userAccountId &&
        other.username == username &&
        other.password == password &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return userAccountId.hashCode ^
        username.hashCode ^
        password.hashCode ^
        isActive.hashCode;
  }
}
