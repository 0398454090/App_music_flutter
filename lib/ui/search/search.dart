import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/source/source.dart';
import 'package:music_app/ui/now_playing/playing.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  TextEditingController controller = TextEditingController();
  final List<Song> _searchResult = [];
  List<Song> _song = [];
  late DataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = RemoteDataSource();
    loadData();
  }

  void loadData() async {
    List<Song>? songs = await _dataSource.loadData();
    if (songs != null) {
      setState(() {
        _song = songs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 23, 21, 21),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[500],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black87),
                  ),
                  onChanged: onSearchTextChanged,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black87),
                onPressed: () {
                  // Xử lý khi người dùng nhấn vào biểu tượng hủy
                  controller.clear();
                  onSearchTextChanged('');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 23, 21, 21),
        child: ListView.builder(
          itemCount: _searchResult.length,
          itemBuilder: (context, i) {
            return Card(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    _searchResult[i].title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    _searchResult[i].artist,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                          playingSong: _searchResult[i],
                          songs: _song,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  onSearchTextChanged(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var song in _song) {
      if (song.title.toLowerCase().contains(text.toLowerCase()) ||
          song.artist.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(song);
      }
    }

    setState(() {});
  }
}
