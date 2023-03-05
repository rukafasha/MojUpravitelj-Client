// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAccount {
  final int userAccountId;
  final String username;
  final String password;
  UserAccount({
    required this.userAccountId,
    required this.username,
    required this.password,
  });

  UserAccount copyWith({
    int? userAccountId,
    String? username,
    String? password,
  }) {
    return UserAccount(
      userAccountId: userAccountId ?? this.userAccountId,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userAccountId': userAccountId,
      'username': username,
      'password': password,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      userAccountId: map['userAccountId'] as int,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) =>
      UserAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAccount(userAccountId: $userAccountId, username: $username, password: $password)';
  }

  @override
  bool operator ==(covariant UserAccount other) {
    if (identical(this, other)) return true;

    return other.userAccountId == userAccountId &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return userAccountId.hashCode ^
        username.hashCode ^
        password.hashCode;
  }
}
