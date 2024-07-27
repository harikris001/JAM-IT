// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String token;
  final String name;
  final String email;
  final String id;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.id,
  });

  UserModel copyWith({
    String? token,
    String? name,
    String? email,
    String? id,
  }) {
    return UserModel(
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'name': name,
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(token: $token, name: $name, email: $email, id: $id)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.name == name &&
        other.email == email &&
        other.id == id;
  }

  @override
  int get hashCode {
    return token.hashCode ^ name.hashCode ^ email.hashCode ^ id.hashCode;
  }
}
