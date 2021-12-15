import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytone/Services/youtubeServices.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/music_player_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistID;
  final String playlistName;
  final String playlistImage;
  const PlaylistScreen(
      {Key? key,
      required this.playlistID,
      required this.playlistName,
      required this.playlistImage})
      : super(key: key);
  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Video> playList = [];
  bool fetched = false;
  @override
  void initState() {
    if (!fetched) {
      YoutubeService().getPlaylist(widget.playlistID).then((value) {
        if (value.isNotEmpty) {
          setState(() {
            playList = value;
            fetched = true;
          });
        } else {
          fetched = true;
        }
      });
    }
    super.initState();
  }

  Widget getPlaylistTile(index) {
    return ListTile(
        onTap: () async {
          final Map? response = await YoutubeService().formatVideo(
            video: playList[index],
            quality: 'High',
          );
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return MusicPlayer(
                data: {
                  'response': [response],
                  'index': 0,
                  'offline': false,
                  'fromYT': true,
                },
              );
            },
          ));
        },
        leading: SizedBox(
          width: 70,
          child: Card(
            color: kBackgroundColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  errorWidget: (context, _, __) => CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        playList[index].thumbnails.standardResUrl.toString(),
                    errorWidget: (context, _, __) => const Image(
                      image: AssetImage('images/cover.jpg'),
                    ),
                  ),
                  imageUrl: playList[index].thumbnails.maxResUrl.toString(),
                  placeholder: (context, url) => const Image(
                    image: AssetImage('images/cover.jpg'),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          playList[index].title.toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                playList[index].author.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              playList[index]
                  .duration
                  .toString()
                  .split('.')[0]
                  .replaceFirst('0:0', ''),
            ),
          ],
        ),
        trailing: PopupMenuButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            color: Color(0xFF331A4F),
            elevation: 20,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text("search home"),
                  onTap: () {},
                ))
              ];
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  errorWidget: (context, _, __) => const Image(
                    image: AssetImage('images/cover.jpg'),
                  ),
                  imageUrl: widget.playlistImage,
                  placeholder: (context, url) => const Image(
                    image: AssetImage('images/cover.jpg'),
                  ),
                ),
                Text(
                  widget.playlistName,
                  style: kSubHeaderTextStyle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Expanded(
              child: playList.isEmpty
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: ListView.builder(
                          itemCount: playList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              getPlaylistTile(index))))
        ]));
  }
}
