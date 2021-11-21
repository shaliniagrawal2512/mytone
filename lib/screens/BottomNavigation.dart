import 'package:flutter/material.dart';
import 'package:mytone/components/miniPlayer.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/SearchField.dart';
import 'package:mytone/screens/homeScreen.dart';
import 'package:mytone/screens/Library.dart';
import 'package:mytone/screens/profile.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    SearchField(),
    Library(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu_sharp),
          onPressed: () {},
        ),
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
        backgroundColor: Color(0xFF36274A),
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
    );
  }
}
