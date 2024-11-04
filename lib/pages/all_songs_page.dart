import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winamp/database/database.dart';
import 'package:winamp/models/notifiers/player_state_notifier.dart';
import 'package:winamp/models/track_model.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';

class AllSongsPage extends StatefulWidget {
  const AllSongsPage({super.key});

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  late AppDatabase _db;
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
    _tracksFuture = _getAllTracks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<TrackModel>> _getAllTracks() async {
    final tracksData = await _db.getTracks();
    return tracksData.map((track) {
      return TrackModel(
        path: track.path,
        title: track.title,
        number: track.number,
        artistName: track.artistName,
        albumTitle: track.albumTitle,
        duration: track.duration,
        albumArt: track.albumArt,
      );
    }).toList();
  }


  void _playAllTracks(List<TrackModel> tracks) {
    if (!mounted) return;
    final playerState =
        Provider.of<PlayerStateNotifier>(context, listen: false);
    playerState.setPlaylist(tracks, startIndex: 0);
  }

  void _playTrack(List<TrackModel> tracks, int index) {
    if (!mounted) return;
    final playerState =
        Provider.of<PlayerStateNotifier>(context, listen: false);
    playerState.setPlaylist(tracks, startIndex: index);
  }

  String _formatDuration(int milliseconds) {
    final Duration duration = Duration(milliseconds: milliseconds);
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    var customTheme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Songs', style: TextStyle(color: customTheme.textColorObj)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon:  Icon(Icons.play_arrow, color: customTheme.textColorObj),
            tooltip: 'Play All',
            onPressed: () async {
              final tracks = await _tracksFuture;

              if (tracks.isNotEmpty) {
                _playAllTracks(tracks);
              } else {
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No songs available to play.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<TrackModel>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No songs available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final tracks = snapshot.data!;
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
                  leadingWidget = const Icon(
                    Icons.music_note,
                    color: Colors.blueAccent,
                    size: 40,
                  );
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
                    _playTrack(tracks, index);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
