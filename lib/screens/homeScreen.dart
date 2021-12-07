import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytone/components/RadioList.dart';
import 'package:mytone/components/playlist_creation.dart';
import 'package:mytone/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  UserData loggedInUser = UserData();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get()
        .then((value) async {
      this.loggedInUser = UserData.fromMap(value.data());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', loggedInUser.name!);
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hello ${loggedInUser.name} !!!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          PlayList(title: 'Trending Now'),
          PlayList(title: 'Top Charts'),
          PlayList(title: 'New Releases'),
          RadioList(title: 'Radio Stations'),
          PlayList(title: 'Editorial Picks'),
          PlayList(title: 'What\'s Hot in there'),
          PlayList(title: 'Fresh Hits'),
          PlayList(title: 'Hindi Top Songs'),
          RadioList(title: 'Recommended Artists Radio'),
          PlayList(title: 'English all time Favourites'),
          PlayList(title: 'Top Artists'),
          PlayList(title: 'Top Geners and Moods'),
          PlayList(title: 'Devotional'),
        ]),
      ),
    );
  }
}
