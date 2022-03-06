import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';

class SearchField extends StatefulWidget {
  final String query;
  const SearchField({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String query = '';
  bool status = false;
  Map searchedData = {};
  Map position = {};
  List sortedKeys = [];
  final ValueNotifier<List<String>> topSearch = ValueNotifier<List<String>>([]);
  bool fetched = false;
  bool albumFetched = false;
  List search = [];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = widget.query;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchResults() async {
    fetched = true;
    albumFetched = true;
    setState(() {});
  }

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
