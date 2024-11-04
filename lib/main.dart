import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:winamp/app_widget.dart';
import 'package:winamp/database/database.dart';
import 'package:winamp/models/custom_theme.dart';
import 'package:winamp/models/notifiers/player_state_notifier.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(const Size(1200, 800));
    await DesktopWindow.setMaxWindowSize(const Size(1600, 1400));
  }
  final AppDatabase database = AppDatabase();
   ThemeNotifier themeNotifier = ThemeNotifier(
    CustomTheme.getDefaultTheme(),
    'default_theme',
  );

  await themeNotifier.loadThemeFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),
        Provider<Player>(
          create: (_) => Player(),
          dispose: (_, player) => player.dispose(),
        ),
        ChangeNotifierProvider<PlayerStateNotifier>(
          create: (context) => PlayerStateNotifier(
            Provider.of<Player>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => themeNotifier,
        ),
      ],
      child: const AppWidget(),
    ),
  );
}

