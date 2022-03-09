import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isPlaying = false;
  bool isPaused = false;
  bool looping = false;
  bool isRepeat = false;
  double currentSpeed = 1;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  double thumb = 0;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  void playMusic(String url) async {
    if (isPlaying) {
      audioPlayer.pause();
      isPlaying = false;
      setState(() {});
    } else {
      audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
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

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  @override
  void initState() {
    res = widget.data['response'] as List;
    title = res[0]['title'].toString();
    url = res[0]['url'].toString();

    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
      audioPlayer.onAudioPositionChanged.listen((p) {
        setState(() {
          _position = p;
        });
      });
      audioPlayer.onPlayerCompletion.listen((event) {
        isPlaying = false;
        _position = Duration(seconds: 0);
        setState(() {});
      });
    });
    audioPlayer.setUrl(url);
    audioPlayer.play(url);
    isPlaying = true;
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
              0.2,
              0.88,
              1.0,
            ],
                colors: [
              //
              Color(0xcc7e1cea),
              Color(0xcc5711ae),
              kBackgroundColor,
              Color(0x80F9287B),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              getCustomIcon(Icons.my_library_music),
                              getCustomIcon(Icons.share),
                              getCustomIcon(Icons.more_vert),
                            ]),
                      )
                    ],
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      height: 350,
                      fit: BoxFit.cover,
                      errorWidget: (context, _, __) =>
                          const Image(image: AssetImage('images/cover.jpg')),
                      imageUrl: res[0]['image'].toString(),
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
                  SizedBox(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 13.0),
                        thumbColor: Color(0xFFF9287B),
                        activeTrackColor: Color(0xFF7E1CEA),
                        overlayColor: Colors.white),
                    child: Slider(
                      min: 0.0,
                      max: _duration.inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          changeToSecond(value.toInt());
                          value = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_position.toString().split(".")[0]),
                      Text(_duration.toString().split(".")[0])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OtherButton(
                        color: isRepeat ? Colors.pink : null,
                        iconData: Icons.replay_outlined,
                        onPressed: () {
                          if (isRepeat == false) {
                            isRepeat = true;
                            audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                          } else {
                            isRepeat = false;
                            audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
                          }
                          setState(() {});
                        },
                        iconSize: 25,
                        radius: 20,
                      ),
                      OtherButton(
                        iconData: Icons.skip_previous,
                        onPressed: () {
                          currentSpeed -= 0.25;
                          audioPlayer.setPlaybackRate(currentSpeed);
                        },
                        iconSize: 30,
                        radius: 35,
                      ),
                      RequiredIcon(
                        iconData: isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: () {
                          playMusic(url);
                        },
                        iconSize: 40,
                        radius: isPlaying ? 30 : 50,
                      ),
                      OtherButton(
                        iconData: Icons.skip_next,
                        onPressed: () {
                          currentSpeed += 0.25;
                          audioPlayer.setPlaybackRate(currentSpeed);
                        },
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Text("Speed: $currentSpeed X"),
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
