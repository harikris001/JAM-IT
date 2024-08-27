import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/providers/current_song_notifier.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/utils/utils.dart';
import 'package:jam_it/core/widgets/Loader/loader.dart';
import 'package:jam_it/features/home/viewmodel/home_viewmodel.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayed =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayed();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(colors: [
                hexToColor(currentSong.hex_code),
                Pallete.transparentColor,
              ], stops: const [
                0.0,
                0.3
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 35, left: 14),
            child: Text(
              "Recent played",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          recentlyPlayed.isEmpty
              ? const SizedBox(
                  height: 280,
                  child: Center(
                      child: Text(
                    "No songs played Recently.",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )),
                )
              : Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 36),
                  height: 280,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: recentlyPlayed.length,
                    itemBuilder: (context, index) {
                      final song = recentlyPlayed[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Pallete.cardColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(song.thumbnail_url),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  song.song_name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Latest Uploads',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSongNotifierProvider.notifier)
                                .updateSong(song);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: songs.length,
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(
                      error.toString(),
                    ),
                  );
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
