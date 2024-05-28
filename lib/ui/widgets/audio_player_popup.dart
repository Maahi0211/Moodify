import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerPopup extends StatefulWidget {
  final List<dynamic> tracks;
  final int initialIndex;

  const AudioPlayerPopup({
    //Key? key,
    super.key,
    required this.tracks,
    required this.initialIndex,
  }) ;//: super(key: key);

  @override
  _AudioPlayerPopupState createState() => _AudioPlayerPopupState();
}

class _AudioPlayerPopupState extends State<AudioPlayerPopup> {
  late AudioPlayer _audioPlayer;
  late int currentIndex;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    _initializeAndPlayTrack();
  }

  Future<void> _initializeAndPlayTrack() async {
    final track = widget.tracks[currentIndex];
    await _audioPlayer.setUrl(track['preview_url']);
    _audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void _playPauseTrack() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextTrack() {
    if (currentIndex < widget.tracks.length - 1) {
      currentIndex++;
      _initializeAndPlayTrack();
    }
  }

  void _previousTrack() {
    if (currentIndex > 0) {
      currentIndex--;
      _initializeAndPlayTrack();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<Duration> get _positionStream => Rx.combineLatest2<Duration, Duration?, Duration>(
        _audioPlayer.positionStream,
        _audioPlayer.durationStream,
        (position, duration) => position,
      );

  @override
  Widget build(BuildContext context) {
    final track = widget.tracks[currentIndex];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.network(track['album']['images'][0]['url']),
              title: Text(track['name']),
              subtitle: Text(track['artists'][0]['name']),
            ),
            StreamBuilder<Duration>(
              stream: _positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      min: 0,
                      max: _audioPlayer.duration?.inMilliseconds.toDouble() ?? 0,
                      value: position.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(position.toString().split('.').first),
                        Text((_audioPlayer.duration ?? Duration.zero).toString().split('.').first),
                      ],
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _previousTrack,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPauseTrack,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _nextTrack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
