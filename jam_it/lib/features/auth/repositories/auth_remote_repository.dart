import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:jam_it/core/constants/server_constants.dart';
import 'package:jam_it/core/failure/failure.dart';
import 'package:jam_it/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/signup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "password": password,
          },
        ),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            message: resBodyMap['detail'],
          ),
        );
      }

      return Right(
        UserModel.fromMap(resBodyMap),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(message: resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap['user'])
            .copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(message: resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap).copyWith(
          token: token,
        ),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
