// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'a53a3d396d1fb56df51c87f5b8268be0061ba2d3';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$homeViewModelHash() => r'9ed39b18c5c1932c5ab7d63f1cd5f461f3dcf0c1';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, AsyncValue?>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
