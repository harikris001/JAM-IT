import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:jam_it/core/providers/current_user_notifier.dart';
import 'package:jam_it/core/utils/utils.dart';
import 'package:jam_it/features/home/model/fav_song_model.dart';
import 'package:jam_it/features/home/model/song_model.dart';
import 'package:jam_it/features/home/repositories/home_local_repository.dart';
import 'package:jam_it/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File audio,
    required File image,
    required String songName,
    required String artist,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      audio: audio,
      image: image,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(color),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  List<SongModel> getRecentlyPlayed() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({
    required String songId,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.favSongs(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favouriteSongSuccess(r, songId),
    };

    print(val);
  }

  AsyncValue _favouriteSongSuccess(bool isFavourited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavourited) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: [
            ...ref.read(currentUserNotifierProvider)!.favourites,
            FavSongModel(
              id: '',
              song_id: songId,
              user_id: '',
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favourites: ref
                  .read(currentUserNotifierProvider)!
                  .favourites
                  .where(
                    (fav) => fav.song_id != songId,
                  )
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavourited);
  }
}
