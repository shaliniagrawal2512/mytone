import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytone/components/customSlider.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/required_icon.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:audioplayers/audioplayers.dart';

List res = [];
String title = '';
String url = '';

class MusicPlayer extends StatefulWidget {
  static const String id = 'musicPlayer_screen';
  MusicPlayer({required this.data});
  final Map data;
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool? isPlaying = false;
  double radius = 50;
  IconData icon = Icons.play_arrow;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  void playMusic(String url) async {
    if (isPlaying!) {
      audioPlayer.pause();
      isPlaying = false;
      setState(() {
        radius = 50;
        icon = Icons.play_arrow;
      });
    } else {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          radius = 30;
          icon = Icons.pause;
        });
      }
    }
  }

  Widget getCustomIcon(IconData customIcon) {
    return GradientIconButton(
      icon: Icon(customIcon),
      onPressed: () {},
      gradient: LinearGradient(
        colors: [
          Color(0xFFF9287B),
          Color(0xFF7E1CEA),
        ],
      ),
    );
  }

  @override
  void initState() {
    res = widget.data['response'] as List;
    title = res[0]['title'].toString();
    url = res[0]['url'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [
              0.0,
              0.1,
              0.9,
              1.0,
            ],
                colors: [
              //
              Color(0xFF7E1CEA),
              kBackgroundColor,
              kBackgroundColor,
              Color(0xFFF9287B),
            ])),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      getCustomIcon(Icons.expand_more),
                      Expanded(
                        child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              getCustomIcon(Icons.my_library_music),
                              getCustomIcon(Icons.share),
                              getCustomIcon(Icons.more_vert),
                            ]),
                      )
                    ],
                  ),
                  Container(
                    height: 350,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      errorWidget: (context, _, __) =>
                          const Image(image: AssetImage('assets/cover.jpg')),
                      imageUrl: res[0]['image'].toString(),
                      imageBuilder: (context, imageProvider) => Container(
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          )),
                      placeholder: (context, url) => const Image(
                        image: AssetImage('images/cover.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(title.split(' (')[0].split('|')[0].trim(),
                      style: kSubHeader2TextStyle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Text(
                      '${res[0]['album'].toString()} * ${res[0]['artist'].toString()}'),
                  CustomSlider(
                    handlerHeight: 25,
                    trackHeight: 4.5,
                    inactiveTrackHeight: 4,
                    thumbIconSize: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.0'),
                      Text(
                          '${res[0]['duration'].split('3')[0].replaceFirst('0:0', '')}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OtherButton(
                        iconData: Icons.replay_outlined,
                        onPressed: () {},
                        iconSize: 25,
                        radius: 20,
                      ),
                      OtherButton(
                        iconData: Icons.skip_previous,
                        onPressed: () {},
                        iconSize: 30,
                        radius: 35,
                      ),
                      RequiredIcon(
                        iconData: icon,
                        onPressed: () {
                          playMusic(url);
                        },
                        iconSize: 40,
                        radius: radius,
                      ),
                      OtherButton(
                        iconData: Icons.skip_next,
                        onPressed: () {},
                        iconSize: 30,
                        radius: 35,
                      ),
                      OtherButton(
                        iconData: Icons.shuffle,
                        onPressed: () {},
                        iconSize: 25,
                        radius: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border),
                          iconSize: 30),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.file_download_outlined),
                          iconSize: 30)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(Icons.expand_less_sharp),
                        GradientText("Now Playing",
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF9287B),
                                Color(0xFF7E1CEA),
                              ],
                            ),
                            style: kSubHeader2TextStyle),
                      ],
                    ),
                  )
                ],
              )
            ])),
      ),
    );
  }
}
