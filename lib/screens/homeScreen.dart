import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void selectedIndex(int value) {
    setState(() {
      if (value != currentIndex) {
        currentIndex = value;
        if (currentIndex == 1)
          showSearch(context: context, delegate: SearchBar());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF36274A),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xFFF9287B),
            Color(0xFF7E1CEA),
          ],
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectedIndex,
        currentIndex: currentIndex,
        //backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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

class SearchBar extends SearchDelegate<Text> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
