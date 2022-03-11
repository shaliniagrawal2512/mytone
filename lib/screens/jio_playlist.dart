import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mytone/API/jiosaavnapi.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/music_player_screen.dart';

class JioPlaylist extends StatefulWidget {
  final Map listItem;

  const JioPlaylist({
    Key? key,
    required this.listItem,
  }) : super(key: key);
  @override
  State<JioPlaylist> createState() => _JioPlaylistState();
}

class _JioPlaylistState extends State<JioPlaylist> {
  bool status = false;
  List playList = [];
  bool fetched = false;
  HtmlUnescape unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
  }

  getDuration(int n) {
    String minute = (n ~/ 60).toString();
    String seconds = (n % 60).toString();
    if (minute.length <= 1) minute = '0$minute';
    if (seconds.length <= 1) seconds = '0$seconds';
    return ("$minute:$seconds");
  }

  Widget getPlaylistTile(index) {
    return ListTile(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return MusicPlayer(
              data: {
                'index': 0,
                'offline': false,
                'fromYT': false,
              },
            );
          },
        ));
      },
      leading: SizedBox(
        child: Card(
          color: kBackgroundColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            errorWidget: (context, _, __) =>
                const Image(image: AssetImage('images/cover.jpg')),
            imageUrl: playList[index]['image'].toString(),
            placeholder: (context, url) => const Image(
              image: AssetImage('images/cover.jpg'),
            ),
          ),
        ),
      ),
      title: Text(
        playList[index]['title'].toString(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              playList[index]['artist'].toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(getDuration(int.parse(playList[index]['duration']))),
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
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!status) {
      status = true;
      switch (widget.listItem['type'].toString()) {
        case 'song':
          SaavnAPI()
              .fetchSongSearchResults(widget.listItem['id'].toString(), '20')
              .then((value) {
            setState(() {
              playList = value;
              fetched = true;
            });
          });
          break;
        case 'album':
          SaavnAPI()
              .fetchAlbumSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              playList = value;
              fetched = true;
            });
          });
          break;
        case 'playlist':
          SaavnAPI()
              .fetchPlaylistSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              playList = value;
              fetched = true;
            });
          });
          break;
        default:
          break;
      }
    }
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
                  width: MediaQuery.of(context).size.width,
                  errorWidget: (context, _, __) => const Image(
                    image: AssetImage('images/cover.jpg'),
                  ),
                  imageUrl: widget.listItem['image'],
                  placeholder: (context, url) => const Image(
                    image: AssetImage('images/cover.jpg'),
                  ),
                ),
                Text(
                  widget.listItem['title'],
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
