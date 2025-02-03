import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muzn/app_localization.dart';
import 'package:quran/quran.dart';

class AudioPlayerScreen extends StatefulWidget {
  final int surahNumber;
  final int? ayahNumber;

  const AudioPlayerScreen({
    Key? key,
    required this.surahNumber,
    this.ayahNumber,
  }) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = true;
  String? _errorMessage;
  bool _isRepeatMode = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      String surahAudioUrl = getAudioURLBySurah(widget.surahNumber);

      await _audioPlayer.setUrl(surahAudioUrl);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading audio: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleRepeatMode() {
    setState(() {
      _isRepeatMode = !_isRepeatMode;
    });
    _audioPlayer.setLoopMode(
      _isRepeatMode ? LoopMode.one : LoopMode.off,
    );
  }

  void _changePlaybackSpeed(double speed) {
    _audioPlayer.setSpeed(speed);
  }

  // Reusable method to show snack bar
  void _showPlaybackSnackBar(String message, double speed) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 204, 55, 44),
        content: Text(message + '  $speed',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.3,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Reusable method to generate IconButton for playback controls
  IconButton _buildPlaybackButton(IconData icon, double speed, String message) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        _changePlaybackSpeed(speed);
        _showPlaybackSnackBar(message, speed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'surah'.tr(context) + getSurahNameArabic(widget.surahNumber),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 10,
                  )
                  : _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        )
                      : StreamBuilder<Duration>(
                          stream: _audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Text(
                              position.toString().split('.').first,
                              style: TextStyle(fontSize: 24),
                            );
                          },
                        ),
            ),
          ),
          // Fixed Row at the Bottom
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Column(
              children: [
                // Seek Bar
                StreamBuilder<Duration>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(  
                      stream: _audioPlayer.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return Slider(
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Theme.of(context).primaryColor.withAlpha(100),
                          thumbColor: Theme.of(context).primaryColor,
                        );
                      },
                    );
                  },
                ),
                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Repeat Button
                    IconButton(
                      icon: Icon(
                        _isRepeatMode ? Icons.repeat_one : Icons.repeat,
                        color: _isRepeatMode ? Colors.blue : Colors.black,
                      ),
                      onPressed: _toggleRepeatMode,
                    ),
                    // Decrease Playback Speed
                    _buildPlaybackButton(
                      Icons.fast_rewind,
                      0.5,
                      'decrease_playback_speed'.tr(context),
                    ),
                    // Play/Pause Button
                    StreamBuilder<PlayerState>(
                      stream: _audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        return IconButton(
                          icon: Icon(
                            playerState?.playing == true
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 36,
                          ),
                          onPressed: () {
                            if (playerState?.playing == true) {
                              _audioPlayer.pause();
                            } else {
                              _audioPlayer.play();
                            }
                          },
                        );
                      },
                    ),
                    // Increase Playback Speed
                    _buildPlaybackButton(
                      Icons.fast_forward,
                      1.5,
                      'increase_playback_speed'.tr(context),
                    ),
                    // Stop Button
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: _audioPlayer.stop,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
