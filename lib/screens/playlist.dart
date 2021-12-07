import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import 'package:mytone/components/textDialogBox.dart';
import 'package:mytone/models/playlist.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayList extends StatefulWidget {
  static const String id = 'playlist';

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
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
            profileItem(
              Icons.add,
              'Create Playlist',
              () async {
                await TextInputDialog().showTextInputDialog(
                    context: context,
                    title: "Create New Playlist",
                    initialText: '',
                    onSubmitted: (String value) {
                      Provider.of<PlayListAdd>(context, listen: false)
                          .addNewPlayList(value);
                      Navigator.pop(context);
                    });
              },
            ),
            profileItem(Icons.input, 'Import from File', () {}),
            profileItem(MdiIcons.spotify, 'Import from Spotify', () {}),
            profileItem(MdiIcons.youtube, 'Import from YouTube', () {}),
            Expanded(child: Consumer<PlayListAdd>(
              builder: (context, playListAdd, child) {
                return ListView.builder(
                    itemCount: playListAdd.playListCount,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      Playlist albums = playListAdd.allPlayLists[index];
                      bool valid = false;
                      if (index == 0) valid = true;
                      return NewPlaylist(
                        title: albums.title,
                        valid: valid,
                        album: albums,
                      );
                    });
              },
            ))
          ],
        ));
  }
}

class NewPlaylist extends StatelessWidget {
  Widget moreItem(String label, IconData icon, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap as void Function()?,
    );
  }

  NewPlaylist({required this.title, required this.valid, required this.album});
  final String title;
  final bool valid;
  final Playlist album;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: PhysicalModel(
          color: kBackgroundColor,
          elevation: 10,
          shadowColor: Color(0xFF7E1CEA),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: valid
                    ? AssetImage('images/cover.jpg')
                    : AssetImage('images/album.jpg'),
              ),
            ),
          ),
        ),
        title: Text(title),
        trailing: PopupMenuButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          color: Color(0xFF331A4F),
          elevation: 20,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return valid
                ? <PopupMenuEntry>[
                    PopupMenuItem(
                        child: moreItem('Export', Icons.import_export, () {})),
                    PopupMenuItem(child: moreItem('Share', Icons.share, () {})),
                  ]
                : <PopupMenuEntry>[
                    PopupMenuItem(
                        child: valid
                            ? null
                            : moreItem('Rename', Icons.edit, () async {
                                await TextInputDialog().showTextInputDialog(
                                    context: context,
                                    title: "Rename Playlist",
                                    onSubmitted: (String value) {
                                      Provider.of<PlayListAdd>(context,
                                              listen: false)
                                          .renamePlaylist(album, value);
                                      Navigator.pop(context);
                                    });
                                Navigator.pop(context);
                              })),
                    PopupMenuItem(
                        child: moreItem('Delete', Icons.delete, () {
                      Provider.of<PlayListAdd>(context, listen: false)
                          .removePlaylist(album);
                      Navigator.pop(context);
                    })),
                    PopupMenuItem(
                        child: moreItem('Export', Icons.import_export, () {})),
                    PopupMenuItem(child: moreItem('Share', Icons.share, () {})),
                  ];
          },
        ),
      ),
    );
  }
}
