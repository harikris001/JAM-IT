import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/providers/current_song_notifier.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/utils/utils.dart';
import 'package:jam_it/features/auth/view/widgets/hero_image.dart';
import 'package:jam_it/features/home/view/pages/library_page.dart';
import 'package:jam_it/features/home/view/pages/search_page.dart';
import 'package:jam_it/features/home/view/pages/songs_page.dart';
import 'package:jam_it/features/home/view/pages/upload_song_page.dart';
import 'package:jam_it/features/home/view/widgets/about_info.dart';
import 'package:jam_it/features/home/view/widgets/music_slab.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List pages = const [
    SongsPage(),
    LibraryPage(),
    SearchPage(),
  ];

  Future<void> _launchGithubRepo() async {
    final url = Uri.parse("https://github.com/harikris001/JAM-IT");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        snackBarPopUp(context, "Unable to open");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                child: HeroImage(
              angle: 0,
            )),
            const SizedBox(
              height: 20,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_upload_outlined),
                  title: const Text('Upload Your Song'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UploadSongPage(),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => const AboutInfo(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('Support Project on Github'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _launchGithubRepo();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          pages[_selectedIndex],
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) async {
                if (details.delta.dy > 0) {
                  if (details.delta.dy > 5) {
                    await ref
                        .read(currentSongNotifierProvider.notifier)
                        .audioPlayer!
                        .stop();
                    ref
                        .read(currentSongNotifierProvider.notifier)
                        .updateSong(null);
                  }
                }
              },
              child: const MusicSlab(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color: _selectedIndex == 0
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: _selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2
                  ? 'assets/images/search_filled.png'
                  : 'assets/images/search_unfilled.png',
              color: _selectedIndex == 2
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
