import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(
    config: const PlayerConfig(
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
        flags: AndroidAudioFlags.none,
      ),
      respectSilence: false,
      duckAudio: false,
    ),
  );


  late VideoPlayerController _videoController;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Video background setup
    _videoController = VideoPlayerController.asset("assets/meditation.mp4")
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.setVolume(0.0);
        _videoController.play();
        setState(() {});
      });

    // Audio setup
    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((_) => setState(() {
      isPlaying = false;
      _position = Duration.zero;
    }));
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('meditation.mp3'));
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_videoController.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          Container(color: Colors.black.withOpacity(0.5)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Relax & Meditate",
                  style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 40),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 80, color: Colors.white),
                onPressed: _togglePlayPause,
              ),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                },
              ),
              Text("${formatTime(_position)} / ${formatTime(_duration)}",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
