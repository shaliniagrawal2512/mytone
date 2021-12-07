import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/BottomNavigation.dart';
import 'package:mytone/screens/downloads.dart';
import 'package:mytone/screens/header.dart';
import 'package:mytone/screens/music_library.dart';
import 'package:mytone/screens/playlist.dart';
import 'about.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  String? emailPhone;
  String? name;
  @override
  initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') != null)
      emailPhone = prefs.getString('email');
    else
      emailPhone = emailPhone = prefs.getString('phoneNumber');
    name = prefs.getString('name');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: Material(
        color: kBackgroundColor,
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            children: [
              buildHeader(
                  urlImage: 'images/music5.jpeg',
                  name: '$name',
                  email: '$emailPhone',
                  onClicked: () => selectedItem(context, 5)),
              drawerItem(
                  selected: true,
                  icon: Icons.home,
                  label: "Home",
                  onClicked: () => selectedItem(context, 0)),
              drawerItem(
                  selected: false,
                  icon: Icons.my_library_music,
                  label: "My Music",
                  onClicked: () => selectedItem(context, 1)),
              drawerItem(
                  selected: false,
                  icon: Icons.download_for_offline,
                  label: "Downloads",
                  onClicked: () => selectedItem(context, 2)),
              Divider(
                thickness: 2,
              ),
              drawerItem(
                  selected: false,
                  icon: Icons.playlist_add_check,
                  label: "Playlists",
                  onClicked: () => selectedItem(context, 3)),
              drawerItem(
                  selected: false,
                  icon: Icons.info,
                  label: "About",
                  onClicked: () => selectedItem(context, 4))
            ]),
      ),
    );
  }
}

Widget drawerItem({
  required String label,
  required IconData icon,
  VoidCallback? onClicked,
  required bool selected,
}) {
  final color = selected ? Color(0xFFF9287B) : Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(label, style: TextStyle(color: color)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}

void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();

  switch (index) {
    case 0:
      Navigator.pushNamed(context, BottomNavigation.id);
      break;
    case 1:
      Navigator.pushNamed(context, MusicLibrary.id);
      break;
    case 2:
      Navigator.pushNamed(context, Downloads.id);
      break;
    case 3:
      Navigator.pushNamed(context, PlayList.id);
      break;
    case 4:
      Navigator.pushNamed(context, About.id);
      break;
    case 5:
      Navigator.pushNamed(context, Header.id);
      break;
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required String email,
  required VoidCallback onClicked,
}) =>
    InkWell(
      onTap: onClicked,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(urlImage)),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  name,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF9287B),
                      Color(0xFF7E1CEA),
                    ],
                  ),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
