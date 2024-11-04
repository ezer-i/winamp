import 'package:flutter/foundation.dart' show immutable;
import 'dart:typed_data';

@immutable
class TrackModel {
  final String path;
  final String title;
  final int number;
  final String artistName;
   final String? albumTitle;
  final int duration;
  final Uint8List? albumArt;

  const TrackModel({
    required this.path,
    required this.title,
    required this.number,
    required this.artistName,
    this.albumTitle,
    required this.duration,
    this.albumArt,
  });

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'title': title,
      'number': number,
      'artistName': artistName,
      'albumTitle': albumTitle,
      'duration': duration,
      'albumArt': albumArt,
    };
  }
}
