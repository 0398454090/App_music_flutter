import 'package:flutter/material.dart';

class SettingTab extends StatelessWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục Profile
            },
            hoverColor: Colors.grey.withOpacity(0.5), // Hiệu ứng khi hover
            tileColor: Colors
                .transparent, // Để sử dụng hoverColor, cần đặt màu nền trong suốt
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục Notifications
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Security'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục Security
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục Language
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục Help & Support
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào mục About
            },
          ),
        ],
      ),
    );
  }
}
