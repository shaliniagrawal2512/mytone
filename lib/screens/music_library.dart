import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import '../constants.dart';

class MusicLibrary extends StatelessWidget {
  static const String id = 'music_library';
  Widget profileItem(IconData icon, String label, Function onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon, size: 25),
        title: Text(
          label,
          style: TextStyle(fontSize: 20),
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: GradientText(
          "My Music",
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9287B),
              Color(0xFF7E1CEA),
            ],
          ),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: Container(
        child: ListView(
          children: [
            profileItem(Icons.music_note, 'Songs', () {}),
            profileItem(Icons.playlist_play, 'Playlists (Local)', () {}),
          ],
        ),
      ),
    );
  }
}
