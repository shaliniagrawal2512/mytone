import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytone/components/miniPlayer.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/models/user.dart';
import 'package:mytone/screens/SearchField.dart';
import 'package:mytone/screens/homeScreen.dart';
import 'package:mytone/screens/Library.dart';
import 'package:mytone/screens/profile.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:mytone/screens/slideSheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BottomNavigation extends StatefulWidget {
  static const String id = 'BottomNavigation';
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final currentUser = FirebaseAuth.instance.currentUser;
  UserData loggedInUser = UserData();
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    SearchField(),
    Library(),
    Profile()
  ];
  Future<bool> _onBackPressed() async {
    bool isExit = false;
    await Alert(
      context: context,
      style: AlertStyle(
          backgroundColor: kBackgroundColor,
          isOverlayTapDismiss: false,
          descStyle: TextStyle(color: Colors.white),
          titleStyle: TextStyle(color: Colors.white)),
      type: AlertType.none,
      title: "Exit",
      desc: "Do u really want to exit the app??",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            isExit = false;
            Navigator.pop(context);
          },
          color: Color(0xFFF9287B),
          radius: BorderRadius.circular(5.0),
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            isExit = true;
            Navigator.pop(context);
          },
          color: Color(0xFF7E1CEA),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
    return isExit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: NavigationDrawer(),
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: GradientText(
            "MyTone",
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
        body: Column(children: [
          Expanded(child: IndexedStack(index: currentIndex, children: screens)),
          MiniPlayer()
        ]),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          backgroundColor: Color(0xFA36274A),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_special_rounded), label: 'library'),
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit_sharp), label: 'profile')
          ],
        ),
      ),
    );
  }
}
