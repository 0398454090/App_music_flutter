import 'package:flutter/material.dart';
import 'package:music_app/data/repository/repository.dart';
import './ui/home/home.dart';

Future<void> main() async {
  runApp(const MusicApp());

  WidgetsFlutterBinding.ensureInitialized();
  var repository = DefaultRepository();
  var songs = await repository.loadData();
  if (songs != null) {
    for (var song in songs) {
      debugPrint(song.toString());
    }
  }
}
