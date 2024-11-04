import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winamp/database/database.dart';
import 'package:winamp/models/notifiers/player_state_notifier.dart';
import 'package:winamp/models/track_model.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';
import 'package:winamp/widgets/audio_player_global_widget.dart';

class ArtistTracksScreen extends StatefulWidget {
  final String artistName;

  const ArtistTracksScreen({super.key, required this.artistName});

  @override
  State<ArtistTracksScreen> createState() => _ArtistTracksScreenState();
}

class _ArtistTracksScreenState extends State<ArtistTracksScreen> {
  late AppDatabase _db;
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
    _tracksFuture = _getTracksByArtist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDuration(int milliseconds) {
    final Duration duration = Duration(milliseconds: milliseconds);
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<List<TrackModel>> _getTracksByArtist() async {
    final tracksData = await _db.getTracksByArtist(widget.artistName);
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

  void _playTracks(List<TrackModel> tracks, int startIndex) {
    final playerState =
        Provider.of<PlayerStateNotifier>(context, listen: false);
    playerState.setPlaylist(tracks, startIndex: startIndex);
  }

  @override
  Widget build(BuildContext context) {
    var customTheme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artistName),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: customTheme.textColorObj),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow, color: customTheme.textColorObj),
            onPressed: () async {
              final tracks = await _tracksFuture;
              _playTracks(tracks, 0);
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
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tracks found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final tracks = snapshot.data!;
            tracks.sort((a, b) => a.number.compareTo(b.number));
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
                  leadingWidget = const Icon(Icons.music_note,
                      color: Colors.blueAccent, size: 40);
                }

                return ListTile(
                  leading: leadingWidget,
                  title: Text(
                    track.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    track.albumTitle ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  trailing: Text(
                    _formatDuration(track.duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _playTracks(tracks, index);
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const AudioPlayerGlobalWidget(),
    );
  }
}
