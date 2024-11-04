import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:winamp/models/track_model.dart';

class PlayerStateNotifier extends ChangeNotifier {
  final Player player;
  List<TrackModel> _playlist = [];
  int _currentIndex = -1;

  TrackModel? _currentlyPlaying;

  // Playback state
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // Position and duration
  Duration _currentPosition = Duration.zero;
  Duration get currentPosition => _currentPosition;

  Duration? _totalDuration;
  Duration? get totalDuration => _totalDuration;

  /// Volume control
  double _volume = 100.0;
  double get volume => _volume;

  /// Playback speed control
  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  /// Shuffle control
    bool _isShuffle = false;
  bool get isShuffle => _isShuffle;

  TrackModel? get currentlyPlaying => _currentlyPlaying;

  PlayerStateNotifier(this.player) {
    player.stream.playing.listen((bool isPlaying) {
      if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        notifyListeners();
      }
    });

    player.stream.position.listen((Duration position) {
      _currentPosition = position;
      notifyListeners();
    });

    player.stream.duration.listen((Duration? duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    player.stream.volume.listen((double volume) {
      _volume = volume;
      notifyListeners();
    });

    player.stream.completed.listen((_) {
      _currentPosition = Duration.zero;
      _isPlaying = false;
      nextTrack();
      notifyListeners();
    });
  }

  /// Set the currently playing track
  Future<void> setCurrentlyPlaying(TrackModel? track) async {
    if (track == null) {
      await player.stop();
      _currentlyPlaying = null;
      notifyListeners();
    } else {
      _currentlyPlaying = track;
      notifyListeners();
      await player.open(Media(track.path));
      await player.play();
    }
  }

  /// Set the playlist and start playing
  void setPlaylist(List<TrackModel> playlist, {int startIndex = 0}) {
    _playlist = playlist;
    _currentIndex = startIndex;
    if (_playlist.isNotEmpty) {
      setCurrentlyPlaying(_playlist[_currentIndex]);
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void nextTrack() {
    if (_playlist.isNotEmpty) {
      if (_isShuffle) {
        _currentIndex = Random().nextInt(_playlist.length);
      } else {
        _currentIndex = (_currentIndex + 1) % _playlist.length;
      }
      setCurrentlyPlaying(_playlist[_currentIndex]);
    }
  }

  void previousTrack() {
    if (_playlist.isNotEmpty) {
      if (_isShuffle) {
        _currentIndex = Random().nextInt(_playlist.length);
      } else {
        _currentIndex =
            (_currentIndex - 1 + _playlist.length) % _playlist.length;
      }
      setCurrentlyPlaying(_playlist[_currentIndex]);
    }
  }

  /// Shuffle the playlist
  void shuffle() {
    if (_playlist.isNotEmpty) {
      _playlist.shuffle();
      _currentIndex = 0;
      setCurrentlyPlaying(_playlist[_currentIndex]);
    }
  }

  /// Volume control
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 100.0);
    player.setVolume(_volume);
    notifyListeners();
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (_isPlaying) {
      player.pause();
    } else {
      player.play();
    }
  }

   void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    player.setRate(_playbackSpeed);
    notifyListeners();
  }

  /// Seek to a specific position
  void seek(Duration position) {
    player.seek(position);
  }

  /// Fast forward
  void fastForward(int seconds) {
    final newPosition = _currentPosition + Duration(seconds: seconds);
    if (_totalDuration != null && newPosition < _totalDuration!) {
      player.seek(newPosition);
    }
  }

  /// Rewind
  void rewind(int seconds) {
    final newPosition = _currentPosition - Duration(seconds: seconds);
    player.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
