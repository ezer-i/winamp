import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winamp/models/custom_theme.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    var customTheme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Container(
      width: 250,
      color: customTheme
          .backgroundColorObj,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Container(
              width: double.infinity,
              color: Colors.grey[600],
              child: Image.asset(
                'assets/logo/winamp-logo.png',
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Winamp Music', customTheme),
          _buildSidebarItem(CupertinoIcons.home, 'Home', 0, customTheme),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildSectionHeader('Library', customTheme),
          ),
          _buildSidebarItem(
              CupertinoIcons.music_mic, 'Artists', 1, customTheme),
          _buildSidebarItem(
              CupertinoIcons.square_stack, 'Albums', 2, customTheme),
          _buildSidebarItem(CupertinoIcons.music_note, 'Songs', 3, customTheme),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildSectionHeader('Settings', customTheme),
          ),
          _buildSidebarItem(CupertinoIcons.brightness, 'Theme', 4, customTheme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, CustomTheme customTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: customTheme.textColorObj.withOpacity(0.4),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
      IconData icon, String title, int index, CustomTheme customTheme) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index
            ? customTheme.accentColorObj
            : Colors.grey[400],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index
              ? customTheme.accentColorObj
              : Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selectedIndex == index,
      selectedTileColor: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => onItemSelected(index),
    );
  }
}
