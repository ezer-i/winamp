import 'package:flutter/material.dart';
import 'package:winamp/pages/albums_page.dart';
import 'package:winamp/pages/all_songs_page.dart';
import 'package:winamp/pages/artists_page.dart';
import 'package:winamp/pages/home_page.dart';
import 'package:winamp/pages/theme_page.dart';
import 'package:winamp/widgets/audio_player_global_widget.dart';
import '../widgets/sidebar.dart';

class WinampMainScreen extends StatefulWidget {
  const WinampMainScreen({super.key});

  @override
  State<WinampMainScreen> createState() => _WinampMainScreenState();
}

class _WinampMainScreenState extends State<WinampMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ArtistsPage(),
    const AlbumsPage(),
    const AllSongsPage(),
    const ThemeSelectionScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
          const VerticalDivider(
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                const AudioPlayerGlobalWidget(),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
