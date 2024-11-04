import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:winamp/models/custom_theme.dart';
import 'package:winamp/models/eq_config_item.dart';
import 'package:winamp/models/notifiers/player_state_notifier.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';
import 'package:winamp/widgets/equalizer_modal.dart';

class AudioPlayerGlobalWidget extends StatefulWidget {
  const AudioPlayerGlobalWidget({super.key});

  @override
  State<AudioPlayerGlobalWidget> createState() =>
      _AudioPlayerGlobalWidgetState();
}

class _AudioPlayerGlobalWidgetState extends State<AudioPlayerGlobalWidget> {
  List<EQConfigItem> equalizerConfigItems = List.generate(
    10,
    (index) => EQConfigItem(
        centerFrequency: [
      60.0,
      170.0,
      320.0,
      600.0,
      1000.0,
      3000.0,
      6000.0,
      12000.0,
      14000.0,
      16000.0
    ][index]),
  );
  double preampValue = 0.0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Show Equalizer Modal
  void _showEqualizerModal(BuildContext context, CustomTheme customTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: customTheme.playerBackgroundColorObj,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EqualizerModal(
        onEqualizerChanged: (configItems, preamp) {
          equalizerConfigItems = configItems;
          preampValue = preamp;
          _applyEqualizer();
        },
      ),
    );
  }

  void _applyEqualizer() {
    final player = context.read<PlayerStateNotifier>().player;
    List<String> eqSettings = equalizerConfigItems
        .map((item) =>
            'equalizer=f=${item.centerFrequency}:width_type=${item.widthType}:width=${item.width}:g=${item.gain}')
        .toList();
    if (player.platform is NativePlayer) {
      (player.platform as NativePlayer)
        ..setProperty("filter", preampValue.toString())
        ..setProperty("af", eqSettings.join(','));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _sliderValue = 0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    var customTheme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Consumer<PlayerStateNotifier>(
      builder: (context, playerState, child) {
        final track = playerState.currentlyPlaying;

        // Update _sliderValue only if not dragging
        if (!_isDragging) {
          _sliderValue = playerState.currentPosition.inMilliseconds
              .toDouble()
              .clamp(
                  0, playerState.totalDuration?.inMilliseconds.toDouble() ?? 0);
        }

        return Material(
          color: customTheme.playerBackgroundColorObj,
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.space): const PlayPauseIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                PlayPauseIntent: CallbackAction<PlayPauseIntent>(
                  onInvoke: (intent) => playerState.togglePlayPause(),
                ),
              },
              child: Focus(
                autofocus: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  color: customTheme.playerBackgroundColorObj,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (track?.albumArt != null)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Image.memory(
                                track!.albumArt!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: customTheme.playerActionColorObj,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.double_music_note,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track?.title ?? 'No song selected',
                                  style: TextStyle(
                                      color: customTheme.textColorObj,
                                      fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  track?.artistName ?? '',
                                  style: TextStyle(
                                      color: customTheme.textColorObj,
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.backward_fill,
                                  color: customTheme.playerActionColorObj,
                                  size: 24,
                                ),
                                onPressed: playerState.previousTrack,
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.gobackward_10,
                                  color: customTheme.playerActionColorObj,
                                  size: 24,
                                ),
                                onPressed: track != null
                                    ? () {
                                        playerState.rewind(10);
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  playerState.isPlaying
                                      ? CupertinoIcons.pause_circle_fill
                                      : CupertinoIcons.play_circle_fill,
                                  color: customTheme.playerActionColorObj,
                                  size: 32,
                                ),
                                onPressed: track != null
                                    ? playerState.togglePlayPause
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.goforward_10,
                                  color: customTheme.playerActionColorObj,
                                  size: 24,
                                ),
                                onPressed: track != null
                                    ? () {
                                        playerState.fastForward(10);
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.forward_fill,
                                  color: customTheme.playerActionColorObj,
                                  size: 24,
                                ),
                                onPressed: playerState.nextTrack,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.volume_up,
                                color: customTheme.playerActionColorObj,
                              ),
                              SizedBox(
                                width: 100,
                                child: Slider.adaptive(
                                  value: playerState.volume,
                                  min: 0.0,
                                  max: 100.0,
                                  divisions: 10,
                                  onChanged: (value) {
                                    playerState.setVolume(value);
                                  },
                                  activeColor: customTheme.playerActionColorObj,
                                  inactiveColor: Colors.white54,
                                  thumbColor: customTheme.playerActionColorObj,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.shuffle_thick,
                              color: playerState.isShuffle
                                  ? customTheme.playerActionColorObj
                                  : Colors.white,
                              size: 24,
                            ),
                            onPressed: playerState.toggleShuffle,
                          ),
                          const SizedBox(width: 8),

                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.timer_fill,
                                color: customTheme.playerActionColorObj,
                              ),
                              SizedBox(
                                width: 80,
                                child: DropdownButton<double>(
                                  value: playerState.playbackSpeed,
                                  items: [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                                      .map((speed) {
                                    return DropdownMenuItem<double>(
                                      value: speed,
                                      child: Text(
                                        '${speed}x',
                                        style: TextStyle(
                                            color: customTheme
                                                .playerActionColorObj),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      playerState.setPlaybackSpeed(value);
                                    }
                                  },
                                  dropdownColor: Colors.grey[800],
                                  underline: Container(),
                                  iconEnabledColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.slider_horizontal_3,
                              color: customTheme.playerActionColorObj,
                              size: 24,
                            ),
                            onPressed: () {
                              _showEqualizerModal(context, customTheme);
                            },
                          ),
                        ],
                      ),
                      // Progress Slider and Timing
                      if (playerState.totalDuration != null &&
                          playerState.totalDuration!.inMilliseconds > 0)
                        Column(
                          children: [
                            Slider.adaptive(
                              activeColor: customTheme.playerActionColorObj,
                              thumbColor: customTheme.playerActionColorObj,
                              inactiveColor: Colors.white54,
                              value: _sliderValue,
                              min: 0,
                              max: playerState.totalDuration!.inMilliseconds
                                  .toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _sliderValue = value;
                                  _isDragging = true;
                                });
                              },
                              onChangeEnd: (value) {
                                final position =
                                    Duration(milliseconds: value.toInt());
                                playerState.seek(position);
                                _isDragging = false;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(Duration(
                                      milliseconds: _sliderValue.toInt())),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                Text(
                                  _formatDuration(playerState.totalDuration!),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        // Placeholder slider and default timing
                         Column(
                          children: [
                            Slider.adaptive(
                              value: 0,
                              min: 0,
                              max: 1,
                              onChanged: null,
                              thumbColor: customTheme.playerActionColorObj,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '00:00',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                Text(
                                  '00:00',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PlayPauseIntent extends Intent {
  const PlayPauseIntent();
}
