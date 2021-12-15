import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Container(
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
                controller: searchController,
                decoration: kSearchFieldDecoration.copyWith(
                    suffixIcon: IconTheme(
                        data: IconThemeData(color: Colors.white),
                        child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              searchController.text = "";
                            })))))
      ]),
    );
  }
}
