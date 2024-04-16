import 'package:flutter/material.dart';

class DiscoveryTab extends StatelessWidget {
  const DiscoveryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Music'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SongSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 19, 15, 15),
              Color.fromARGB(221, 15, 14, 14)
            ],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _buildFolderItem('Folder 1', Colors.red, 'assets/music.png'),
            _buildFolderItem('Folder 2', Colors.yellow, 'assets/music.png'),
            _buildFolderItem('Folder 3', Colors.orange, 'assets/music.png'),
            _buildFolderItem('Folder 4', Colors.purple, 'assets/music.png'),
            _buildFolderItem('Folder 3', Colors.orange, 'assets/music.png'),
            _buildFolderItem('Folder 4', Colors.purple, 'assets/music.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderItem(String folderName, Color color, String imagePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: color,
      child: InkWell(
        onTap: () {
          // Xử lý sự kiện khi nhấn vào một thư mục
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            Center(
              child: Text(
                folderName,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Các hành động trong trường tìm kiếm (ví dụ: clear input field)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Kết quả tìm kiếm được hiển thị ở đây
    return Container(
      child: Center(
        child: Text('Search results for: $query'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Gợi ý tìm kiếm được hiển thị ở đây (ví dụ: từ khóa tìm kiếm gần đúng)
    return Container();
  }
}
