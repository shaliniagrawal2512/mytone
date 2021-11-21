import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytone/components/customSlider.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/required_icon.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  static const String id = 'musicPlayer_screen';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(
                        image: AssetImage('images/music10.jpg'),
                        fit: BoxFit.fill)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Rim Jhim',
              style: kSubHeaderTextStyle,
            ),
            Text('Jubin Nautiyal,Ami mishra * Rim Jhim'),
            CustomSlider(
              handlerHeight: 25,
              trackHeight: 4.5,
              inactiveTrackHeight: 4,
              thumbIconSize: 13,
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
                    playMusic(
                        'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3');
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
        ),
      ),
    );
  }
}
