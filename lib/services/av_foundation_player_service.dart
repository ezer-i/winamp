import 'package:flutter/services.dart';

class AVPlayerService {
  static const MethodChannel _channel = MethodChannel('com.winamp/avplayer');

  Future<void> play(String filePath) async {
    try {
      await _channel.invokeMethod('play', {'path': filePath});
    } on PlatformException {
     //  print("Failed to play");
    }
  }

  Future<void> pause() async {
    try {
      await _channel.invokeMethod('pause');
    } on PlatformException {
     //  print("Failed to pause");
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } on PlatformException {
      // print("Failed to stop");
    }
  }
}
