import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/providers/current_song_notifier.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/widgets/Loader/loader.dart';
import 'package:jam_it/features/home/viewmodel/home_viewmodel.dart';

class SearchList extends ConsumerWidget {
  const SearchList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getSearchResultProvider).when(
          data: (data) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final song = data[index];
                return ListTile(
                  onTap: () => ref
                      .watch(currentSongNotifierProvider.notifier)
                      .updateSong(song),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.thumbnail_url),
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                  ),
                  title: Text(
                    song.song_name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return const Center(
              child: Text("Some error occured"),
            );
          },
          loading: () => const Loader(),
        );
  }
}
