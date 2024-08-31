import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/providers/current_song_notifier.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/widgets/Loader/loader.dart';
import 'package:jam_it/features/home/view/pages/upload_song_page.dart';
import 'package:jam_it/features/home/viewmodel/home_viewmodel.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavSongsProvider).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "L I B R A R Y",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Favourites',
                      style: TextStyle(fontSize: 20),
                    ),
                    ListView.builder(
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
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.borderColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UploadSongPage(),
                      )),
                      child: const ListTile(
                        leading: CircleAvatar(
                          radius: 35,
                          child: Icon(Icons.cloud_upload_outlined),
                        ),
                        title: Text(
                          'Upload Song',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const Loader(),
        );
  }
}
