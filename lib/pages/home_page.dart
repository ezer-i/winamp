import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:winamp/database/database.dart';
import 'package:winamp/models/notifiers/player_state_notifier.dart';
import 'package:winamp/models/track_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDatabase _db;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropTarget(
                    onDragEntered: (details) {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onDragExited: (details) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    onDragDone: (details) {
                      setState(() {
                        _isDragging = false;
                      });
                      _handleDroppedFiles(details.files
                          .map((item) => PlatformFile(
                                name: p.basename(item.path),
                                path: item.path,
                                size: File(item.path).lengthSync(),
                              ))
                          .toList());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color:
                            _isDragging ? Colors.blue[300] : Colors.grey[850],
                      ),
                      child: _buildImportArea(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[900],
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Recently Added Songs',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: _buildTrackList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDuration(int milliseconds) {
    final Duration duration = Duration(milliseconds: milliseconds);
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildImportArea() {
    return Container(
      color: Colors.grey[850],
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.cloud_upload,
                color: Colors.white70,
                size: 80,
              ),
              const SizedBox(height: 8),
              const Text(
                'Drag and Drop MP3 Files Here',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(CupertinoIcons.folder_open),
                label: const Text('Select MP3 Files'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await _deleteAllSongs();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All songs deleted.')),
                  );
                },
                icon: const Icon(CupertinoIcons.delete),
                label: const Text('Delete All Songs'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      await _addTracks(files);
    }
  }

  Future<void> _handleDroppedFiles(List<PlatformFile> droppedFiles) async {
    List<File> files = droppedFiles
        .map((file) => File(file.path!))
        .where((file) => p.extension(file.path).toLowerCase() == '.mp3')
        .toList();

    await _addTracks(files);
  }

  Future<void> _addTracks(List<File> files) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${appDocDir.path}/music');
    if (!musicDir.existsSync()) {
      musicDir.createSync();
    }

    for (File file in files) {
      try {
        final metadata = await MetadataRetriever.fromFile(file);

        // Copy the file to the app's music directory
        final fileName = p.basename(file.path);
        final newFilePath = '${musicDir.path}/$fileName';

        // Check if file already exists
        File newFile = File(newFilePath);
        if (!newFile.existsSync()) {
          newFile = await file.copy(newFilePath);
        }

        String path = newFile.path;
        String title =
            metadata.trackName ?? p.basenameWithoutExtension(file.path);
        int number = metadata.trackNumber ?? 0;
        String artistName =
            metadata.trackArtistNames?.first ?? 'Unknown Artist';
        String albumTitle = metadata.albumName ?? 'Unknown Album';
        int duration = metadata.trackDuration ?? 0; // In milliseconds
        Uint8List? albumArt = metadata.albumArt;

        TrackModel track = TrackModel(
          path: path,
          title: title,
          number: number,
          artistName: artistName,
          albumTitle: albumTitle,
          duration: duration,
          albumArt: albumArt,
        );

        await _db.into(_db.tracks).insertOnConflictUpdate(
              TracksCompanion.insert(
                path: track.path,
                title: track.title,
                number: track.number,
                artistName: track.artistName,
                albumTitle: drift.Value(track.albumTitle),
                duration: track.duration,
                albumArt: albumArt != null
                    ? drift.Value(albumArt)
                    : const drift.Value.absent(),
              ),
            );
      } catch (e) {
        debugPrint('Error loading file: ${e.toString()}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load ${p.basename(file.path)}: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _deleteAllSongs() async {
    await _db.deleteEverything();

    final appDocDir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${appDocDir.path}/music');
    if (musicDir.existsSync()) {
      musicDir.deleteSync(recursive: true);
    }
  }

  Widget _buildTrackList() {
    return StreamBuilder<List<TrackModel>>(
      stream: _db.watchTracks().distinct().map((tracks) => tracks
          .map((track) => TrackModel(
                path: track.path,
                title: track.title,
                number: track.number,
                artistName: track.artistName,
                duration: track.duration,
                albumArt: track.albumArt,
              ))
          .toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No songs available.',
              style: TextStyle(color: Colors.white54, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          final tracksData = snapshot.data!;
          final tracks = tracksData.map((data) {
            return TrackModel(
              path: data.path,
              title: data.title,
              number: data.number,
              artistName: data.artistName,
              duration: data.duration,
              albumArt: data.albumArt,
            );
          }).toList();

          return ListView.separated(
            itemCount: tracks.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.white24,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final track = tracks[index];
              Widget leadingWidget;

              if (track.albumArt != null) {
                leadingWidget = Image.memory(
                  track.albumArt!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                );
              } else {
                leadingWidget = const Icon(CupertinoIcons.double_music_note,
                    color: Colors.blueAccent, size: 40);
              }

              return ListTile(
                leading: leadingWidget,
                title: Text(
                  track.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  track.artistName,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                trailing: Text(
                  _formatDuration(track.duration),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                onTap: () {
                  _playTrack(track);
                },
              );
            },
          );
        }
      },
    );
  }

  Future<void> _playTrack(TrackModel track) async {
    final playerState =
        Provider.of<PlayerStateNotifier>(context, listen: false);

    try {
      final tracksData = await _db.getTracks();
      final playlist = tracksData.map((data) {
        return TrackModel(
          path: data.path,
          title: data.title,
          number: data.number,
          artistName: data.artistName,
          duration: data.duration,
          albumArt: data.albumArt,
        );
      }).toList();

      final index = playlist.indexWhere((t) => t.path == track.path);
      playerState.setPlaylist(playlist, startIndex: index);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error playing ${p.basename(track.path)}: ${e.toString()}'),
        ),
      );
    }
  }

}
