import 'dart:io';
import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/now_playing/audio_slayer_manager.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  //chuyen nhac
  late int _selectedItemIndex;
  late Song _song;

  //xoay dia
  double _currentAnimationPosition = 0.0;
  bool _isShuffle = false;

  @override
  void initState() {
    super.initState();
    //xoay dia
    _currentAnimationPosition = 0.0;
    //next song
    _song = widget.playingSong;
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );

    _audioPlayerManager = AudioPlayerManager(songUrl: _song.source);
    _audioPlayerManager.init();
    //muc dich bai hat hine tai dang phat
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 74;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Now playing ",
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz,
            color: Colors.black,
          ),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_song.album),
              const SizedBox(
                height: 0,
              ),
              const Text('_ ___ _'),
              const SizedBox(
                height: 30,
              ),
              RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/itune_256.png',
                    image: _song.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/itune_256.png',
                        width: screenWidth - delta,
                        height: screenWidth - delta,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 38, bottom: 10),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Column(
                        children: [
                          Text(
                            _song.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _song.artist,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_outline),
                          color: Theme.of(context).colorScheme.primary)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: _progressBar(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: _mediaButtons(),
              )
            ],
          ),
        ),
      ),
    );
  }

  //dispose
  // ignore: unused_element
  void dispose() {
    _audioPlayerManager.dispose();
    _imageAnimController.dispose();
    super.dispose();
  }
  //

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: _setShuffle,
              icon: Icons.shuffle,
              color: _getShuffleColor(),
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: Colors.orange[600],
              size: 36),
          _playButton(),

          ///skip next chuyen nhac
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.orange[600],
              size: 36),
          const MediaButtonControl(
              function: null,
              icon: Icons.repeat,
              color: Colors.deepPurple,
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            //thanh dieu huong
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withOpacity(0.3),
            progressBarColor: Colors.green,
            bufferedBarColor: Colors.blueGrey.withOpacity(0.3),
            thumbColor: Colors.deepPurple,
            thumbGlowColor: Colors.green.withOpacity(0.3),
            thumbRadius: 10.0,
          );
        });
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          _pauseTorationAnin();
          return Container(
            margin: const EdgeInsets.all(8),
            width: 48,
            height: 48,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.play();
              //xoay dia
            },
            icon: Icons.play_arrow,
            color: null,
            size: 48,
          );
        } else if (processingState != ProcessingState.completed) {
          _playRotalAnimation();
          return MediaButtonControl(
              function: () {
                _audioPlayerManager.player.pause();
                _pauseTorationAnin();
                //dung xoay
              },
              icon: Icons.pause,
              color: null,
              size: 48);
        } else {
          //if song completed -> stop and reset animation
          if (processingState == ProcessingState.completed) {
            _stopRotationAnin();
            _resetRotationAnin();
          }
          return MediaButtonControl(
              function: () {
                //xoay dia start animation

                _audioPlayerManager.player.seek(Duration.zero);
                _resetRotationAnin();
                _playRotalAnimation();
              },
              icon: Icons.replay,
              color: null,
              size: 48);
        }
      },
    );
  }

  ///////////////////////////tron nhac
  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getShuffleColor() {
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }

  ///////////////////phat nhac next
  void _setNextSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else {
      ++_selectedItemIndex;
    }
    if (_selectedItemIndex > widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }

    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    // reset animation
    _resetRotationAnin();
    setState(() {
      _song = nextSong;
    });
  }

  void _setPrevSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else {
      --_selectedItemIndex;
    }
    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }

    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _resetRotationAnin();
    // reset animation
    setState(() {
      _song = nextSong;
    });
  }

  void _playRotalAnimation() {
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
  }

  void _pauseTorationAnin() {
    _stopRotationAnin();
    _currentAnimationPosition = _imageAnimController.value;
  }

  void _stopRotationAnin() {
    _imageAnimController.stop();
  }

  void _resetRotationAnin() {
    _currentAnimationPosition = 0.0;
    _imageAnimController.value = _currentAnimationPosition;
  }
}

//kiem soat bai hat
class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
