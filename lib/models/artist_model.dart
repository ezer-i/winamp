import 'dart:typed_data';

class ArtistModel {
  final String artistName;
  final int songCount;
  final Uint8List? albumArt;

  ArtistModel({
    required this.artistName,
    required this.songCount,
    this.albumArt,
  });
}
