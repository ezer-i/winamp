import 'dart:typed_data';

class AlbumModel {
  final String albumTitle;
  final String artistName;
  final int songCount;
  final Uint8List? albumArt;

  AlbumModel({
    required this.albumTitle,
    required this.artistName,
    required this.songCount,
    this.albumArt,
  });
}
