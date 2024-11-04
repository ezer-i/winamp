import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:winamp/models/album_model.dart';
import 'package:winamp/models/artist_model.dart';

part 'database.g.dart';

class Tracks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get path => text().withLength(min: 1, max: 200)();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  IntColumn get number => integer()();

  TextColumn get artistName => text().withLength(min: 1, max: 100)();

  IntColumn get duration => integer()();

  BlobColumn get albumArt => blob().nullable()();

  TextColumn get albumTitle => text().withLength(min: 1, max: 100).nullable()();
}

@DriftDatabase(tables: [Tracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            // Add the albumArt column
            await migrator.addColumn(tracks, tracks.albumArt);
            from++;
          }
          if (from == 2) {
            // Upgrade from version 2 to 3
            await migrator.addColumn(tracks, tracks.albumTitle);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // Handle database creation
          } else if (details.hadUpgrade) {
            // Handle database upgrade
          }
        },
      );

  Stream<List<Track>> watchTracks() => select(tracks).watch();
  Future<List<Track>> getTracks() => select(tracks).get();

  Future<List<AlbumModel>> getAlbumsWithDetails() async {
    final tracksData = await select(tracks).get();
    final Map<String, List<Track>> albumTracksMap = {};

    for (final track in tracksData) {
      final albumTitle = track.albumTitle ?? 'Unknown Album';
      albumTracksMap.putIfAbsent(albumTitle, () => []).add(track);
    }
    final List<AlbumModel> albums = [];

    albumTracksMap.forEach((albumTitle, tracksList) {
      Uint8List? albumArt;
      String artistName = 'Unknown Artist';

      for (final track in tracksList) {
        if (track.albumArt != null) {
          albumArt = track.albumArt;
        }
        if (track.artistName.isNotEmpty) {
          artistName = track.artistName;
        }
        if (albumArt != null && artistName != 'Unknown Artist') {
          break;
        }
      }

      albums.add(AlbumModel(
        albumTitle: albumTitle,
        artistName: artistName,
        songCount: tracksList.length,
        albumArt: albumArt,
      ));
    });
    albums.sort((a, b) => a.albumTitle.compareTo(b.albumTitle));

    return albums;
  }

  Future<List<Track>> getTracksByAlbum(String albumTitle) {
    return (select(tracks)..where((t) => t.albumTitle.equals(albumTitle)))
        .get();
  }

 Future<List<ArtistModel>> getArtistsWithDetails() async {
    final tracksData = await select(tracks).get();
    final Map<String, List<Track>> artistTracksMap = {};

    for (final track in tracksData) {
      final artistName = track.artistName;
      artistTracksMap.putIfAbsent(artistName, () => []).add(track);
    }
    final List<ArtistModel> artists = [];

    artistTracksMap.forEach((artistName, tracksList) {
      Uint8List? albumArt;
      for (final track in tracksList) {
        if (track.albumArt != null) {
          albumArt = track.albumArt;
          break;
        }
      }

      artists.add(ArtistModel(
        artistName: artistName,
        songCount: tracksList.length,
        albumArt: albumArt,
      ));
    });
    artists.sort((a, b) => a.artistName.compareTo(b.artistName));

    return artists;
  }

  Future<List<Track>> getTracksByArtist(String artistName) async {
    return (select(tracks)..where((t) => t.artistName.equals(artistName)))
        .get();
  }


  static QueryExecutor _openConnection() {
    return driftDatabase(name: "winamp_db");
  }

  Future<void> deleteEverything() {
    return transaction(() async {
      await delete(tracks).go();
    });
  }
}
