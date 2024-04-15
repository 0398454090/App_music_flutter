import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/viewmodel.dart';
import 'package:music_app/ui/now_playing/playing.dart';
import 'package:music_app/ui/settings/settings.dart';
// ignore: unused_import
import 'package:music_app/ui/search/search.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      color: const Color.fromARGB(255, 255, 255, 255),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 109, 20),
        ),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = [
    const HomeTabs(),
    const DiscoveryTab(),
    const SearchBarApp(),
    const SettingTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music App'),
        backgroundColor: Color.fromARGB(255, 0, 109, 20),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.album), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Setting'),
          ],
        ),
        tabBuilder: (BuildContext context, index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;
  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
      parent: this,
      song: songs[index],
    );
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

//xu ly xu kien
  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
                height: 400,
                color: Colors.blueGrey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal boder sheet'),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(
                                context,
                              ),
                          child: const Text('Close Bottom Sheet')),
                    ],
                  ),
                )),
          );
        });
  }

  void navigate(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) {
        return NowPlaying(
          songs: songs,
          playingSong: song,
        );
      }),
    );
  }
  //ket thuc xu ly su kien
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.parent, required this.song});

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 24, right: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/music.png',
            image: song.image,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/music.png',
                width: 48,
                height: 48,
              );
            },
          ),
        ),
        title: Text(song.title),
        subtitle: Text(song.artist),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            parent.showBottomSheet();
          },
        ),
        //Su kien
        onTap: () {
          parent.navigate(song);
        });
  }
}
