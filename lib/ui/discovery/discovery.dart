import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';

class DiscoveryTab extends StatefulWidget {
  final List<Song>? songs;

  const DiscoveryTab({Key? key, this.songs}) : super(key: key);

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery Music'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'New Albums', Colors.blue), // Thêm màu sắc cho tiêu đề
            _buildNewAlbums(),
            _buildSectionTitle(
                'Popular Artists', Colors.green), // Thêm màu sắc cho tiêu đề
            _buildPopularArtists(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color, // Sử dụng màu sắc được truyền vào
        ),
      ),
    );
  }

  Widget _buildSongWidget(Song song) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.image,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            song.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            song.artist,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAlbums() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildAlbumWidget('Album $index', 'Artist $index');
        },
      ),
    );
  }

  Widget _buildAlbumWidget(String title, String artist) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/music.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            artist,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularArtists() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: widget.songs != null
            ? widget.songs!
                .map((song) => _buildArtistWidget(song.artist as Song))
                .toList()
            : const [],
      ),
    );
  }

  Widget _buildArtistWidget(Song song) {
    return GestureDetector(
      onTap: () {
        // Thêm hành động khi nhấp vào nghệ sĩ ở đây
        print('Clicked on ${song.artist}');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
        ),
        child: Row(
          children: [
            // Thêm hình ảnh hoặc biểu tượng của nghệ sĩ
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                song.image,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.artist,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Hiển thị thông tin bổ sung như số lượng bài hát hoặc số lượt nghe
                Text(
                  '${song.title} songs • 100K listeners',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Thêm một biểu tượng như biểu tượng phát nhạc hoặc biểu tượng xem chi tiết
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // Thêm hành động khi nhấp vào biểu tượng
                print('Play music by ${song.artist}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
