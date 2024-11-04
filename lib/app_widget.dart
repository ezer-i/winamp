import 'package:flutter/material.dart';
import 'package:winamp/screens/winamp_main_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Media Player',
      home: WinampMainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
