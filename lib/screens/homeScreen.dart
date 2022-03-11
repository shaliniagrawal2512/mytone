import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytone/API/jiosaavnapi.dart';
import 'package:mytone/components/EmptyScreen.dart';
import 'package:mytone/components/playlist_creation.dart';
import 'package:mytone/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

var finalResult;
List<dynamic>? titles;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  UserData loggedInUser = UserData();
  String name = '';
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    getHomePageData();
    getUserData();
  }

  getUserData() {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get()
          .then((value) async {
        this.loggedInUser = UserData.fromMap(value.data());
        name = loggedInUser.name!;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', loggedInUser.name!);
      });
    } catch (e) {}
    setState(() {});
  }

  Future<void> getHomePageData() async {
    try {
      var receivedData = await SaavnAPI().fetchHomePageData();
      titles = receivedData.keys.toList();
      finalResult = receivedData;
    } catch (e) {}
    fetched = true;
    print("hello");
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(" Hello $name !!!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Expanded(
            child: finalResult != null
                ? SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: titles!.length - 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return titles![index] == 'global_config'
                              ? Container(height: 1)
                              : PlayList(
                                  title: titles![index]
                                      .replaceAll(RegExp('_'), " "),
                                  data: finalResult[titles![index].toString()]);
                        }))
                : fetched
                    ? EmptyScreen().emptyScreen(context, 1, "Error", 40,
                        "Check Internet Connection", 15, '', 2)
                    : Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
