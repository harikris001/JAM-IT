import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/providers/current_user_notifier.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/features/home/view/pages/library_page.dart';
import 'package:jam_it/features/home/view/pages/songs_page.dart';
import 'package:jam_it/features/home/view/widgets/music_slab.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
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
            icon: Image.asset('assets/images/library.png'),
            label: 'Library',
          )
        ],
      ),
    );
  }
}
