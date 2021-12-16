import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytone/Services/youtubeServices.dart';
import 'package:mytone/components/EmptyScreen.dart';
import 'package:mytone/constants.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'music_player_screen.dart';

class YouTubeSearch extends StatefulWidget {
  final String query;
  const YouTubeSearch({Key? key, required this.query}) : super(key: key);
  @override
  State<YouTubeSearch> createState() => _YouTubeSearchState();
}

class _YouTubeSearchState extends State<YouTubeSearch> {
  String query = '';
  List<Video> searchedList = [];
  bool fetched = false;
  final TextEditingController _controller = TextEditingController();
  void initState() {
    _controller.text = widget.query;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getResults() {
    YoutubeService()
        .fetchSearchResults(query == '' ? _controller.text : query)
        .then((value) {
      setState(() {
        searchedList = value;
        fetched = true;
      });
    });
  }

  Widget buildResults(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () async {
          final Map? response = await YoutubeService()
              .formatVideo(video: searchedList[index], quality: 'High');
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return MusicPlayer(
              data: {
                'response': [response],
                'index': 0,
                'offline': false,
                'fromYT': true,
              },
            );
          }));
        },
        child: Card(
          color: Color(0xFF421452),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) =>
                    const Image(image: AssetImage('images/cover.jpg')),
                imageUrl: searchedList[index].thumbnails.maxResUrl,
                placeholder: (context, url) => const Image(
                  image: AssetImage('images/cover.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 4, top: 15),
                child: Text(
                  searchedList[index].title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        searchedList[index].author,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(searchedList[index]
                          .duration
                          .toString()
                          .split('.')[0]
                          .replaceFirst('0:0', ''))
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!fetched) {
      getResults();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          leadingWidth: 15,
          title: TextField(
              controller: _controller,
              decoration: kSearchFieldDecoration.copyWith(
                  suffixIcon: IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_controller.text != widget.query &&
                                _controller.text.length >= 1) {
                              fetched = false;
                              searchedList.clear();
                              setState(() {});
                            }
                          })))),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: kBackgroundColor,
          child: (!fetched)
              ? SizedBox(
                  child: Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.width / 7,
                        width: MediaQuery.of(context).size.width / 7,
                        child: const CircularProgressIndicator()),
                  ),
                )
              : searchedList.isEmpty
                  ? EmptyScreen().emptyScreen(context, 0, ':( ', 100, 'sorry',
                      60, 'resultsNotFound', 20)
                  : SingleChildScrollView(
                      child: ListView.builder(
                          itemCount: searchedList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, idx) {
                            return buildResults(idx);
                          }),
                    ),
        ));
  }
}
