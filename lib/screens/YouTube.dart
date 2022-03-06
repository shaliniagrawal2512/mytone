import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import 'package:mytone/Services/youtubeServices.dart';
import 'package:mytone/screens/YouTubeSearchPage.dart';
import 'package:mytone/screens/playlistScreen.dart';
import '../constants.dart';

class YouTubeHome extends StatefulWidget {
  const YouTubeHome({Key? key}) : super(key: key);

  @override
  _YouTubeHomeState createState() => _YouTubeHomeState();
}

class _YouTubeHomeState extends State<YouTubeHome> {
  List showList = [];
  List pageList = [];
  TextEditingController searchController = TextEditingController();
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    getHomePlaylist();
  }

  void getHomePlaylist() {
    if (!fetched) {
      YoutubeService().getMusicHome().then((value) {
        fetched = true;
        if (value.isNotEmpty) {
          setState(() {
            showList = value['body'] ?? [];
            pageList = value['head'] ?? [];
          });
        } else {
          fetched = true;
        }
      });
    }
  }

  Widget getPageListWidget(index, double boxSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, top: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return YouTubeSearch(
                    query: pageList[index]['title'].toString());
              },
            ),
          );
        },
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          errorWidget: (context, _, __) =>
              const Image(image: AssetImage('images/ytCover.jpg')),
          imageUrl: pageList[index]['image'].toString(),
          imageBuilder: (context, imageProvider) => Container(
              width: 270.0,
              height: boxSize / 4,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              )),
          placeholder: (context, url) => const Image(
            image: AssetImage('images/ytCover.jpg'),
          ),
        ),
      ),
    );
  }

  Widget getPlaylistItemWidget(var item, double boxSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          item['type'] == 'video'
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return YouTubeSearch(query: item['title'].toString());
                    },
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlaylistScreen(
                            playlistID: item['playlistId'].toString(),
                            playlistImage: item['imageStandard'].toString(),
                            playlistName: item['title'].toString(),
                          )),
                );
        },
        child: SizedBox(
          width: item['type'] != 'playlist' ? boxSize / 3 : boxSize / 4,
          child: Column(
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => Image(
                  image: item['type'] != 'playlist'
                      ? const AssetImage('images/ytCover.jpg')
                      : const AssetImage('images/album.jpg'),
                ),
                imageUrl: item['image'].toString(),
                placeholder: (context, url) => Image(
                  image: item['type'] != 'playlist'
                      ? const AssetImage('images/ytCover.jpg')
                      : const AssetImage('images/album.jpg'),
                ),
                imageBuilder: (context, imageProvider) => Container(
                    width: 270.0,
                    height: boxSize / 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    )),
              ),
              Text(
                '${item["title"]}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item['type'] != 'video'
                    ? '${item["count"]} Tracks | ${item["description"]}'
                    : '${item["count"]} | ${item["description"]}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          TextField(
              onChanged: (value) {
                setState(() {});
              },
              keyboardType: TextInputType.url,
              controller: searchController,
              decoration: kSearchFieldDecoration.copyWith(
                  prefixIcon: null,
                  hintText: 'Search on Youtube',
                  suffixIcon: IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: Container(
                        width: 100,
                        child: Row(
                          children: [
                            searchController.text.length >= 1
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      setState(() {});
                                    })
                                : Icon(Icons.clear, color: Colors.grey),
                            IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return YouTubeSearch(
                                            query: searchController.text);
                                      },
                                    ),
                                  );
                                })
                          ],
                        ),
                      )))),
          Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
              if (pageList.isNotEmpty)
                Container(
                  height: boxSize / 4,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pageList.length,
                      itemBuilder: (context, index) =>
                          getPageListWidget(index, boxSize)),
                ),
              if (showList.isEmpty)
                SizedBox(
                  height: boxSize / 2,
                  child: Center(
                    child: const CircularProgressIndicator(),
                  ),
                )
              else
                ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: showList.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(
                            '${showList[index]["title"]}',
                            style: kYoutubeHeadTextStyle,
                            gradient: LinearGradient(colors: kColorList),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                              height: boxSize / 3.2,
                              width: double.infinity,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                itemCount:
                                    (showList[index]['playlists'] as List)
                                        .length,
                                itemBuilder: (context, idx) {
                                  final item =
                                      showList[index]['playlists'][idx];
                                  return getPlaylistItemWidget(item, boxSize);
                                },
                              ))
                        ],
                      );
                    })
            ])),
          )
        ]));
  }
}
