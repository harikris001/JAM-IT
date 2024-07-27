import 'package:fpdart/fpdart.dart';
import 'package:jam_it/features/auth/model/user_model.dart';
import 'package:jam_it/features/auth/repositories/auth_local_repository.dart';
import 'package:jam_it/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginUser(r),
    };

    print(val);
  }

  AsyncValue<UserModel>? _loginUser(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state = AsyncValue.data(user);
  }

  Future<void> initSharedPreference() async {
    await _authLocalRepository.init();
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => AsyncValue.data(r),
      };

      return val.value;
    }
    return null;
  }
}
