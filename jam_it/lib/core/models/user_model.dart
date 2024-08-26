// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:jam_it/features/home/model/fav_song_model.dart';

class UserModel {
  final String token;
  final String name;
  final String email;
  final String id;
  final List<FavSongModel> favourites;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.id,
    required this.favourites,
  });

  UserModel copyWith({
    String? token,
    String? name,
    String? email,
    String? id,
    List<FavSongModel>? favourites,
  }) {
    return UserModel(
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      favourites: favourites ?? this.favourites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'name': name,
      'email': email,
      'id': id,
      'favourites': favourites.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      favourites: List<FavSongModel>.from(
        (map['favourites'] ?? []).map<FavSongModel>(
          (x) => FavSongModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(token: $token, name: $name, email: $email, id: $id, favourites: $favourites)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.name == name &&
        other.email == email &&
        other.id == id &&
        listEquals(other.favourites, favourites);
  }

  @override
  int get hashCode {
    return token.hashCode ^
        name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        favourites.hashCode;
  }
}
