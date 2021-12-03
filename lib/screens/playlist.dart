import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import 'package:mytone/models/playlist.dart';
import '../constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayList extends StatelessWidget {
  static const String id = 'playlist';
  Widget profileItem(IconData icon, String label, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap as void Function()?,
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
          "Playlist",
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
      body: Column(
        children: [
          profileItem(Icons.add, 'Create Playlist', () {}),
          profileItem(Icons.input, 'Import from File', () {}),
          profileItem(MdiIcons.spotify, 'Import from Spotify', () {}),
          profileItem(MdiIcons.youtube, 'Import from YouTube', () {}),
          Expanded(
              child: ListView.builder(
                  itemCount: PlayListAdd().playListCount,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    UnmodifiableListView<Playlist> albums =
                        PlayListAdd().allPlayLists;
                    return NewPlaylist(title: albums[index].title);
                  })),
        ],
      ),
    );
  }
}

class NewPlaylist extends StatelessWidget {
  NewPlaylist({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: PhysicalModel(
          color: kBackgroundColor,
          elevation: 4,
          shadowColor: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/album.jpg'),
              ),
            ),
          ),
        ),
        title: Text(title),
        trailing: InkWell(
          child: Icon(Icons.more_vert),
          onTap: () {},
        ),
      ),
    );
  }
}
