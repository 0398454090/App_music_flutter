// ignore: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
// ignore: unused_import
import 'package:audioplayers/audioplayers.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      playingSong: playingSong,
      songs: songs,
    );
  }
}

// ignore: must_be_immutable
class NowPlayingPage extends StatefulWidget {
  NowPlayingPage({super.key, required this.playingSong, required this.songs});

  Song playingSong;
  final List<Song> songs;

  ///Gan Am thanh
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  bool isPlaying = false;
  bool isPaused = false;

  ///Gan Am thanh
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    //listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    ////listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  /////////////////KET THUC AM THANH
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //////////////////////////////
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(180),
                  child: Image.network(
                    height: 360,
                    width: 360,
                    widget.playingSong.image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.playingSong.title),
                const SizedBox(height: 8),
                Text(widget.playingSong.artist),
                Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    ///// Optional: Play audio if was paused
                    await audioPlayer.resume();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration)),
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: onPreviousPressed,
                  ),
                  CircleAvatar(
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 50,
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: onNextPressed,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPreviousPressed() {
    final currentIndex = widget.songs.indexOf(widget.playingSong);
    if (currentIndex > 0) {
      final previousSong = widget.songs[currentIndex - 1];
      setState(() {
        widget.playingSong = previousSong;
        setAudioAndPlay(previousSong.source);
      });
    }
  }

  void onNextPressed() {
    final currentIndex = widget.songs.indexOf(widget.playingSong);
    if (currentIndex < widget.songs.length - 1) {
      final nextSong = widget.songs[currentIndex + 1];
      setState(() {
        widget.playingSong = nextSong;
        setAudioAndPlay(nextSong.source);
      });
    }
  }

  Future<void> setAudioAndPlay(String audioUrl) async {
    await audioPlayer.setSourceUrl(audioUrl);
    await audioPlayer.seek(Duration.zero);
    await audioPlayer.play(audioUrl as Source);
  }

  // Hàm xử lý khi nhấn nút phát nhạc
  void onPlayPressed() {
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
    audioPlayer.play(widget.playingSong.source as Source);
  }

  // Hàm xử lý khi nhấn nút tạm dừng nhạc
  void onPausePressed() {
    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  Future<void> setAudio() async {
    // Lấy đường dẫn âm thanh từ đối tượng bài hát hiện đang phát
    String audioSource = widget.playingSong.source;

    // Thiết lập đường dẫn âm thanh cho audioPlayer
    await audioPlayer.setSourceUrl(audioSource);

    // Thiết lập chế độ phát âm thanh
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    super.dispose();

    audioPlayer.dispose();
  }
}
