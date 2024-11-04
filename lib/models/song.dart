import 'dart:io';
import 'dart:typed_data';

class Song {
  final int? id;
  final File file;
  final String title;
  final String artist;
  final String album;
  final Uint8List? albumArt;

  Song({
    this.id,
    required this.file,
    required this.title,
    required this.artist,
    required this.album,
    this.albumArt,
  });
}
