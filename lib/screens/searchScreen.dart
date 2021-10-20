import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';

class SearchScreen extends StatelessWidget {
  static const String id = 'search_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Container(
          child: null,
        ));
  }
}
//
// class SearchBar extends SearchDelegate<Text> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back));
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return Container();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Container();
//   }
// }
