import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: kBackgroundColor,
        child: Column(
          children: [
            LibraryItem(
                title: 'Now Playing',
                iconData: MdiIcons.playlistMusic,
                onTap: () {}),
            LibraryItem(
                title: 'Last Session',
                iconData: MdiIcons.timelineClock,
                onTap: () {}),
            LibraryItem(
                title: 'Favourites', iconData: Icons.favorite, onTap: () {}),
            LibraryItem(
                title: 'My Music',
                iconData: MdiIcons.folderMusic,
                onTap: () {}),
            LibraryItem(
                title: 'Downloads',
                iconData: MdiIcons.downloadCircle,
                onTap: () {}),
            LibraryItem(
                title: 'Playlists',
                iconData: MdiIcons.playlistPlay,
                onTap: () {})
          ],
        ));
  }
}

class LibraryItem extends StatelessWidget {
  LibraryItem(
      {required this.iconData, required this.onTap, required this.title});
  final IconData iconData;
  final Function onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBackgroundColor,
      child: ListTile(
        hoverColor: Colors.white,
        leading: Icon(iconData),
        title: Text(title),
        onTap: onTap as void Function()?,
      ),
    );
  }
}
